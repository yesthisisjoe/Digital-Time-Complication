//
//  AppLogger.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-04-28.
//

import Foundation
import os

struct AppLogger: TextOutputStream {
  let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: "Digital Time")

  func loggerString(forDate date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm:ss SSS"
    return dateFormatter.string(from: date)
  }

  mutating func logAndWrite(_ string: String) {
    logger.notice("\(string)")
    let dateString = loggerString(forDate: Date())
    let stringToLog = "\(dateString)\n \(string)\n\n"
    write(stringToLog)
  }

  mutating func write(_ string: String) {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
    let documentDirectoryPath = paths.first!
    let log = documentDirectoryPath.appendingPathComponent("log.txt")

    do {
      let handle = try FileHandle(forWritingTo: log)
      handle.seekToEndOfFile()
      handle.write(string.data(using: .utf8)!)
      handle.closeFile()
    } catch {
      print(error.localizedDescription)
      do {
        try string.data(using: .utf8)?.write(to: log)
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  func contentsOfLogFile() -> String? {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
    let documentDirectoryPath = paths.first!
    let log = documentDirectoryPath.appendingPathComponent("log.txt")
    do {
      return try String(contentsOf: log)
    } catch {
      return nil
    }
  }
}

var appLogger = AppLogger()
