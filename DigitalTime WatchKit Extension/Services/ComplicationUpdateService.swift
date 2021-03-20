//
//  ComplicationUpdateService.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-19.
//

import Foundation

class ComplicationUpdateService: ObservableObject {
  static let shared = ComplicationUpdateService()
  private init() {}

  let minimumUpdateViewDisplayTime: TimeInterval = 5.0
  let updateTimeEstimateTimeout: TimeInterval = 15.0
  let updateTimeEstimateMultiplier: Double = 1.2

  var lastUpdateStart: Date?
  var lastUpdateLength: TimeInterval?
  var hideUpdateViewWorkItem: DispatchWorkItem?

  @Published var showUpdateView: Bool = false

  func complicationUpdateStarted() {
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
        estimatedTimeUntilUpdateFinish = max(lastUpdateLength ?? 0, minimumUpdateViewDisplayTime)
      }
    } else {
      NSLog("No previous update found")
      estimatedTimeUntilUpdateFinish = max(lastUpdateLength ?? 0, minimumUpdateViewDisplayTime)
    }
    NSLog("Estimated time until update finish: \(estimatedTimeUntilUpdateFinish)")
    lastUpdateStart = Date()
    scheduleUpdateViewDismissal(after: estimatedTimeUntilUpdateFinish)
  }

  func scheduleUpdateViewDismissal(after timeInterval: TimeInterval) {
    hideUpdateViewWorkItem?.cancel()
    hideUpdateViewWorkItem = DispatchWorkItem { [weak self] in
      NSLog("----- HIDING UPDATE VIEW -----")
      self?.lastUpdateStart = nil
      self?.lastUpdateLength = nil
      self?.showUpdateView = false
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: hideUpdateViewWorkItem!)
  }
}
