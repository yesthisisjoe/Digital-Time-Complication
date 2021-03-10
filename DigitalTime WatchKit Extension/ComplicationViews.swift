//
//  ComplicationViews.swift
//  DigitalTime WatchKit Extension
//
//  Created by Joe Peplowski on 2021-03-05.
//

import SwiftUI
import ClockKit

struct ComplicationView: View {
  @State var text: String
  
  var body: some View {
    Text(text).multilineTextAlignment(.center)
  }
}

let longTimeString = "10:09 AM"
let longTimeProvider = CLKSimpleTextProvider(text: longTimeString)
let shortTimeProvider = CLKSimpleTextProvider(text: "10:09")
let firstHalfLongTimeProvider = CLKSimpleTextProvider(text: "10:09")
let secondHalfLongTimeProvider = CLKSimpleTextProvider(text: "AM")
let shortDateString = "FRI 25"
let shortDateProvider = CLKSimpleTextProvider(text: shortDateString)
let longDateString = "Friday, March 5 2021"
let longDateProvider = CLKSimpleTextProvider(text: longDateString)
let emptyTextProvider = CLKSimpleTextProvider(text: "")
let emptyGaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .clear, fillFraction: .zero)

struct ComplicationViews_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      // MARK: Circular Small
      // Short time
      CLKComplicationTemplateCircularSmallSimpleText(
        textProvider: shortTimeProvider
      ).previewContext()
      
      // Long time
      CLKComplicationTemplateCircularSmallStackText(
        line1TextProvider: firstHalfLongTimeProvider,
        line2TextProvider: secondHalfLongTimeProvider
      ).previewContext()
    }
    Group {
      // MARK: Graphic Circular
      CLKComplicationTemplateGraphicCircularView(
        ComplicationView(text: longTimeString)
      ).previewContext()
    }
    Group {
      // MARK: Graphic Bezel
      // Date circular, time edge
      CLKComplicationTemplateGraphicBezelCircularText(
        circularTemplate: CLKComplicationTemplateGraphicCircularView(
          ComplicationView(text: shortDateString)
        ),
        textProvider: longTimeProvider
      ).previewContext()
      
      // Time circular, date edge
      CLKComplicationTemplateGraphicBezelCircularText(
        circularTemplate:
          CLKComplicationTemplateGraphicCircularView(
            ComplicationView(text: longTimeString)
          ),
        textProvider: longDateProvider
      ).previewContext()
      
      // Time circular, no edge
      CLKComplicationTemplateGraphicBezelCircularText(
        circularTemplate:
          CLKComplicationTemplateGraphicCircularView(
            ComplicationView(text: longTimeString)
          )
      ).previewContext()
    }
    Group {
      // MARK: Graphic Corner
      // Circular
      CLKComplicationTemplateGraphicCornerCircularView(
        ComplicationView(text: longTimeString)
      ).previewContext()
      
      // Inner date/outer time
      CLKComplicationTemplateGraphicCornerStackText(
        innerTextProvider: shortDateProvider,
        outerTextProvider: longTimeProvider
      ).previewContext()
      
      // Inner time/outer date
      CLKComplicationTemplateGraphicCornerStackText(
        innerTextProvider: longTimeProvider,
        outerTextProvider: shortDateProvider
      ).previewContext()
      
      // Outer time
      CLKComplicationTemplateGraphicCornerStackText(
        innerTextProvider: emptyTextProvider,
        outerTextProvider: longTimeProvider
      ).previewContext()
      
      // Inner time
      CLKComplicationTemplateGraphicCornerStackText(
        innerTextProvider: longTimeProvider,
        outerTextProvider: emptyTextProvider
      ).previewContext()
      
      // Text with empty gauge
      CLKComplicationTemplateGraphicCornerGaugeText(
        gaugeProvider: emptyGaugeProvider,
        outerTextProvider: shortTimeProvider
      ).previewContext()
    }
    Group {
      // MARK: Utilitarian large
      CLKComplicationTemplateUtilitarianLargeFlat(
        textProvider: longTimeProvider
      ).previewContext()
    }
    Group {
      // MARK: Utilitarian small
      CLKComplicationTemplateUtilitarianSmallFlat(
        textProvider: longTimeProvider
      ).previewContext()
    }
  }
}
