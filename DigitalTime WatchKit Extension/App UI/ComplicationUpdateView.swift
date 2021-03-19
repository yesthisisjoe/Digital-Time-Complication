//
//  ComplicationUpdateView.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-18.
//

import SwiftUI

struct ComplicationUpdateView: View {
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    ScrollView {
      VStack {
        Text("Updating Complication")
          .font(.headline)
          .multilineTextAlignment(.center)
          .fixedSize(horizontal: false, vertical: true)
        ProgressView()
          .padding()
        Text("Please wait until the spinner animates smoothly")
          .font(.body)
          .multilineTextAlignment(.center)
          .fixedSize(horizontal: false, vertical: true)
        Button("OK") {
          presentationMode.wrappedValue.dismiss()
        }
        .padding([.top, .leading, .trailing])
      }
      .progressViewStyle(CircularProgressViewStyle())
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    ComplicationUpdateView()
  }
}
