//
//  DigitalTimeApp.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-07.
//

import SwiftUI

@main
struct DigitalTimeApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PreferenceList()
            }
        }
    }
}
