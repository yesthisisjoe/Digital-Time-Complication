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

  let timeUntilBackgroundTask: TimeInterval = 15 * 60
  let foregroundComplicationTimelineLength: TimeInterval = 30 * 60
  let backgroundComplicationTimelineLength: TimeInterval = 1000 * 60

  var complicationTimelineLength: TimeInterval

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
  }

  func extendComplications(backgroundTask: WKApplicationRefreshBackgroundTask) {
    scheduleBackgroundTaskForNextComplicationUpdate()
    complicationServer.activeComplications?.forEach { complication in
      appLogger.logAndWrite("🔵 Extending timeline")
      complicationServer.extendTimeline(for: complication)
    }
    backgroundTask.setTaskCompletedWithSnapshot(false)
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
}
