//
//  DateAndTimeFormatter.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import Foundation

struct DateAndTimeFormatter {
    static func formattedDateOrTime(fromDate date: Date, withDateFormat dateFormat: DateAndTimeFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.dateFormat
        return dateFormatter.string(from: date)
    }
}
