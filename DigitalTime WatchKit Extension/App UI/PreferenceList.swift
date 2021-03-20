//
//  PreferenceList.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import SwiftUI

struct PreferenceList: View {
  @ObservedObject var complicationUpdateService = ComplicationUpdateService.shared
  @State var showingSheet: Bool = false
  var preferenceService: PreferenceService
  var body: some View {
    NavigationView {
      List {
        PreferenceRow(
          preferenceType: .timeFormat,
          formats: DateAndTimeFormat.TimeFormatIdentifier.allCases,
          exampleDate: Date(),
          preferenceService: preferenceService)
        PreferenceRow(
          preferenceType: .shortDateFormat,
          formats: DateAndTimeFormat.ShortDateFormatIdentifier.allCases,
          exampleDate: Date(),
          preferenceService: preferenceService)
        PreferenceRow(
          preferenceType: .longDateFormat,
          formats: DateAndTimeFormat.LongDateFormatIdentifier.allCases,
          exampleDate: Date(),
          preferenceService: preferenceService)
      }
      .navigationTitle("Digital Time")
      .sheet(isPresented: $complicationUpdateService.showUpdateView) {
        ComplicationUpdateView()
        .navigationBarHidden(true)
      }
    }
  }
}

struct PreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    PreferenceList(preferenceService: PreferenceService.shared)
  }
}
