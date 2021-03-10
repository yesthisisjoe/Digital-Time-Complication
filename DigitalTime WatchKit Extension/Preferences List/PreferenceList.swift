//
//  PreferenceList.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import SwiftUI

struct PreferenceList: View {
    var body: some View {
        NavigationView {
            List {
                PreferenceRow(
                    title: "Time Format",
                    exampleDate: Date(),
                    formats: DateAndTimeFormat.TimeFormatIdentifier.allCases)
                PreferenceRow(
                    title: "Date Format (Short)",
                    exampleDate: Date(),
                    formats: DateAndTimeFormat.ShortDateFormatIdentifier.allCases)
                PreferenceRow(
                    title: "Date Format (Long)",
                    exampleDate: Date(),
                    formats: DateAndTimeFormat.LongDateFormatIdentifier.allCases)
            }.navigationTitle("Digital Time")
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceList()
    }
}
