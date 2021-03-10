//
//  PreferenceRow.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import SwiftUI

struct PreferenceRow<T: DateAndTimeFormatIdentifier>: View {
  enum RowType {
    case time
    case shortDate
    case longDate
  }

  var rowType: RowType
  var exampleDate: Date
  var preferenceService: PreferenceService
  var formats: [T]
  @State private var selectedFormat = T.allCases.first!

  private func title(for rowType: RowType) -> String {
    switch rowType {
    case .time: return "Time Format"
    case .shortDate: return "Date Format (Short)"
    case .longDate: return "Date Format (Long)"
    }
  }

  var body: some View {
    Picker(title(for: rowType), selection: $selectedFormat) {
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
      rowType: .time,
      exampleDate: Date(),
      preferenceService: PreferenceService.shared,
      formats: DateAndTimeFormat.ShortDateFormatIdentifier.allCases)
  }
}
