//
//  ComplicationController.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-04.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {

    enum ComplicationIdentifiers {
        static let time = "Time"
        static let timeAndDate = "TimeAndDate"
        static let dateAndTime = "DateAndTime"
        static let innerTime = "InnerTime"
        static let outerTime = "OuterTime"
        static let largeTime = "LargeTime"
    }

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
            identifier: ComplicationIdentifiers.time,
            displayName: "Time",
            supportedFamilies: timeSupportedFamilies)
        let timeAndDateDescriptor = CLKComplicationDescriptor(
            identifier: ComplicationIdentifiers.timeAndDate,
            displayName: "Time & Date",
            supportedFamilies: timeAndDateSupportedFamilies)
        let dateAndTimeDescriptor = CLKComplicationDescriptor(
            identifier: ComplicationIdentifiers.dateAndTime,
            displayName: "Date & Time",
            supportedFamilies: dateAndTimeSupportedFamilies)
        let innerTimeDescriptor = CLKComplicationDescriptor(
            identifier: ComplicationIdentifiers.innerTime,
            displayName: "Inner Time",
            supportedFamilies: innerTimeSupportedFamilies)
        let outerTimeDescriptor = CLKComplicationDescriptor(
            identifier: ComplicationIdentifiers.outerTime,
            displayName: "Outer Time",
            supportedFamilies: outerTimeSupportedFamilies)
        let largeTimeDescriptor = CLKComplicationDescriptor(
            identifier: ComplicationIdentifiers.largeTime,
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
        handler(.distantFuture)
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

    func getTimelineEntries(
        for complication: CLKComplication,
        after date: Date, limit: Int,
        withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        var timelineEntries: [CLKComplicationTimelineEntry] = []
        var nextMinute: Date

        let barelyAfterDate = Date(
            timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate + Double.leastNormalMagnitude)
        nextMinute = Date(
            timeIntervalSinceReferenceDate: (barelyAfterDate.timeIntervalSinceReferenceDate / 60.0).rounded(.up) * 60.0)

        while limit > timelineEntries.count {
            guard let timelineEntry = createTimelineEntry(for: complication, onDate: nextMinute) else {
                handler(nil)
                return
            }
            timelineEntries.append(timelineEntry)
            nextMinute = Date(timeIntervalSinceReferenceDate: nextMinute.timeIntervalSinceReferenceDate + 60.0)
        }

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

    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    private func createTemplate(for complication: CLKComplication, onDate date: Date) -> CLKComplicationTemplate? {
        // swiftlint:enable function_body_length
        // swiftlint:enable cyclomatic_complexity
        let shortTimeString = DateAndTimeFormatter.formattedTime(fromDate: date, withIdentifier: .twelveHour)
        let longTimeString = DateAndTimeFormatter.formattedTime(fromDate: date, withIdentifier: .twelveHour)
//        let firstHalfLongTimeString = "10:09"
//        let secondHalfLongTimeString = "AM"
        let shortDateString = DateAndTimeFormatter.formattedShortDate(fromDate: date, withIdentifier: .weekdayDay)
        let longDateString = DateAndTimeFormatter.formattedLongDate(fromDate: date, withIdentifier: .weekdayMonthDay)

        let shortTimeProvider = CLKSimpleTextProvider(text: shortTimeString)
        let longTimeProvider = CLKSimpleTextProvider(text: longTimeString)
//        let firstHalfLongTimeProvider = CLKSimpleTextProvider(text: firstHalfLongTimeString)
//        let secondHalfLongTimeProvider = CLKSimpleTextProvider(text: secondHalfLongTimeString)
        let shortDateProvider = CLKSimpleTextProvider(text: shortDateString)
        let longDateProvider = CLKSimpleTextProvider(text: longDateString)
        let emptyTextProvider = CLKSimpleTextProvider(text: "")
        let emptyGaugeProvider = CLKSimpleGaugeProvider(
            style: .fill,
            gaugeColor: .clear,
            fillFraction: 0.0)

        switch (complication.family, complication.identifier) {
        case (.circularSmall, ComplicationIdentifiers.time):
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: shortTimeProvider)
            // Add 2-line time provider
        case (.graphicBezel, ComplicationIdentifiers.time):
            return CLKComplicationTemplateGraphicBezelCircularText(
                circularTemplate: CLKComplicationTemplateGraphicCircularView(
                    ComplicationView(text: longTimeString)))
        case (.graphicBezel, ComplicationIdentifiers.timeAndDate):
            return CLKComplicationTemplateGraphicBezelCircularText(
                circularTemplate: CLKComplicationTemplateGraphicCircularView(
                    ComplicationView(text: longTimeString)),
                textProvider: longDateProvider)
        case (.graphicBezel, ComplicationIdentifiers.dateAndTime):
            return CLKComplicationTemplateGraphicBezelCircularText(
                circularTemplate: CLKComplicationTemplateGraphicCircularView(
                    ComplicationView(text: shortDateString)),
                textProvider: longTimeProvider)
        case (.graphicCircular, ComplicationIdentifiers.time):
            return CLKComplicationTemplateGraphicCircularView(
                ComplicationView(text: longTimeString))
        case (.graphicCorner, ComplicationIdentifiers.time):
            return CLKComplicationTemplateGraphicCornerCircularView(
                ComplicationView(text: longTimeString))
        case (.graphicCorner, ComplicationIdentifiers.timeAndDate):
            return CLKComplicationTemplateGraphicCornerStackText(
                innerTextProvider: longTimeProvider,
                outerTextProvider: shortDateProvider)
        case (.graphicCorner, ComplicationIdentifiers.dateAndTime):
            return CLKComplicationTemplateGraphicCornerStackText(
                innerTextProvider: shortDateProvider,
                outerTextProvider: longTimeProvider)
        case (.graphicCorner, ComplicationIdentifiers.outerTime):
            return CLKComplicationTemplateGraphicCornerStackText(
                innerTextProvider: emptyTextProvider,
                outerTextProvider: longTimeProvider)
        case (.graphicCorner, ComplicationIdentifiers.innerTime):
            return CLKComplicationTemplateGraphicCornerStackText(
                innerTextProvider: longTimeProvider,
                outerTextProvider: emptyTextProvider)
        case (.graphicCorner, ComplicationIdentifiers.largeTime):
            return CLKComplicationTemplateGraphicCornerGaugeText(
                gaugeProvider: emptyGaugeProvider,
                outerTextProvider: shortTimeProvider)
        case (.utilitarianLarge, ComplicationIdentifiers.time):
            return CLKComplicationTemplateUtilitarianLargeFlat(
                textProvider: longTimeProvider)
        case (.utilitarianSmall, ComplicationIdentifiers.time):
            return CLKComplicationTemplateUtilitarianSmallFlat(
                textProvider: longTimeProvider)
        default:
            return nil
        }
    }
}
