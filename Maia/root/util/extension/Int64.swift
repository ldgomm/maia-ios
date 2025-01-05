//
//  Int64.swift
//  Maia
//
//  Created by José Ruiz on 29/7/24.
//

import Foundation

extension Int64 {
    
    /// A computed property that formats a timestamp (represented as a Double) into a full date string in Spanish.
    /// The format used is "EEEE, dd-MM-yy", which represents the full name of the day, day, month, and year.
    ///
    /// - Returns: A string representing the formatted date.
    var formatDate: String {
        // Convert the timestamp from milliseconds to seconds, then create a Date object
        let date = Date(timeIntervalSince1970: TimeInterval(self) / 1000)
        
        // Initialize a DateFormatter and set the desired format and locale
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd-MM-yy"
        dateFormatter.locale = Locale(identifier: "es_ES")  // Spanish locale
        
        // Return the formatted date string
        return dateFormatter.string(from: date)
    }

    /// A computed property that formats a timestamp (represented as a Double) into a short, human-readable date string in Spanish.
    /// The formatting adapts based on how recent the date is:
    /// - Within the last day: Returns only the time.
    /// - Within the last 2 days: Returns "ayer" (yesterday).
    /// - Within the last week: Returns the day of the week.
    /// - Within the last month: Returns the day of the week and day of the month.
    /// - Within the last year: Returns the month.
    /// - Older than a year: Returns the month and year.
    ///
    /// - Returns: A string representing the formatted short date.
    var formatShortDate: String {
        // Get the current timestamp in milliseconds
        let currentTime = Date().timeIntervalSince1970 * 1000
        
        // Calculate the difference between the current time and the timestamp
        let diff = currentTime - Double(self)

        // Define time intervals in milliseconds
        let oneMinute: Double = 60 * 1000
        let oneHour: Double = 60 * oneMinute
        let oneDay: Double = 24 * oneHour

        // Convert the timestamp from milliseconds to seconds, then create a Date object
        let date = Date(timeIntervalSince1970: TimeInterval(self) / 1000)
        
        // Initialize a DateFormatter and set the Spanish locale
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")

        // Determine the appropriate date format based on the time difference
        if diff < oneDay {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short  // Return only the time
            return dateFormatter.string(from: date)
        } else if diff < 2 * oneDay {
            return "ayer"  // Return "yesterday" in Spanish
        } else if diff < 7 * oneDay {
            dateFormatter.dateFormat = "EEEE"  // Return the day of the week
            return dateFormatter.string(from: date)
        } else if diff < 30 * oneDay {
            dateFormatter.dateFormat = "EEEE, d MMM"  // Return the day of the week and day of the month
            return dateFormatter.string(from: date)
        } else if diff < 365 * oneDay {
            dateFormatter.dateFormat = "MMMM"  // Return the month
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "MMMM yyyy"  // Return the month and year
            return dateFormatter.string(from: date)
        }
    }
    
    var formatDayHeadDateTime: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self) / 1000)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
        
    }
    
    var formatShortHeadDate: String {
        let currentTime = Date().timeIntervalSince1970 * 1000
        let diff = currentTime - Double(self)
        
        let oneMinute: Double = 60 * 1000
        let oneHour: Double = 60 * oneMinute
        let oneDay: Double = 24 * oneHour
        
        let date = Date(timeIntervalSince1970: TimeInterval(self) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        
        if diff < oneDay {
            return NSLocalizedString("today", comment: "Today message")
        } else if diff < 2 * oneDay {
            return NSLocalizedString("yesterday", comment: "Yerterday message")
        } else if diff < 7 * oneDay {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        } else if diff < 30 * oneDay {
            dateFormatter.dateFormat = "EEEE, d MMM"
            return dateFormatter.string(from: date)
        } else if diff < 365 * oneDay {
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: date)
        }
    }
}
