//
//  ComplicationController.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-04.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
  let preferenceService = PreferenceService.shared
  let complicationUpdateService = ComplicationUpdateService.shared

  let complicationTimelineLength: TimeInterval = 100 * 60
  let timeUntilBackgroundTask: TimeInterval = 60 * 60

  // MARK: - Complication Configuration

  func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
    let timeSupportedFamilies: [CLKComplicationFamily] = [
      .circularSmall,
      .graphicBezel,
      .graphicCircular,
      .graphicCorner,
      .utilitarianLarge,
      .utilitarianSmall
    ]
    let timeAndDateSupportedFamilies: [CLKComplicationFamily] = [
      .graphicBezel,
      .graphicCorner
    ]
    let dateAndTimeSupportedFamilies: [CLKComplicationFamily] = [
      .graphicBezel,
      .graphicCorner
    ]
    let innerTimeSupportedFamilies: [CLKComplicationFamily] = [.graphicCorner]
    let outerTimeSupportedFamilies: [CLKComplicationFamily] = [.graphicCorner]
    let largeTimeSupportedFamilies: [CLKComplicationFamily] = [.graphicCorner]

    let timeDescriptor = CLKComplicationDescriptor(
      identifier: ComplicationIdentifier.time,
      displayName: "Time",
      supportedFamilies: timeSupportedFamilies)
    let timeAndDateDescriptor = CLKComplicationDescriptor(
      identifier: ComplicationIdentifier.timeAndDate,
      displayName: "Time & Date",
      supportedFamilies: timeAndDateSupportedFamilies)
    let dateAndTimeDescriptor = CLKComplicationDescriptor(
      identifier: ComplicationIdentifier.dateAndTime,
      displayName: "Date & Time",
      supportedFamilies: dateAndTimeSupportedFamilies)
    let innerTimeDescriptor = CLKComplicationDescriptor(
      identifier: ComplicationIdentifier.innerTime,
      displayName: "Inner Time",
      supportedFamilies: innerTimeSupportedFamilies)
    let outerTimeDescriptor = CLKComplicationDescriptor(
      identifier: ComplicationIdentifier.outerTime,
      displayName: "Outer Time",
      supportedFamilies: outerTimeSupportedFamilies)
    let largeTimeDescriptor = CLKComplicationDescriptor(
      identifier: ComplicationIdentifier.largeTime,
      displayName: "Large Time",
      supportedFamilies: largeTimeSupportedFamilies)

    let descriptors = [
      timeDescriptor,
      innerTimeDescriptor,
      outerTimeDescriptor,
      largeTimeDescriptor,
      timeAndDateDescriptor,
      dateAndTimeDescriptor
    ]

    handler(descriptors)
  }

  // MARK: - Timeline Configuration

  func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    handler(Date(timeIntervalSinceNow: complicationTimelineLength))
  }

  func getPrivacyBehavior(
    for complication: CLKComplication,
    withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
    handler(.showOnLockScreen)
  }

  // MARK: - Timeline Population

  private func createTimelineEntry(
    for complication: CLKComplication,
    onDate date: Date
  ) -> CLKComplicationTimelineEntry? {
    guard let template = createTemplate(for: complication, onDate: date) else {
      return nil
    }
    let timelineEntry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    return timelineEntry
  }

  func getCurrentTimelineEntry(
    for complication: CLKComplication,
    withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    let timelineEntry = createTimelineEntry(for: complication, onDate: Date())
    handler(timelineEntry)
  }

  func scheduleBackgroundTaskForNextComplicationUpdate() {
    let preferredDate = Date(timeIntervalSinceNow: timeUntilBackgroundTask)
    WKExtension.shared().scheduleBackgroundRefresh(
      withPreferredDate: preferredDate,
      userInfo: nil) { error in
      if let error = error {
        NSLog("Couldn't schedule background refresh. Error: \(error)")
      } else {
        NSLog("Successfully scheduled background refresh for \(preferredDate)")
      }
    }
  }

  func getTimelineEntries(
    for complication: CLKComplication,
    after date: Date, limit: Int,
    withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    let family = String(describing: complication.family.rawValue)
    let identifier = String(describing: complication.identifier)
    NSLog("Getting \(limit) entries for complication family: \(family) identifier: \(identifier) after: \(date)")
    complicationUpdateService.complicationUpdateStarted()

    let maximumEntryDate = Date(timeIntervalSinceNow: complicationTimelineLength)
    if date.addingTimeInterval(60) > maximumEntryDate {
      handler(nil)
      NSLog("Returning 0 entries because next entry will be past the maximum entry date.")
      return
    }
    scheduleBackgroundTaskForNextComplicationUpdate()

    var timelineEntries: [CLKComplicationTimelineEntry] = []
    var nextMinute: Date

    let smallestTimeInterval = 0.0000001
    let barelyAfterDate = Date(
      timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate + smallestTimeInterval)
    nextMinute = Date(
      timeIntervalSinceReferenceDate: (barelyAfterDate.timeIntervalSinceReferenceDate / 60.0).rounded(.up) * 60.0)

    while limit > timelineEntries.count && nextMinute < maximumEntryDate {
      guard let timelineEntry = createTimelineEntry(for: complication, onDate: nextMinute) else {
        handler(nil)
        return
      }
      timelineEntries.append(timelineEntry)
      nextMinute = Date(timeIntervalSinceReferenceDate: nextMinute.timeIntervalSinceReferenceDate + 60.0)
    }

    NSLog("Returning \(timelineEntries.count) timeline entries")
    handler(timelineEntries)
  }

  // MARK: - Sample Templates

  func getLocalizableSampleTemplate(
    for complication: CLKComplication,
    withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: 2020, month: 10, day: 9, hour: 10, minute: 9, second: 30)
    let sampleDate = calendar.date(from: dateComponents)!
    let template = createTemplate(for: complication, onDate: sampleDate)
    handler(template)
  }
}

