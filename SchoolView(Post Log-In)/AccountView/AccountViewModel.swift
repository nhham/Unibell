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
        guard let userUID = Auth.auth().currentUser?.uid else{
            return
        }
        let db = Firestore.firestore()
        db.collection("Users").document(userUID).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            DispatchQueue.main.async{
                self?.user = User(username: data["username"] as? String ?? "", userUID: data["userUID"] as? String ?? "", userEmail: data["userEmail"] as? String ?? "", schoolAccessCode: data["schoolAccessCoode"] as? String ?? "")
            }
        }
    }
}

