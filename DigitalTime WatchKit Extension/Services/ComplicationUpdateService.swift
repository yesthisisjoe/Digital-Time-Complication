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

  let complicationServer = CLKComplicationServer.sharedInstance()
  let complicationTimelineLength: TimeInterval = 15 * 60
  let timeUntilBackgroundTask: TimeInterval = 15 * 60

  var currentBackgroundTask: WKApplicationRefreshBackgroundTask?

  func reloadComplications() {
    appLogger.notice("🟢 Reloading complications")
    self.currentBackgroundTask = nil
    complicationServer.activeComplications?.forEach { complication in
      complicationServer.reloadTimeline(for: complication)
    }
  }

  func extendComplications(backgroundTask: WKApplicationRefreshBackgroundTask) {
    appLogger.notice("🔵 Extending complications")
    self.currentBackgroundTask = backgroundTask
    complicationServer.activeComplications?.forEach { complication in
      complicationServer.extendTimeline(for: complication)
    }
  }

  func startedOrResumedLoadingComplications() {
    scheduleBackgroundTaskForNextComplicationUpdate()
  }

  func finishedLoadingComplications() {
    appLogger.notice("🔴 Finished loading complications")
    self.currentBackgroundTask?.setTaskCompletedWithSnapshot(false)
    self.currentBackgroundTask = nil
  }

  func scheduleBackgroundTaskForNextComplicationUpdate() {
    let preferredDate = Date(timeIntervalSinceNow: timeUntilBackgroundTask)
    WKExtension.shared().scheduleBackgroundRefresh(
      withPreferredDate: preferredDate,
      userInfo: nil) { error in
      if let error = error {
        NSLog("Couldn't schedule background refresh. Error: \(error)")
      } else {
        NSLog("Successfully scheduled background refresh for \(preferredDate)")
      }
    }
  }
}
