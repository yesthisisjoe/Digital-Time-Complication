//
//  PreferenceRow.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import SwiftUI

struct PreferenceRow<T: DateAndTimeFormatIdentifier>: View {
  var preferenceType: PreferenceType
  var formats: [T]
  var exampleDate: Date
  var preferenceService: PreferenceService
  @State private var selectedFormat: T
  @State private var showingAlert = false

  init(preferenceType: PreferenceType, formats: [T], exampleDate: Date, preferenceService: PreferenceService) {
    self.preferenceType = preferenceType
    self.formats = formats
    self.exampleDate = exampleDate
    self.preferenceService = preferenceService
    _selectedFormat = State<T>(initialValue: preferenceService.getValue(for: preferenceType))
  }

  private func title(for preferenceType: PreferenceType) -> String {
    switch preferenceType {
    case .timeFormat: return "Time Format"
    case .shortDateFormat: return "Date Format (Short)"
    case .longDateFormat: return "Date Format (Long)"
    }
  }

  var body: some View {
    Picker(title(for: preferenceType), selection: $selectedFormat) {
      ForEach(formats, id: \.self) {
        let format = DateAndTimeFormat.anyFormat(identifier: $0)!
        Text(format.name) +
          Text("\n") +
          Text(DateAndTimeFormatter.formattedDateOrTime(
                fromDate: exampleDate,
                withDateFormat: format))
          .italic()
      }.onChange(of: selectedFormat) { _ in
        showingAlert = preferenceService.numberOfSlowComplications() > 0
        preferenceService.set(preferenceType, to: selectedFormat)
      }.alert(isPresented: $showingAlert) {
        Alert(
          title: Text("Updating Complication"),
          message: Text("Please wait a few seconds while your complication is updating"),
          dismissButton: .default(Text("OK")))
      }
    }
  }
}

struct PreferenceRow_Previews: PreviewProvider {
  static var previews: some View {
    PreferenceRow(
      preferenceType: .timeFormat,
      formats: DateAndTimeFormat.ShortDateFormatIdentifier.allCases,
      exampleDate: Date(),
      preferenceService: PreferenceService.shared)
  }
}
