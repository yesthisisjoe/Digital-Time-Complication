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
  let complicationServer = CLKComplicationServer.sharedInstance()
  let notificationCenter = NotificationCenter.default

  private let timeUntilBackgroundTask: TimeInterval = 15 * 60
  private let foregroundComplicationTimelineLength: TimeInterval = 30 * 60
  private let backgroundComplicationTimelineLength: TimeInterval = 1000 * 60
  var complicationTimelineLength: TimeInterval

  private let initialUpdateTimeEstimate: TimeInterval = 10.0
  private let updateTimeEstimateTimeout: TimeInterval = 15.0
  private let updateTimeEstimateMultiplier: Double = 1.2

  private var isSlowUpdate = false
  private var lastUpdateStart: Date?
  private var lastUpdateLength: TimeInterval?
  private var hideUpdateViewWorkItem: DispatchWorkItem?
  private var currentBackgroundTask: WKApplicationRefreshBackgroundTask?
  @Published var showUpdateView: Bool = false

  private init() {
    complicationTimelineLength = foregroundComplicationTimelineLength
    notificationCenter.addObserver(
      self,
      selector: #selector(useForegroundComplicationTimelineLength),
      name: WKExtension.applicationDidBecomeActiveNotification,
      object: nil)
    notificationCenter.addObserver(
      self,
      selector: #selector(useBackgroundComplicationTimelineLength),
      name: WKExtension.applicationDidEnterBackgroundNotification,
      object: nil)
  }

  @objc func useForegroundComplicationTimelineLength() {
    appLogger.logAndWrite("Using foreground timeline length")
    complicationTimelineLength = foregroundComplicationTimelineLength
  }

  @objc func useBackgroundComplicationTimelineLength() {
    appLogger.logAndWrite("Using background timeline length")
    complicationTimelineLength = backgroundComplicationTimelineLength
  }

  func reloadComplications() {
    complicationServer.activeComplications?.forEach { complication in
      appLogger.logAndWrite("🟢 Reloading timeline")
      complicationServer.reloadTimeline(for: complication)
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

  func extendComplications(backgroundTask: WKApplicationRefreshBackgroundTask) {
    scheduleBackgroundTaskForNextComplicationUpdate()
    complicationServer.activeComplications?.forEach { complication in
      appLogger.logAndWrite("🔵 Extending timeline")
      complicationServer.extendTimeline(for: complication)
    }
    backgroundTask.setTaskCompletedWithSnapshot(false)
  }

  func complicationUpdateStarted() {
    isSlowUpdate = numberOfSlowComplications() > 0
    if isSlowUpdate {
      showUpdateView = true
    }

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

  func scheduleBackgroundTaskForNextComplicationUpdate() {
    let preferredDate = Date(timeIntervalSinceNow: timeUntilBackgroundTask)
    WKExtension.shared().scheduleBackgroundRefresh(
      withPreferredDate: preferredDate,
      userInfo: nil) { error in
      if let error = error {
        appLogger.logAndWrite("🔴 Couldn't schedule background refresh. Error: \(error)")
      } else {
        let loggerDate = appLogger.loggerString(forDate: preferredDate)
        appLogger.logAndWrite("🟣 BG task set for \(loggerDate)")
      }
    }
  }
  func scheduleUpdateViewDismissal(after timeInterval: TimeInterval) {
    hideUpdateViewWorkItem?.cancel()
    hideUpdateViewWorkItem = DispatchWorkItem { [weak self] in
      appLogger.logAndWrite("🔴 Complication refreshed")
      self?.lastUpdateStart = nil
      self?.lastUpdateLength = nil
      if self?.isSlowUpdate == true {
        self?.showUpdateView = false
      }
      WKInterfaceDevice.current().play(.click)
    }
  }
}
