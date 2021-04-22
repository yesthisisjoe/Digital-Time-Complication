//
//  DateAndTimeFormat.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-06.
//

import Foundation

protocol DateAndTimeFormatIdentifier: CaseIterable, Hashable {}

struct DateAndTimeFormat {
  enum TimeFormatIdentifier: Int, DateAndTimeFormatIdentifier {
    case twelveHour = 0
    case twelveHourAmPm = 1
    case twentyFourHour = 2
  }

  enum ShortDateFormatIdentifier: Int, DateAndTimeFormatIdentifier {
    case weekdayDay = 0
    case monthDay = 1
  }

  enum LongDateFormatIdentifier: Int, DateAndTimeFormatIdentifier {
    case weekdayMonthDay = 0
    case weekdayDay = 1
    case monthDay = 2
  }

  var name: String
  var dateFormat: String
  fileprivate init(name: String, format: String) {
    self.name = name
    self.dateFormat = format
  }

  static let timeFormatDict: [TimeFormatIdentifier: DateAndTimeFormat] = [
    .twelveHour: DateAndTimeFormat(
      name: "12-Hour",
      format: "h:mm"),
    .twelveHourAmPm: DateAndTimeFormat(
      name: "12-Hour AM/PM",
      format: "h:mm a"),
    .twentyFourHour: DateAndTimeFormat(
      name: "24-Hour",
      format: "H:mm")
  ]

  static let shortDateDict: [ShortDateFormatIdentifier: DateAndTimeFormat] = [
    .weekdayDay: DateAndTimeFormat(
      name: "Weekday & Day",
      format: "EEE d"),
    .monthDay: DateAndTimeFormat(
      name: "Month & Day",
      format: "MMM d")
  ]

  static let longDateDict: [LongDateFormatIdentifier: DateAndTimeFormat] = [
    .weekdayMonthDay: DateAndTimeFormat(
      name: "Weekday, Month & Day",
      format: "EEEE, MMMM d"),
    .weekdayDay: DateAndTimeFormat(
      name: "Weekday & Day",
      format: "EEEE d"),
    .monthDay: DateAndTimeFormat(
      name: "Month & Day",
      format: "MMMM d")
  ]

  static func timeFormat(identifier: TimeFormatIdentifier) -> DateAndTimeFormat {
    return timeFormatDict[identifier]!
  }

  static func shortDateFormat(identifier: ShortDateFormatIdentifier) -> DateAndTimeFormat {
    return shortDateDict[identifier]!
  }

  static func longDateFormat(identifier: LongDateFormatIdentifier) -> DateAndTimeFormat {
    return longDateDict[identifier]!
  }

  static func anyFormat<T: DateAndTimeFormatIdentifier>(identifier: T) -> DateAndTimeFormat? {
    if let timeIdentifier = identifier as? TimeFormatIdentifier {
      return timeFormat(identifier: timeIdentifier)
    } else if let shortDateIdentifier = identifier as? ShortDateFormatIdentifier {
      return shortDateFormat(identifier: shortDateIdentifier)
    } else if let longDateIdentifier = identifier as? LongDateFormatIdentifier {
      return longDateFormat(identifier: longDateIdentifier)
    } else {
      return nil
    }
  }
}
