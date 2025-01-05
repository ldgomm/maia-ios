//
//  Date.swift
//  Maia
//
//  Created by José Ruiz on 9/7/24.
//

import Foundation

/// An extension on `Date` to provide the current time in milliseconds since the Unix epoch.
extension Date {
    /// Returns the current time as the number of milliseconds since January 1, 1970 (Unix epoch).
    ///
    /// - Returns: The current time in milliseconds as an `Int64`.
    func currentTimeMillis() -> Int64 {
        // Convert the time interval since 1970 (in seconds) to milliseconds
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
