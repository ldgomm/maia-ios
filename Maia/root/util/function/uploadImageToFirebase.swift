//
//  uploadImageToFirebase.swift
//  Maia
//
//  Created by José Ruiz on 1/8/24.
//

import FirebaseStorage
import Foundation

/// Uploads an image to Firebase Storage at the specified path and returns the image's info upon completion.
///
/// - Parameters:
///   - path: The path in Firebase Storage where the image will be uploaded.
///   - data: The image data to be uploaded.
///   - completion: A closure that is called with the `ImageInfo` object upon successful upload.
///                 The `ImageInfo` contains the storage path and the download URL of the uploaded image.
func uploadImageToFirebase(for path: String, with data: Data, completion: @escaping (ImageInfo) -> Void) {
    
    // Create a reference to the Firebase Storage location with the specified path
    let reference = Storage.storage().reference(withPath: path)
    
    // Upload the image data to the specified reference
    reference.putData(data, metadata: nil) { metadata, error in
        // Handle error if upload fails
        if let error {
            print(error.localizedDescription)
            return
        }
        
        // Retrieve the download URL for the uploaded image
        reference.downloadURL { url, error in
            // Handle error if retrieving the download URL fails
            if let error {
                print(error.localizedDescription)
                return
            }
            
            // Ensure the URL is not nil
            guard let downloadURL = url else {
                print("URL is nil")
                return
            }
            
            // Create an ImageInfo object containing the path and the download URL
            let pathInfo = reference.fullPath
            let urlInfo = downloadURL.absoluteString
            let imageInfo = ImageInfo(path: pathInfo, url: urlInfo)
            
            // Call the completion handler with the ImageInfo object
            completion(imageInfo)
        }
    }
}

func uploadImageToFirebaseWithProcessHandler(for path: String, with data: Data, progressHandler: @escaping (Double) -> Void, completion: @escaping (ImageInfo?) -> Void) {
    let reference = Storage.storage().reference(withPath: path)
    let uploadTask = reference.putData(data, metadata: nil)

    // Observe the upload progress
    uploadTask.observe(.progress) { snapshot in
        let percentComplete = Double(snapshot.progress?.completedUnitCount ?? 0) / Double(snapshot.progress?.totalUnitCount ?? 1)
        progressHandler(percentComplete)
    }

    // Observe the upload completion
    uploadTask.observe(.success) { snapshot in
        reference.downloadURL { url, error in
            if let error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let downloadURL = url else {
                print("URL is nil")
                completion(nil)
                return
            }
            let pathInfo = reference.fullPath
            let urlInfo = downloadURL.absoluteString
            let imageInfo = ImageInfo(path: pathInfo, url: urlInfo)
            completion(imageInfo)
        }
    }

    uploadTask.observe(.failure) { snapshot in
        if let error = snapshot.error {
            print(error.localizedDescription)
            completion(nil)
        }
    }
}
