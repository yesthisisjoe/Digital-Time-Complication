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
  private var currentBackgroundTask: WKApplicationRefreshBackgroundTask?

  func reloadComplications(_ backgroundTask: WKApplicationRefreshBackgroundTask? = nil) {
    self.currentBackgroundTask = backgroundTask
    CLKComplicationServer.sharedInstance().activeComplications?.forEach { complication in
      CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
    }
  }

  func complicationUpdateStarted() {
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
      appLogger.notice("🔴 Complication refreshed")
      self?.lastUpdateStart = nil
      self?.lastUpdateLength = nil
      self?.currentBackgroundTask?.setTaskCompletedWithSnapshot(false)
      self?.currentBackgroundTask = nil
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: hideUpdateViewWorkItem!)
  }
}
