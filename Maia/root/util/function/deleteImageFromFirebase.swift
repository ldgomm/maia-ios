//
//  deleteImageFromFirebase.swift
//  Maia
//
//  Created by José Ruiz on 27/7/24.
//

import FirebaseStorage

/// Deletes an image from Firebase Storage at the specified path and invokes a completion handler once the operation is finished.
///
/// - Parameters:
///   - path: The path in Firebase Storage where the image is located.
///   - completion: A closure that is called after the deletion attempt is completed.
///                 The closure is called regardless of whether the deletion was successful or failed.
func deleteImageFromFirebase(for path: String, completion: @escaping () -> Void) {
    
    // Create a reference to the Firebase Storage location for the image to be deleted
    let reference = Storage.storage().reference(withPath: path)
    
    // Attempt to delete the image at the specified reference
    reference.delete { error in
        // If there is an error during deletion, print the error message
        if let error = error {
            print("Error deleting image: \(error.localizedDescription)")
        }
        // Call the completion handler to signal that the deletion process is complete
        completion()
    }
}
