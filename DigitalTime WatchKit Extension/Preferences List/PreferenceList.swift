//
//  PreferenceList.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import SwiftUI

struct PreferenceList: View {
  var preferenceService: PreferenceService
  var body: some View {
    NavigationView {
      List {
        PreferenceRow(
          rowType: .time,
          exampleDate: Date(),
          preferenceService: preferenceService,
          formats: DateAndTimeFormat.TimeFormatIdentifier.allCases)
        PreferenceRow(
          rowType: .shortDate,
          exampleDate: Date(),
          preferenceService: preferenceService,
          formats: DateAndTimeFormat.ShortDateFormatIdentifier.allCases)
        PreferenceRow(
          rowType: .longDate,
          exampleDate: Date(),
          preferenceService: preferenceService,
          formats: DateAndTimeFormat.LongDateFormatIdentifier.allCases)
      }.navigationTitle("Digital Time")
    }
  }
}

struct PreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    PreferenceList(preferenceService: PreferenceService.shared)
  }
}
