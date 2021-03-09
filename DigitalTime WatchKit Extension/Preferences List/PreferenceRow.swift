//
//  PreferenceRow.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import SwiftUI

struct PreferenceRow<T: DateAndTimeFormatIdentifier>: View {
    var title: String
    var exampleDate: Date
    var formats: [T]
    @State private var selectedFormat = T.allCases.first!

    var body: some View {
        Picker(title, selection: $selectedFormat) {
            ForEach(formats, id: \.self) {
                let format = DateAndTimeFormat.anyFormat(identifier: $0)!
                Text(format.name) +
                    Text("\n") +
                    Text(DateAndTimeFormatter.formattedDateOrTime(
                            fromDate: exampleDate,
                            withDateFormat: format))
                    .italic()
            }
        }
    }
}

struct PreferenceRow_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceRow(
            title: "Time Style",
            exampleDate: Date(),
            formats: DateAndTimeFormat.ShortDateFormatIdentifier.allCases)
    }
}
