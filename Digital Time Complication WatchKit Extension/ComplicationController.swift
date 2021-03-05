//
//  ComplicationController.swift
//  Digital Time Complication WatchKit Extension
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
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    private func createTimelineEntry(for complication: CLKComplication, onDate date: Date) -> CLKComplicationTimelineEntry {
        var template: CLKComplicationTemplate
        let timeProvider = CLKTimeTextProvider(date: date)
        let nothing = CLKTextProvider(format: "", [])
        let circularTemplate = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: timeProvider, line2TextProvider: nothing)
        
        // TODO: Check the quality of each of these
        switch complication.family {
        case .circularSmall:
            template = CLKComplicationTemplateCircularSmallSimpleText(
                textProvider: timeProvider)
        case .extraLarge:
            template = CLKComplicationTemplateExtraLargeSimpleText(
                textProvider: timeProvider)
        case .graphicBezel:
            template = CLKComplicationTemplateGraphicBezelCircularText(
                circularTemplate: circularTemplate,
                textProvider: timeProvider)
        case .graphicCircular:
            template = circularTemplate
        case .graphicCorner:
            template = CLKComplicationTemplateGraphicCornerStackText(
                innerTextProvider: timeProvider,
                outerTextProvider: nothing)
        case .graphicExtraLarge:
            template = CLKComplicationTemplateGraphicExtraLargeCircularStackText(
                line1TextProvider: timeProvider,
                line2TextProvider: nothing)
        case .graphicRectangular:
            template = CLKComplicationTemplateGraphicRectangularStandardBody(
                headerTextProvider: timeProvider,
                body1TextProvider: nothing)
        case .modularLarge:
            template = CLKComplicationTemplateModularLargeStandardBody(
                headerTextProvider: timeProvider,
                body1TextProvider: nothing)
        case .modularSmall:
            template = CLKComplicationTemplateModularSmallSimpleText(
                textProvider: timeProvider)
        case .utilitarianLarge:
            template = CLKComplicationTemplateUtilitarianLargeFlat(
                textProvider: timeProvider)
        case .utilitarianSmall:
            // TODO: Is this valid?
            template = CLKComplicationTemplateUtilitarianSmallFlat(
                textProvider: timeProvider)
        case .utilitarianSmallFlat:
            template = CLKComplicationTemplateUtilitarianSmallFlat(
                textProvider: timeProvider)
        @unknown default:
            fatalError("Unknown complication family found.")
        }
        
        let timelineEntry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        return timelineEntry
    }

    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let timelineEntry = createTimelineEntry(for: complication, onDate: Date())
        handler(timelineEntry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        var timelineEntries: [CLKComplicationTimelineEntry] = []
        var nextMinute: Date
        
        let barelyAfterDate = Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate + Double.leastNormalMagnitude)
        nextMinute = Date(timeIntervalSinceReferenceDate: (barelyAfterDate.timeIntervalSinceReferenceDate / 60.0).rounded(.up) * 60.0)
        
        while limit > timelineEntries.count {
            let timelineEntry = createTimelineEntry(for: complication, onDate: nextMinute)
            timelineEntries.append(timelineEntry)
            nextMinute = Date(timeIntervalSinceReferenceDate: nextMinute.timeIntervalSinceReferenceDate + 60.0)
        }
        
        handler(timelineEntries)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
