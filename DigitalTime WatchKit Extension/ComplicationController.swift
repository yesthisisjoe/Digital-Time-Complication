//
//  ComplicationController.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-04.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {

    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let complicationDigitalTimeIdentifier = "Time"
        let digitalTimeDesriptor = CLKComplicationDescriptor(
            identifier: complicationDigitalTimeIdentifier,
            displayName: "Digital Time",
            supportedFamilies: CLKComplicationFamily.allCases)

        let descriptors = [
            digitalTimeDesriptor
        ]

        handler(descriptors)
    }

    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
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

    // swiftlint:disable:next cyclomatic_complexity
    private func createTemplate(for complication: CLKComplication, onDate date: Date) -> CLKComplicationTemplate {
        let timeProvider = CLKTimeTextProvider(date: date)
        let circularTemplate = CLKComplicationTemplateGraphicCircularStackText(
            line1TextProvider: timeProvider,
            line2TextProvider: timeProvider)

        switch complication.family {
        case .circularSmall:
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: timeProvider)
        case .extraLarge:
            return CLKComplicationTemplateExtraLargeSimpleText(textProvider: timeProvider)
        case .graphicBezel:
            return CLKComplicationTemplateGraphicBezelCircularText(
                circularTemplate: circularTemplate,
                textProvider: timeProvider)
        case .graphicCircular:
            return circularTemplate
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerStackText(
                innerTextProvider: timeProvider,
                outerTextProvider: timeProvider)
        case .graphicExtraLarge:
            return CLKComplicationTemplateGraphicExtraLargeCircularStackText(
                line1TextProvider: timeProvider,
                line2TextProvider: timeProvider)
        case .graphicRectangular:
            return CLKComplicationTemplateGraphicRectangularStandardBody(
                headerTextProvider: timeProvider,
                body1TextProvider: timeProvider)
        case .modularLarge:
            return CLKComplicationTemplateModularLargeStandardBody(
                headerTextProvider: timeProvider,
                body1TextProvider: timeProvider)
        case .modularSmall:
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: timeProvider)
        case .utilitarianLarge:
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: timeProvider)
        case .utilitarianSmall:
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: timeProvider)
        case .utilitarianSmallFlat:
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: timeProvider)
        @unknown default:
            fatalError("Unknown complication family found.")
        }
    }

    private func createTimelineEntry(
        for complication: CLKComplication,
        onDate date: Date
    ) -> CLKComplicationTimelineEntry {
        let template = createTemplate(for: complication, onDate: date)
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
            let timelineEntry = createTimelineEntry(for: complication, onDate: nextMinute)
            timelineEntries.append(timelineEntry)
            nextMinute = Date(timeIntervalSinceReferenceDate: nextMinute.timeIntervalSinceReferenceDate + 60.0)
        }

        handler(timelineEntries)
    }

    // MARK: - Sample Templates

    func getLocalizableSampleTemplate(
        for complication: CLKComplication,
        withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let template = createTemplate(for: complication, onDate: Date())
        handler(template)
    }
}