extension ComplicationController {
  private func createTemplate(for complication: CLKComplication, onDate date: Date) -> CLKComplicationTemplate? {
    switch complication.family {
    case .circularSmall:
      return createCircularSmallTemplate(forDate: date)
    case .graphicBezel:
      return createGraphicBezelTemplate(forDate: date, identifier: complication.identifier)
    case .graphicCircular:
      return createGraphicCircularTemplate(forDate: date, identifier: complication.identifier)
    case .graphicCorner:
      return createGraphicCornerTemplate(forDate: date, identifier: complication.identifier)
    case .utilitarianLarge:
      return createUtilitarianLargeTemplate(forDate: date)
    case .utilitarianSmall:
      return createUtilitarianSmallTemplate(forDate: date)
    default:
      return nil
    }
  }

  func createCircularSmallTemplate(forDate date: Date) -> CLKComplicationTemplate {
    let shortTimeString = DateAndTimeFormatter.shortenedFormattedTime(
      fromDate: date,
      withIdentifier: preferenceService.timeFormat)
    let shortTimeProvider = CLKSimpleTextProvider(text: shortTimeString)

    let multilineTimeStringLines = DateAndTimeFormatter.multilineFormattedTime(
      fromDate: date,
      withIdentifier: preferenceService.timeFormat)
    var line1LongTimeString: String?
    var line2LongTimeString: String?
    var line1LongTimeStringProvider: CLKSimpleTextProvider?
    var line2LongTimeStringProvider: CLKSimpleTextProvider?
    if multilineTimeStringLines.count > 1 {
      line1LongTimeString = multilineTimeStringLines[0]
      line2LongTimeString = multilineTimeStringLines[1]
      line1LongTimeStringProvider = CLKSimpleTextProvider(text: line1LongTimeString!)
      line2LongTimeStringProvider = CLKSimpleTextProvider(text: line2LongTimeString!)
    }

    if let line1LongTimeStringProvider = line1LongTimeStringProvider,
       let line2LongTimeStringProvider = line2LongTimeStringProvider {
      return CLKComplicationTemplateCircularSmallStackText(
        line1TextProvider: line1LongTimeStringProvider,
        line2TextProvider: line2LongTimeStringProvider)
    } else {
      return CLKComplicationTemplateCircularSmallSimpleText(textProvider: shortTimeProvider)
    }
  }

  func createGraphicBezelTemplate(forDate date: Date, identifier: String) -> CLKComplicationTemplate? {
    let longTimeString = DateAndTimeFormatter.formattedTime(
      fromDate: date,
      withIdentifier: preferenceService.timeFormat)
    let longDateString = DateAndTimeFormatter.formattedLongDate(
      fromDate: date,
      withIdentifier: preferenceService.longDateFormat)

    let longTimeProvider = CLKSimpleTextProvider(text: longTimeString)
    let longDateProvider = CLKSimpleTextProvider(text: longDateString)

    switch identifier {
    case ComplicationIdentifier.time:
      return CLKComplicationTemplateGraphicBezelCircularText(
        circularTemplate: createGraphicCircularTemplate(forDate: date, identifier: identifier)!)
    case ComplicationIdentifier.timeAndDate:
      return CLKComplicationTemplateGraphicBezelCircularText(
        circularTemplate: createGraphicCircularTemplate(forDate: date, identifier: identifier)!,
        textProvider: longDateProvider)
    case ComplicationIdentifier.dateAndTime:
      return CLKComplicationTemplateGraphicBezelCircularText(
        circularTemplate: createGraphicCircularTemplate(forDate: date, identifier: identifier)!,
        textProvider: longTimeProvider)
    default:
      return nil
    }
  }

