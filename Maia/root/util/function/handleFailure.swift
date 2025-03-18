//
//  handleFailure.swift
//  Maia
//
//  Created by José Ruiz on 30/7/24.
//

import Foundation

/// Handles network failures by printing an appropriate error message based on the type of `NetworkError`.
///
/// - Parameter failure: The `NetworkError` to be handled. This determines which error message will be printed.
func handleNetworkError(_ failure: NetworkError) -> String {
    // Switch on the specific type of NetworkError to print a corresponding error message
    switch failure {
    case .decodeError(let underlying):
        print("Decode error: \(String(describing: underlying?.localizedDescription))")
        return "File format error: Check file content"
        
    case .downloadError(let underlying):
        print("Decode error: \(String(describing: underlying?.localizedDescription))")
        return "Error downloading file: Check internet connection"
        
    case .notFoundError:
        return "Not found error: \(failure.localizedDescription)"
        
    case .notModifiedError:
        return "Not modified error: \(failure.localizedDescription)"
        
    case .badRequestError:
        return "Bad request error: \(failure.localizedDescription)"
        
    case .unauthorizedError:
        print("Unauthorized error: \(failure.localizedDescription)")
        // You might want to add actions like redirecting to login
        return "Please check your credentials and try again."
        
    case .forbiddenError:
        print("Forbidden error: \(failure.localizedDescription)")
        // Additional actions like logging permission-related errors
        return "You do not have permission to perform this action."
        
    case .serverError:
        print("Server error: \(failure.localizedDescription)")
        // Notify that the issue is on the server-side
        return "There was a problem on the server. Please try again later."
        
    case .timeoutError:
        print("Timeout error: \(failure.localizedDescription)")
        // You might want to add retry logic for timeout errors
        return "The request timed out. Please check your connection and try again."
        
    case .unknownError:
        print("Unknown error: \(failure.localizedDescription)")
        // Log additional information about the unknown error
        return "An unexpected error occurred. Please try again later."
    }
}
