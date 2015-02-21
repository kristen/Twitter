//
//  TimeSinceNowFormatter.swift
//  Twitter
//
//  Created by Kristen on 2/20/15.
//  Referred to NSDate-Time-Ago for basic logic
//  https://github.com/nikilster/NSDate-Time-Ago
//

import UIKit

let SECOND: NSTimeInterval = 1
let MINUTE = (SECOND * 60)
let HOUR   = (MINUTE * 60)
let DAY    = (HOUR   * 24)
let WEEK   = (DAY    * 7)
let MONTH  = (DAY    * 31)
let YEAR   = (DAY    * 365.24)

class TimeSinceNowFormatter: NSObject {
    
    func formattedAsTimeAgo(date: NSDate) -> String {
        
        let secondsSince = -date.timeIntervalSinceNow
        
        //Should never hit this but handle the future case
        if secondsSince < 0 {
            return "In The Future"
        }
        
        // < 1 minute = "Just now"
        if secondsSince < MINUTE {
            return "Just now"
        }
        
        // < 1 hour = "x minutes ago"
        if secondsSince < HOUR {
            return formatMinutesAgo(secondsSince)
        }
        
        if secondsSince < DAY {
            return formatHoursAgo(secondsSince)
        }
        
        if secondsSince < WEEK {
            return formatDaysAgo(secondsSince)
        }
        
        return formatDateShort(date)
    }
    
    
    /*
    ========================== Formatting Methods ==========================
    */
    
    
    // < 1 hour = "xm"
    func formatMinutesAgo(secondsSince: NSTimeInterval) -> String {
        //Convert to minutes
        
        let minutesSince = Int(round(secondsSince / MINUTE))
        return "\(minutesSince)m"
    }
    
    
    // Today = "xh"
    func formatHoursAgo(secondsSince: NSTimeInterval) -> String {
        //Convert to hours

        let hoursSince = Int(round(secondsSince / HOUR))
        return "\(hoursSince)h"
    }
    
    
    // < Last 7 days = "xd"
    func formatDaysAgo(secondsSince: NSTimeInterval) -> String {
        //Create date formatter

        let daysSince = Int(round(secondsSince / DAY))
        return "\(daysSince)d"
    }
    
    // Anything else = "2/8/15"
    func formatDateShort(date: NSDate) -> String {
        //Create date formatter
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        //Format
        return dateFormatter.stringFromDate(date)
    }
    
    
    /*
    =======================================================================
    */
}