  func createGraphicCircularTemplate(
    forDate date: Date,
    identifier: String
  ) -> CLKComplicationTemplateGraphicCircular? {
    let longTimeString = DateAndTimeFormatter.formattedTime(
      fromDate: date,
      withIdentifier: preferenceService.timeFormat)
    let shortDateString = DateAndTimeFormatter.formattedShortDate(
      fromDate: date,
      withIdentifier: preferenceService.shortDateFormat)

    switch identifier {
    case ComplicationIdentifier.timeAndDate,
         ComplicationIdentifier.time:
      return CLKComplicationTemplateGraphicCircularView(
        ComplicationView(text: longTimeString))
    case ComplicationIdentifier.dateAndTime:
      return CLKComplicationTemplateGraphicCircularView(
        ComplicationView(text: shortDateString))
    default:
      return nil
    }

  }

  func createGraphicCornerTemplate(forDate date: Date, identifier: String) -> CLKComplicationTemplate? {
    let shortTimeString = DateAndTimeFormatter.shortenedFormattedTime(
      fromDate: date,
      withIdentifier: preferenceService.timeFormat)
    let longTimeString = DateAndTimeFormatter.formattedTime(
      fromDate: date,
      withIdentifier: preferenceService.timeFormat)
    let shortDateString = DateAndTimeFormatter.formattedShortDate(
      fromDate: date,
      withIdentifier: preferenceService.shortDateFormat)

    let shortTimeProvider = CLKSimpleTextProvider(text: shortTimeString)
    let longTimeProvider = CLKSimpleTextProvider(text: longTimeString)
    let shortDateProvider = CLKSimpleTextProvider(text: shortDateString)

    let emptyTextProvider = CLKSimpleTextProvider(text: "")
    let emptyGaugeProvider = CLKSimpleGaugeProvider(
      style: .fill,
      gaugeColor: .clear,
      fillFraction: 0.0)

    switch identifier {
    case ComplicationIdentifier.time:
      return CLKComplicationTemplateGraphicCornerCircularView(
        ComplicationView(text: longTimeString))
    case ComplicationIdentifier.timeAndDate:
      return CLKComplicationTemplateGraphicCornerStackText(
        innerTextProvider: longTimeProvider,
        outerTextProvider: shortDateProvider)
    case ComplicationIdentifier.dateAndTime:
      return CLKComplicationTemplateGraphicCornerStackText(
        innerTextProvider: shortDateProvider,
        outerTextProvider: longTimeProvider)
    case ComplicationIdentifier.outerTime:
      return CLKComplicationTemplateGraphicCornerStackText(
        innerTextProvider: emptyTextProvider,
        outerTextProvider: longTimeProvider)
    case ComplicationIdentifier.innerTime:
      return CLKComplicationTemplateGraphicCornerStackText(
        innerTextProvider: longTimeProvider,
        outerTextProvider: emptyTextProvider)
    case ComplicationIdentifier.largeTime:
      return CLKComplicationTemplateGraphicCornerGaugeText(
        gaugeProvider: emptyGaugeProvider,
        outerTextProvider: shortTimeProvider)
    default:
      return nil
    }
  }

  func createUtilitarianLargeTemplate(forDate date: Date) -> CLKComplicationTemplate {
    let longTimeString = DateAndTimeFormatter.formattedTime(
      fromDate: date,
      withIdentifier: preferenceService.timeFormat)
    let longTimeProvider = CLKSimpleTextProvider(text: longTimeString)
    return CLKComplicationTemplateUtilitarianLargeFlat(
      textProvider: longTimeProvider)
  }

  func createUtilitarianSmallTemplate(forDate date: Date) -> CLKComplicationTemplate {
    let longTimeString = DateAndTimeFormatter.formattedTime(
      fromDate: date,
      withIdentifier: preferenceService.timeFormat)
    let longTimeProvider = CLKSimpleTextProvider(text: longTimeString)
    return CLKComplicationTemplateUtilitarianSmallFlat(
      textProvider: longTimeProvider)
  }
}
