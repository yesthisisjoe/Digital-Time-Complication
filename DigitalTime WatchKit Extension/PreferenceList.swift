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
            PreferenceRow(title: "Time Format", format: TimeFormat.twelveHour, exampleDate: Date())
            PreferenceRow(title: "Date Format (Short)", format: ShortDateFormat.weekdayDay, exampleDate: Date())
            PreferenceRow(title: "Date Format (Long)", format: LongDateFormat.weekdayMonthDay, exampleDate: Date())
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceList()
    }
}
