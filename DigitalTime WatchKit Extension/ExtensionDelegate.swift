//
//  ExtensionDelegate.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-04-20.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
  func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    for task in backgroundTasks {
      switch task {
      case let backgroundTask as WKApplicationRefreshBackgroundTask:
        NSLog("Refreshing complication from background task")
        ComplicationUpdateService.shared.reloadComplications(backgroundTask)
      default:
        task.setTaskCompletedWithSnapshot(false)
      }
    }
  }
}
