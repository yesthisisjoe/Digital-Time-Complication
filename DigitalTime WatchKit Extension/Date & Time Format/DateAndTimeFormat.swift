//
//  DateAndTimeFormat.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-06.
//

import Foundation

struct DateAndTimeFormat: Hashable {
    var name: String
    var dateFormat: String
    fileprivate init(name: String, format: String) {
        self.name = name
        self.dateFormat = format
    }

    static let timeFormats = [
        DateAndTimeFormat(
           name: "12-hour",
           format: "h:mm"),
        DateAndTimeFormat(
            name: "12-hour AM/PM",
            format: "h:mm a"),
        DateAndTimeFormat(
            name: "24-hour",
            format: "k:mm")
    ]
    static let shortDateFormats = [
        DateAndTimeFormat(
            name: "Weekday & day",
            format: "EEE d"),
        DateAndTimeFormat(
            name: "Month & day",
            format: "MMM d")
    ]
    static let longDateFormats = [
        DateAndTimeFormat(
            name: "Weekday, month & day",
            format: "EEEE, MMMM d"),
        DateAndTimeFormat(
            name: "Weekday & day",
            format: "EEEE d"),
        DateAndTimeFormat(
            name: "Month & day",
            format: "MMMM d")
    ]
}
