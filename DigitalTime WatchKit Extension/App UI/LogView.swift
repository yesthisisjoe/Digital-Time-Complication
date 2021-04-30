//
//  LogView.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-04-28.
//

import SwiftUI

struct LogView: View {
  @Namespace var textID

  var body: some View {
    ScrollViewReader { proxy in
      ScrollView {
        Text(appLogger.contentsOfLogFile() ?? "Empty or error loading log file")
          .fixedSize(horizontal: false, vertical: true)
          .font(.system(size: 10))
          .id(textID)
          .onAppear {
            proxy.scrollTo(textID, anchor: .bottom)
          }
      }
    }
  }
}
