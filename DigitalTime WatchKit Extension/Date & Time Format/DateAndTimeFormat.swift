//
//  DateAndTimeFormat.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-06.
//

import Foundation

protocol DateAndTimeFormatIdentifier: CaseIterable, Hashable {}

struct DateAndTimeFormat {
    enum TimeFormatIdentifier: DateAndTimeFormatIdentifier {
        case twelveHour
        case twelveHourAmPm
        case twentyFourHour
    }

    enum ShortDateFormatIdentifier: DateAndTimeFormatIdentifier {
        case weekdayDay
        case monthDay
    }

    enum LongDateFormatIdentifier: DateAndTimeFormatIdentifier {
        case weekdayMonthDay
        case weekdayDay
        case monthDay
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
            format: "k:mm")
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
