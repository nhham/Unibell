//
//  AccountViewModel.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/29/24.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage
import Firebase


class AccountViewModel: ObservableObject {
    
    init() {}
    @Published var user: User? = nil
    
    func fetchUser() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Error: No user UID found.")
            return
        }
        let db = Firestore.firestore()
        db.collection("Users").document(userUID).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self?.user = User(
                    username: data["username"] as? String ?? "",
                    userUID: data["userUID"] as? String ?? "", // Ensure userUID is fetched correctly
                    userEmail: data["userEmail"] as? String ?? "",
                    profilePictureURL: data["profilePictureURL"] as? String
                )
                print("Fetched user UID: \(self?.user?.userUID ?? "No UID")")
            }
        }
    }
    func uploadProfilePicture(selectedImage: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AccountViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profile_pictures/\(userID).jpg")
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.75) else {
            completion(.failure(NSError(domain: "AccountViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to convert image to data"])))
            return
        }
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let url = url else {
                    completion(.failure(NSError(domain: "AccountViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve download URL"])))
                    return
                }
                
                let profilePictureURL = url.absoluteString
                let db = Firestore.firestore()
                db.collection("Users").document(userID).updateData(["profilePictureURL": profilePictureURL]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
}


