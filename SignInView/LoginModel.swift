//
//  LoginModel.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/28/24.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth
import Firebase
import Combine
import FirebaseStorage



struct User: Identifiable,Codable {
    
    @DocumentID var id: String?
    var username: String
    var userUID: String
    var userEmail: String
    var profilePictureURL: String?
    
    enum CodingKeys: CodingKey {
        case id
        case username
        case userUID
        case userEmail
        case profilePictureURL
        
    }
}
extension Encodable{
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else{
            return  [:]
            
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}

class LoginViewViewModel: ObservableObject {
 
    @Published var emailID = ""
    @Published var password = ""
    @Published var createAccount: Bool = false
    @Published var resetKeycode: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var messageError: String = ""
    @Published var isLoading: Bool = false
    @Published var showMessageError: Bool = false
    @Published private var showLinkSent = false
    @Published var selectedImage: UIImage?
    
    // MARK: User Defaults
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("log_status") var logStatus: Bool = false
    
    private var cancellables = Set<AnyCancellable>()

    init() {}

    func login() {
        if validate() {
            loginUser()
        } else {
            DispatchQueue.main.async {
                self.showMessageError = true
                self.isLoading = false
            }
            return
        }
    }

    func loginUser() {
        isLoading = true
        closeKeyboard()
        Task {
            do {
                // With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
                try await fetchUser()
            } catch {
                messageError = "Incorrect password and/or email."
                await setError(error)
            }
        }
    }

    private func validate() -> Bool {
        guard !emailID.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            messageError = "Please fill in all spaces."
            return false
        }
        guard emailID.contains("@") && emailID.contains(".") else {
            messageError = "Please enter a valid email."
            return false
        }

        return true
    }

    // MARK: If User if Found then Fetching User Data From Firestore
    func fetchUser() async throws {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        // MARK: UI Updating Must be Run On Main Thread
        await MainActor.run {
            // Setting UserDefaults data and Changing App's Auth Status
            userUID = userID
            userNameStored = user.username
            logStatus = true
            isLoading = false
        }
    }

    // MARK: Displaying Errors VIA Alert
    func setError(_ error: Error) async {
        // MARK: UI Must be Updated on Main Thread
        await MainActor.run {
            errorMessage = messageError
            showMessageError = true
            isLoading = false
        }
    }

    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



