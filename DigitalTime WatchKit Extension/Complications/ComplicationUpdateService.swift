//
//  ComplicationUpdateService.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-19.
//

import Foundation

class ComplicationUpdateService {
  let minimumUpdateViewDisplayTime: TimeInterval = 5.0
  let updateTimeEstimateTimeout: TimeInterval = 15.0
  let updateTimeEstimateMultiplier: Double = 1.2

  var lastUpdateStart: Date?
  var lastUpdateLength: TimeInterval?
  var estimatedUpdateFinish: Date?

  func complicationUpdateStarted() {
    if let lastUpdateStart = lastUpdateStart {
      let timeSinceLastUpdate = Date().timeIntervalSince(lastUpdateStart)
      if timeSinceLastUpdate < updateTimeEstimateTimeout {
        NSLog("Found previous update \(timeSinceLastUpdate) ago")
        lastUpdateLength = timeSinceLastUpdate
        let estimatedTimeUntilUpdateFinish = timeSinceLastUpdate * updateTimeEstimateMultiplier
        NSLog("Estimated update finish in \(estimatedTimeUntilUpdateFinish)")
        estimatedUpdateFinish = Date(timeIntervalSinceNow: estimatedTimeUntilUpdateFinish)
      } else {
        NSLog("Previous update length too long: \(timeSinceLastUpdate)")
        let minimumOrLastUpdateLength = max(lastUpdateLength ?? 0, minimumUpdateViewDisplayTime)
        NSLog("Estimating update finish in \(minimumOrLastUpdateLength)")
        estimatedUpdateFinish = Date(timeIntervalSinceNow: minimumOrLastUpdateLength)
      }
    } else {
      NSLog("No previous update found")
      let minimumOrLastUpdateLength = max(lastUpdateLength ?? 0, minimumUpdateViewDisplayTime)
      NSLog("Estimating update finish in \(minimumOrLastUpdateLength)")
      estimatedUpdateFinish = Date(timeIntervalSinceNow: minimumOrLastUpdateLength)
    }
    lastUpdateStart = Date()
  }
}
