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
  var preferenceService: PreferenceService
  @State private var date: Date
  @State private var selectedFormat: T

  init(
    preferenceType: PreferenceType,
    formats: [T],
    preferenceService: PreferenceService) {
    self.preferenceType = preferenceType
    self.formats = formats
    self.preferenceService = preferenceService
    _date = State(initialValue: Date())
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
                fromDate: date,
                withDateFormat: format))
          .italic()
      }
    }
    .onChange(of: selectedFormat) { _ in
      preferenceService.set(preferenceType, to: selectedFormat)
    }
    .onAppear {
      date = Date()
    }
  }
}

struct PreferenceRow_Previews: PreviewProvider {
  static var previews: some View {
    PreferenceRow(
      preferenceType: .timeFormat,
      formats: DateAndTimeFormat.ShortDateFormatIdentifier.allCases,
      preferenceService: PreferenceService.shared)
  }
}
