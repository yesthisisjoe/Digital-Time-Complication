//
//  DigitalTimeApp.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import SwiftUI

@main
struct DigitalTimeApp: App {
  // swiftlint:disable:next weak_delegate
  @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var delegate
  var body: some Scene {
    WindowGroup {
      NavigationView {
        PreferenceList(preferenceService: PreferenceService.shared)
      }
    }
  }
}
