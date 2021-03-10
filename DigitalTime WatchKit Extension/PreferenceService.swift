//
//  PreferenceService.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-10.
//

import Foundation

enum PreferenceType {
  case time
  case shortDate
  case longDate
}

class PreferenceService {
  static let shared = PreferenceService()
  var timeFormat: DateAndTimeFormat.TimeFormatIdentifier
  var shortDateFormat: DateAndTimeFormat.ShortDateFormatIdentifier
  var longDateFormat: DateAndTimeFormat.LongDateFormatIdentifier

  private init() {
    timeFormat = .twelveHour
    shortDateFormat = .weekdayDay
    longDateFormat = .weekdayMonthDay
  }

  func getValue<T: DateAndTimeFormatIdentifier>(for preferenceType: PreferenceType) -> T {
    switch preferenceType {
    case .time:
      guard let timeFormat = timeFormat as? T else { fatalError() }
      return timeFormat
    case .shortDate:
      guard let shortDateFormat = shortDateFormat as? T else { fatalError() }
      return shortDateFormat
    case .longDate:
      guard let longDateFormat = longDateFormat as? T else { fatalError() }
      return longDateFormat
    }
  }

  func set<T: DateAndTimeFormatIdentifier>(_ preferenceType: PreferenceType, to value: T) {
    switch preferenceType {
    case .time:
      guard let newTimeFormat = value as? DateAndTimeFormat.TimeFormatIdentifier else { fatalError() }
      timeFormat = newTimeFormat
    case .shortDate:
      guard let newShortDateFormat = value as? DateAndTimeFormat.ShortDateFormatIdentifier else { fatalError() }
      shortDateFormat = newShortDateFormat
    case .longDate:
      guard let newLongDateFormat = value as? DateAndTimeFormat.LongDateFormatIdentifier else { fatalError() }
      longDateFormat = newLongDateFormat
    }
  }

}
