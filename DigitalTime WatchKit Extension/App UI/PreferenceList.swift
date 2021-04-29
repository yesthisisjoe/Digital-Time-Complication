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
    List {
      Section {
        PreferenceRow(
          preferenceType: .timeFormat,
          formats: DateAndTimeFormat.TimeFormatIdentifier.allCases,
          preferenceService: preferenceService)
        PreferenceRow(
          preferenceType: .shortDateFormat,
          formats: DateAndTimeFormat.ShortDateFormatIdentifier.allCases,
          preferenceService: preferenceService)
        PreferenceRow(
          preferenceType: .longDateFormat,
          formats: DateAndTimeFormat.LongDateFormatIdentifier.allCases,
          preferenceService: preferenceService)
        NavigationLink(destination: TipJarView()) {
          Text("Tip Jar")
        }
        NavigationLink(destination: LogView()) {
          Text("Log file")
        }
      }
    }
    .navigationTitle("Digital Time")
  }
}

  struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
      PreferenceList(preferenceService: PreferenceService.shared)
    }
  }
