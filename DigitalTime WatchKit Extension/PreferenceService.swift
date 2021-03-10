//
//  PreferenceService.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-10.
//

import Foundation
import ClockKit

enum PreferenceType: String {
  case timeFormat
  case shortDateFormat
  case longDateFormat
}

class PreferenceService {
  static let shared = PreferenceService()
  private let userDefaults = UserDefaults.standard

  var timeFormat: DateAndTimeFormat.TimeFormatIdentifier
  var shortDateFormat: DateAndTimeFormat.ShortDateFormatIdentifier
  var longDateFormat: DateAndTimeFormat.LongDateFormatIdentifier

  private init() {
    if let timeFormatInt = userDefaults.value(forKey: PreferenceType.timeFormat.rawValue) as? Int,
       let loadedTimeFormat = DateAndTimeFormat.TimeFormatIdentifier(rawValue: timeFormatInt) {
        timeFormat = loadedTimeFormat
    } else {
      timeFormat = .twelveHour
    }
    if let shortDateFormatInt = userDefaults.value(forKey: PreferenceType.shortDateFormat.rawValue) as? Int,
       let loadedShortDateFormat = DateAndTimeFormat.ShortDateFormatIdentifier(rawValue: shortDateFormatInt) {
      shortDateFormat = loadedShortDateFormat
    } else {
      shortDateFormat = .weekdayDay
    }
    if let longDateFormatInt = userDefaults.value(forKey: PreferenceType.longDateFormat.rawValue) as? Int,
       let loadedLongDateFormat = DateAndTimeFormat.LongDateFormatIdentifier(rawValue: longDateFormatInt) {
      longDateFormat = loadedLongDateFormat
    } else {
      longDateFormat = .weekdayMonthDay
    }
  }

  func getValue<T: DateAndTimeFormatIdentifier>(for preferenceType: PreferenceType) -> T {
    switch preferenceType {
    case .timeFormat:
      guard let timeFormat = timeFormat as? T else { fatalError() }
      return timeFormat
    case .shortDateFormat:
      guard let shortDateFormat = shortDateFormat as? T else { fatalError() }
      return shortDateFormat
    case .longDateFormat:
      guard let longDateFormat = longDateFormat as? T else { fatalError() }
      return longDateFormat
    }
  }

  func set<T: DateAndTimeFormatIdentifier>(_ preferenceType: PreferenceType, to value: T) {
    switch preferenceType {
    case .timeFormat:
      guard let newTimeFormat = value as? DateAndTimeFormat.TimeFormatIdentifier else { fatalError() }
      userDefaults.setValue(newTimeFormat.rawValue, forKey: preferenceType.rawValue)
      timeFormat = newTimeFormat
    case .shortDateFormat:
      guard let newShortDateFormat = value as? DateAndTimeFormat.ShortDateFormatIdentifier else { fatalError() }
      userDefaults.setValue(newShortDateFormat.rawValue, forKey: preferenceType.rawValue)
      shortDateFormat = newShortDateFormat
    case .longDateFormat:
      guard let newLongDateFormat = value as? DateAndTimeFormat.LongDateFormatIdentifier else { fatalError() }
      userDefaults.setValue(newLongDateFormat.rawValue, forKey: preferenceType.rawValue)
      longDateFormat = newLongDateFormat
    }
    reloadComplications()
  }

  func reloadComplications() {
    CLKComplicationServer.sharedInstance().activeComplications?.forEach { complication in
      CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
    }
  }
}
