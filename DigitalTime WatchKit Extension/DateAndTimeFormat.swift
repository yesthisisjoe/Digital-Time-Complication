//
//  DateAndTimeFormat.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-06.
//

import Foundation

struct DateAndTimeFormat {
    var name: String
    var dateFormat: String
    fileprivate init(name: String, format: String) {
        self.name = name
        self.dateFormat = format
    }
}

enum TimeFormat {
    static let twelveHour = DateAndTimeFormat(
        name: "12-hour",
        format: "h:mm")
    static let twelveHourAmPm = DateAndTimeFormat(
        name: "12-hour AM/PM",
        format: "h:mm a")
    static let twentyFourHour = DateAndTimeFormat(
        name: "24-hour",
        format: "k:mm")
}

enum ShortDateFormat {
    static let weekdayDay = DateAndTimeFormat(
        name: "Weekday & day",
        format: "EEE d")
    static let monthDay = DateAndTimeFormat(
        name: "Month & day",
        format: "MMM d")
}

enum LongDateFormat {
    static let weekdayMonthDay = DateAndTimeFormat(
        name: "Weekday, month & day",
        format: "EEEE, MMMM d")
    static let weekdayDay = DateAndTimeFormat(
        name: "Weekday & day",
        format: "EEEE d")
    static let monthDay = DateAndTimeFormat(
        name: "Month & day",
        format: "MMMM d")
}
