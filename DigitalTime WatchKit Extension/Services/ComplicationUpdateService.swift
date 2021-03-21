//
//  ComplicationUpdateService.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-19.
//

import ClockKit
import Foundation
import WatchKit

class ComplicationUpdateService: ObservableObject {
  static let shared = ComplicationUpdateService()
  private init() {}

  private let initialUpdateTimeEstimate: TimeInterval = 10.0
  private let updateTimeEstimateTimeout: TimeInterval = 15.0
  private let updateTimeEstimateMultiplier: Double = 1.2

  private var lastUpdateStart: Date?
  private var lastUpdateLength: TimeInterval?
  private var hideUpdateViewWorkItem: DispatchWorkItem?

  @Published var showUpdateView: Bool = false

  func reloadComplications() {
    CLKComplicationServer.sharedInstance().activeComplications?.forEach { complication in
      CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
    }
    NSLog("Number of slow complications: \(numberOfSlowComplications())")
  }

  func numberOfSlowComplications() -> Int {
    var numberOfSlowComplications = 0
    CLKComplicationServer.sharedInstance().activeComplications?.forEach { complication in
      switch (complication.family, complication.identifier) {
      case (.graphicBezel, ComplicationIdentifier.dateAndTime),
           (.graphicBezel, ComplicationIdentifier.time),
           (.graphicBezel, ComplicationIdentifier.timeAndDate),
           (.graphicCircular, ComplicationIdentifier.time),
           (.graphicCorner, ComplicationIdentifier.time):
        numberOfSlowComplications += 1
      default:
        break
      }
    }
    return numberOfSlowComplications
  }

  func complicationUpdateStarted() {
    if numberOfSlowComplications() < 1 { return }

    showUpdateView = true
    var estimatedTimeUntilUpdateFinish: TimeInterval
    if let lastUpdateStart = lastUpdateStart {
      let timeSinceLastUpdate = Date().timeIntervalSince(lastUpdateStart)
      if timeSinceLastUpdate < updateTimeEstimateTimeout {
        NSLog("Found previous update \(timeSinceLastUpdate) ago")
        lastUpdateLength = timeSinceLastUpdate
        estimatedTimeUntilUpdateFinish = timeSinceLastUpdate * updateTimeEstimateMultiplier
      } else {
        NSLog("Previous update length too long: \(timeSinceLastUpdate)")
        estimatedTimeUntilUpdateFinish = max(lastUpdateLength ?? 0, initialUpdateTimeEstimate)
      }
    } else {
      NSLog("No previous update found")
      estimatedTimeUntilUpdateFinish = max(lastUpdateLength ?? 0, initialUpdateTimeEstimate)
    }
    NSLog("Estimated time until update finish: \(estimatedTimeUntilUpdateFinish)")
    lastUpdateStart = Date()
    scheduleUpdateViewDismissal(after: estimatedTimeUntilUpdateFinish)
  }

  func scheduleUpdateViewDismissal(after timeInterval: TimeInterval) {
    hideUpdateViewWorkItem?.cancel()
    hideUpdateViewWorkItem = DispatchWorkItem { [weak self] in
      NSLog("Hiding update view")
      self?.lastUpdateStart = nil
      self?.lastUpdateLength = nil
      self?.showUpdateView = false
      WKInterfaceDevice.current().play(.click)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: hideUpdateViewWorkItem!)
  }
}
