//
//  formatPrice.swift
//  Maia
//
//  Created by José Ruiz on 5/8/24.
//

import Foundation

/// Formats a given amount into a currency string using the specified currency code.
///
/// - Parameters:
///   - amount: The monetary amount to be formatted.
///   - currency: The currency code (e.g., "USD", "EUR") used to format the amount.
/// - Returns: A formatted currency string. If formatting fails, it returns a fallback string
///            consisting of the currency code followed by the unformatted amount.
func formatPrice(amount: Double, currency: String) -> String {
    
    // Initialize a NumberFormatter to format the amount as a currency
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency // Set the number style to currency
    formatter.currencyCode = currency // Set the currency code
    
    // Attempt to format the amount as a currency string
    // If formatting fails, return a fallback string with the currency code and the unformatted amount
    return formatter.string(from: NSNumber(value: amount)) ?? "\(currency) \(amount)"
}
