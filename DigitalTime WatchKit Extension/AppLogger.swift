//
//  AppLogger.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-04-27.
//

import Foundation
import os

let appLogger = Logger(
  subsystem: Bundle.main.bundleIdentifier!,
  category: "Digital Time")
