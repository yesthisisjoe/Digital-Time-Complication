//
//  LogView.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-04-28.
//

import SwiftUI

struct LogView: View {
  var body: some View {
    ScrollView {
      Text(appLogger.contentsOfLogFile() ?? "Empty or error loading log file")
        .fixedSize(horizontal: false, vertical: true)
        .font(.system(size: 10))
    }
  }
}
