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
        let complicationDigitalTimeIdentifier = "DigitalTime"
        let supportedFamilies: [CLKComplicationFamily] = [
            .circularSmall,
            .graphicBezel,
            .graphicCircular,
            .graphicCorner,
            .utilitarianLarge,
            .utilitarianSmall
        ]
        let digitalTimeDesriptor = CLKComplicationDescriptor(
            identifier: complicationDigitalTimeIdentifier,
            displayName: "Digital Time",
            supportedFamilies: supportedFamilies)
        let descriptors = [digitalTimeDesriptor]

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

    private func createTemplate(for complication: CLKComplication, onDate date: Date) -> CLKComplicationTemplate? {
        let timeProvider = CLKTimeTextProvider(date: date)
        let circularTemplate = CLKComplicationTemplateGraphicCircularStackText(
            line1TextProvider: timeProvider,
            line2TextProvider: timeProvider)

        switch complication.family {
        case .circularSmall:
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: timeProvider)
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
        case .utilitarianLarge:
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: timeProvider)
        case .utilitarianSmall:
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: timeProvider)
        default:
            return nil
        }
    }

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
