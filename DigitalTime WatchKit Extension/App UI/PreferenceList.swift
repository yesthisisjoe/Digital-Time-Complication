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
      NavigationLink(destination:
                      Text("Tip Jar")
                      .onAppear {
                        DigitalTimeProducts.store.requestProducts { success, products in
                          if success {
                            DigitalTimeProducts.store.buyProduct(products!.first!)
                          }
                        }
                      }
      ) {
        Text("Tip Jar")
      }
    }
    .navigationTitle("Digital Time")
    .sheet(isPresented: $complicationUpdateService.showUpdateView) {
      ComplicationUpdateView()
        .navigationBarHidden(true)
    }
  }
}

struct PreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    PreferenceList(preferenceService: PreferenceService.shared)
  }
}
