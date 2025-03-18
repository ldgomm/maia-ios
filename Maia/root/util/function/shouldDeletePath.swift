//
//  shouldDeletePath.swift
//  Maia
//
//  Created by José Ruiz on 29/7/24.
//

import FirebaseAuth
import Foundation

/// Determines whether a given path should be deleted based on its prefix and length, considering the current user's ID.
///
/// - Parameter path: The path to be evaluated.
/// - Returns: A Boolean value indicating whether the path should be deleted.
///            Returns `true` if the path starts with the base path for the current user and is longer than the base path.
///            Returns `false` if the user's ID is unavailable or if the path does not meet the conditions.
func shouldDeletePath(path: String) -> Bool {
    
    // Safely unwrap the current user's UID; if unavailable, return false
    guard let id = Auth.auth().currentUser?.uid else { return false }
    
    // Construct the base path using the current user's UID
    let basePath = "fake/stores/images/\(id)"
    
    // Check if the path starts with the base path and has additional characters beyond the base path
    return path.hasPrefix("\(basePath)/") && path.count > basePath.count
}
