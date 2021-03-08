//
//  PreferenceList.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import SwiftUI

struct PreferenceList: View {
    var body: some View {
        List {
            PreferenceRow(
                title: "Time Format",
                formats: DateAndTimeFormat.timeFormats,
                exampleDate: Date())
            PreferenceRow(
                title: "Date Format (Short)",
                formats: DateAndTimeFormat.shortDateFormats,
                exampleDate: Date())
            PreferenceRow(
                title: "Date Format (Long)",
                formats: DateAndTimeFormat.longDateFormats,
                exampleDate: Date())
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceList()
    }
}
