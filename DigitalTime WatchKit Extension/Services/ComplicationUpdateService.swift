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

  func reloadComplications() {
    appLogger.logAndWrite("🟢 Reloading timeline")
    complicationServer.activeComplications?.forEach { complication in
      complicationServer.reloadTimeline(for: complication)
    }
  }

  func extendComplications(backgroundTask: WKApplicationRefreshBackgroundTask) {
    appLogger.logAndWrite("🔵 Extending timeline")
    complicationServer.activeComplications?.forEach { complication in
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
