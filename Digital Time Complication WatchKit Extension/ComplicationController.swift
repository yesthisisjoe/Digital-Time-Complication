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
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        var template: CLKComplicationTemplate
        let timeProvider = CLKTimeTextProvider(date: Date())
        let circularTemplate = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: timeProvider, line2TextProvider: timeProvider)
        
        // TODO: Check the quality of each of these
        switch complication.family {
        case .circularSmall:
            template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: timeProvider)
        case .extraLarge:
            template = CLKComplicationTemplateExtraLargeSimpleText(textProvider: timeProvider)
        case .graphicBezel:
            template = CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circularTemplate, textProvider: timeProvider)
        case .graphicCircular:
            template = circularTemplate
        case .graphicCorner:
            template = CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: timeProvider, outerTextProvider: timeProvider)
        case .graphicExtraLarge:
            template = CLKComplicationTemplateGraphicExtraLargeCircularStackText(line1TextProvider: timeProvider, line2TextProvider: timeProvider)
        case .graphicRectangular:
            template = CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: timeProvider, body1TextProvider: timeProvider)
        case .modularLarge:
            template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: timeProvider, body1TextProvider: timeProvider)
        case .modularSmall:
            template = CLKComplicationTemplateModularSmallSimpleText(textProvider: timeProvider)
        case .utilitarianLarge:
            template = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: timeProvider)
        case .utilitarianSmall:
            // TODO: Is this valid?
            template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: timeProvider)
        case .utilitarianSmallFlat:
            template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: timeProvider)
        @unknown default:
            fatalError("Unknown complication family found.")
        }
        
        let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
        handler(timelineEntry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
