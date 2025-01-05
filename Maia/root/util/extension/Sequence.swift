//
//  Sequence.swift
//  Maia
//
//  Created by José Ruiz on 10/7/24.
//

import Foundation

// Extension to the Sequence protocol
extension Sequence {
    
    /**
     Groups the elements of the sequence into a dictionary based on a specified key.
     - Parameter key: A closure that takes an element of the sequence as its argument and returns a hashable key.
     - Returns: A dictionary where the keys are the hashable values returned by the key closure, and the values are arrays of elements that correspond to those keys.
     - Note: This method uses the key closure to determine the grouping of elements. If multiple elements result in the same key, they will be grouped together in an array.
     - Complexity: O(n), where n is the number of elements in the sequence.
     
     # Example #
     ```
     let words = ["apple", "banana", "apricot", "blueberry", "avocado"]
     let grouped = words.groupBy { $0.first! }
     // grouped will be:
     // [
     //   "a": ["apple", "apricot", "avocado"],
     //   "b": ["banana", "blueberry"]
     // ]
     ```
     */
    func groupBy<U: Hashable>(key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        // Initialize an empty dictionary to hold the grouped elements
        var dict: [U: [Iterator.Element]] = [:]
        
        // Iterate over each element in the sequence
        forEach { element in
            // Compute the key for the current element using the provided key closure
            let key = key(element)
            
            // Check if the dictionary already contains an array for the computed key
            if dict[key] == nil {
                // If not, create a new array with the current element
                dict[key] = [element]
            } else {
                // If it does, append the current element to the existing array
                dict[key]?.append(element)
            }
        }
        
        // Return the dictionary containing the grouped elements
        return dict
    }
}
