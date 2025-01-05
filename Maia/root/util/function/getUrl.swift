//
//  getUrl.swift
//  Maia
//
//  Created by José Ruiz on 2/8/24.
//

import Foundation

/// Constructs a URL with optional query parameters for a given API endpoint.
///
/// - Parameters:
///   - endpoint: The specific endpoint of the API to which the URL will point.
///   - keywords: Optional query parameter to filter results by keywords. Defaults to `nil`.
///   - storeId: Optional query parameter to filter results by store ID. Defaults to `nil`.
/// - Returns: A URL constructed with the provided endpoint and any optional query parameters.
func getUrl(endpoint: String, keywords: String? = nil, storeId: String? = nil) -> URL {
    
    // Initialize URLComponents with the base URL and the specified endpoint
    var components = URLComponents(string: "https://www.sales.premierdarkcoffee.com/\(endpoint)")!
    
    // Array to hold the query items
    var queryItems = [URLQueryItem]()
    
    // If a storeId is provided, add it as a query item
    if let storeId {
        queryItems.append(URLQueryItem(name: "storeId", value: storeId))
    }
    
    // If keywords are provided, add them as a query item
    if let keywords {
        queryItems.append(URLQueryItem(name: "keywords", value: keywords))
    }
    
    // Assign the query items to the URL components
    components.queryItems = queryItems
    
    // Print the final URL for debugging purposes
    print("URL: \(components.url!)")
    
    // Return the constructed URL
    return components.url!
}
