//
//  PreferenceRow.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import SwiftUI

struct PreferenceRow: View {
    var title: String
    var format: DateAndTimeFormat
    var exampleDate: Date

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(DateAndTimeFormatter.formattedDateOrTime(fromDate: exampleDate, withDateFormat: format))
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

struct PreferenceRow_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceRow(title: "Time Style", format: TimeFormat.twelveHourAmPm, exampleDate: Date())
    }
}
