//
//  ComplicationController.swift
//  urComp WatchKit Extension
//
//  Created by spoonik on 2018/10/18.
//  Copyright © 2018 spoonikapps. All rights reserved.
//

import ClockKit

func reloadComplications() {
    if !SettingsManager.sharedManager.getNewComplicationValueFlag() {
        return
    }
    if let complications: [CLKComplication] = CLKComplicationServer.sharedInstance().activeComplications {
        if complications.count > 0 {
            for complication in complications {
                CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
                NSLog("Reloading complication \(complication.description)...")
            }
        }
    }
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let completedPercentage = SettingsManager.sharedManager.getComplicationValue()
        SettingsManager.sharedManager.setNewComplicationValueFlag(result: false)
        let curCompText = CLKSimpleTextProvider(text: String(Int(completedPercentage*100.0)))
        let compColors = [UIColor.purple, categoryUIColors[0], categoryUIColors[1], categoryUIColors[2]]
        let compColorLocation = [0.0, 0.3, 0.6, 1.0]
        //let compColors = [UIColor.purple, UIColor.cyan, UIColor.green, UIColor.orange, UIColor.red]
        //let compColorLocation = [0.0, 0.2, 0.5, 0.8, 1.0]
        let tempPercentage = completedPercentage > 1.0 ? 1.0 : completedPercentage
        let compGaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColors: compColors, gaugeColorLocations: compColorLocation as [NSNumber], fillFraction: tempPercentage)
        
        
        switch complication.family {
        case .graphicCorner:
            let curCompTextCorner = CLKSimpleTextProvider(text: String(Int(completedPercentage*100.0)) + "%")
            
            let template = CLKComplicationTemplateGraphicCornerGaugeText()
            template.gaugeProvider = compGaugeProvider
            template.outerTextProvider = curCompTextCorner
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
            template.gaugeProvider = compGaugeProvider
            template.centerTextProvider = curCompText
            template.bottomTextProvider = CLKSimpleTextProvider(text: "cmp")
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallRingText()
            template.ringStyle = CLKComplicationRingStyle.closed
            template.fillFraction = tempPercentage
            template.textProvider = curCompText
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            template.ringStyle = CLKComplicationRingStyle.closed
            template.fillFraction = tempPercentage
            template.textProvider = curCompText
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallRingText()
            template.ringStyle = CLKComplicationRingStyle.closed
            template.fillFraction = tempPercentage
            template.textProvider = curCompText
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
            
        default:
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    func getNextRequestedUpdateDateWithHandler(
        handler: (NSDate?) -> Void) {
        let nextDate = NSDate(timeIntervalSinceNow: 60)
        handler(nextDate);
    }
    
    func requestedUpdateDidBegin() {
        HealthData.sharedManager.refreshCompletionPercentage(delegate: nil)
        //let server=CLKComplicationServer.sharedInstance()
        //for complication in server.activeComplications! {
        //    server.extendTimeline(for: complication)
        //}
    }
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
