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
  @State private var selectedFormat = T.allCases.first!

  private func title(for preferenceType: PreferenceType) -> String {
    switch preferenceType {
    case .time: return "Time Format"
    case .shortDate: return "Date Format (Short)"
    case .longDate: return "Date Format (Long)"
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
      }
    }
  }
}

struct PreferenceRow_Previews: PreviewProvider {
  static var previews: some View {
    PreferenceRow(
      preferenceType: .time,
      formats: DateAndTimeFormat.ShortDateFormatIdentifier.allCases,
      exampleDate: Date(),
      preferenceService: PreferenceService.shared)
  }
}
