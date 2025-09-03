//
//  RegisterModel.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/26/24.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

class RegisterViewViewModel: ObservableObject {
    @Published var emailID: String = ""
    @Published var password: String = ""
    @Published var userName: String = ""
    
    // MARK: View Properties
    @Environment(\.dismiss) var dismiss
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var showMessageError: Bool = false
    @Published var messageError: String = ""
    @Published var isLoading: Bool = false
    @Published var isLoginView: Bool = false
    
    // MARK: UserDefaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    init() {}
    
    func register() {
        if validate() {
            registerUser()
        } else {
            showMessageError = true
            showError = true
            return
        }
    }
    
    func registerUser() {
        isLoading = true
        closeKeyboard()
        
        Task {
            do {
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                
                let user = User(username: userName, userUID: userUID, userEmail: emailID, profilePictureURL: "")
                // MARK: Set data as dictionary!! Reminder!!
                try Firestore.firestore().collection("Users").document(userUID).setData(from: user)
                
                // Update UI on main thread
                DispatchQueue.main.async {
                    self.userNameStored = self.userName
                    self.userUID = userUID
                    self.logStatus = true
                    self.isLoading = false
                }
                
            } catch {
                // MARK: Deleting Created Account In Case of Failure
                try? await Auth.auth().currentUser?.delete()
                await setError(error)
            }
        }
    }
    
    // MARK: Displaying Errors VIA Alert
    func setError(_ error: Error) async {
        // MARK: UI Must be Updated on Main Thread
        await MainActor.run {
            showError.toggle()
            isLoading = false
        }
    }
    
    private func validate() -> Bool {
        guard !userName.trimmingCharacters(in: .whitespaces).isEmpty,
              !emailID.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard emailID.contains("@") && emailID.contains(".") else {
            messageError = "Please enter a valid email."
            return false
        }
        guard password.count >= 6 else {
            messageError = "Please enter a stronger password."
            return false
        }
        return true
    }
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
