//
//  DateAndTimeFormatter.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import Foundation

struct DateAndTimeFormatter {
  static func formattedTime(
    fromDate date: Date,
    withIdentifier identifier: DateAndTimeFormat.TimeFormatIdentifier) -> String {
    let timeFormat = DateAndTimeFormat.timeFormat(identifier: identifier)
    return formattedDateOrTime(fromDate: date, withDateFormat: timeFormat)
  }

  static func shortenedFormattedTime(
    fromDate date: Date,
    withIdentifier identifier: DateAndTimeFormat.TimeFormatIdentifier) -> String {
    if identifier == .twelveHourAmPm {
      return formattedTime(fromDate: date, withIdentifier: .twelveHour)
    } else {
      return formattedTime(fromDate: date, withIdentifier: identifier)
    }
  }

  static func multilineFormattedTime(
    fromDate date: Date,
    withIdentifier identifier: DateAndTimeFormat.TimeFormatIdentifier) -> [String] {
    if identifier == .twelveHourAmPm {
      return formattedTime(fromDate: date, withIdentifier: identifier).components(separatedBy: .whitespaces)
    } else {
      return [formattedTime(fromDate: date, withIdentifier: identifier)]
    }
  }

  static func formattedShortDate(
    fromDate date: Date,
    withIdentifier identifier: DateAndTimeFormat.ShortDateFormatIdentifier) -> String {
    let shortDateFormat = DateAndTimeFormat.shortDateFormat(identifier: identifier)
    return formattedDateOrTime(fromDate: date, withDateFormat: shortDateFormat)
  }

  static func formattedLongDate(
    fromDate date: Date,
    withIdentifier identifier: DateAndTimeFormat.LongDateFormatIdentifier) -> String {
    let longDateFormat = DateAndTimeFormat.longDateFormat(identifier: identifier)
    return formattedDateOrTime(fromDate: date, withDateFormat: longDateFormat)
  }

  static func formattedDateOrTime(fromDate date: Date, withDateFormat dateFormat: DateAndTimeFormat) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat.dateFormat
    return dateFormatter.string(from: date)
  }
}
