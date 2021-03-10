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

}
