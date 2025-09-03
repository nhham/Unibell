//
//  MessagingCenterViewModel.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/25/24.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI
import Firebase


class MessagingCenterViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var schoolID: String = ""
    
    private var db = Firestore.firestore()
    
    func fetchSchoolID() {
        guard let user = Auth.auth().currentUser else { return }
        let userUID = user.uid
        findSchool(for: userUID)
    }
    
    func findSchool(for userUID: String) {
        db.collection("Schools").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting schools: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No schools found")
                return
            }
            
            for document in documents {
                let data = document.data()
                let students = data["students"] as? [String] ?? []
                let teachers = data["teachers"] as? [String] ?? []
                
                if students.contains(userUID) || teachers.contains(userUID) {
                    DispatchQueue.main.async {
                        self.schoolID = document.documentID
                        self.fetchMessages(for: self.schoolID)  // Fetch messages immediately after finding the schoolID
                    }
                    break
                }
            }
        }
    }
    
    func fetchMessages(for schoolID: String) {
        db.collection("Schools").document(schoolID).collection("Messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting messages: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.messages = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: Message.self)
                    } ?? []
                    print("Messages fetched: \(self.messages.count)") // Debugging
                }
            }
    }
    
    func deleteMessage(schoolID: String, messageID: String) {
        db.collection("Schools").document(schoolID).collection("Messages").document(messageID).delete { error in
            if let error = error {
                print("Error deleting message: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.messages.removeAll { $0.id == messageID }
                }
            }
        }
    }
    
    func sendMessage(schoolID: String, senderUID: String, message: String) {
        fetchUserDetails(senderUID: senderUID) { senderName, profilePictureURL in
            let timestamp = Timestamp(date: Date())
            let newMessage = Message(
                senderUID: senderUID,
                senderName: senderName ?? "Unknown",
                profilePictureURL: profilePictureURL,
                message: message,
                timestamp: timestamp
            )
            
            do {
                _ = try self.db.collection("Schools").document(schoolID).collection("Messages").addDocument(from: newMessage)
            } catch {
                print("Error sending message: \(error)")
            }
        }
    }

    func fetchUserDetails(senderUID: String, completion: @escaping (String?, String?) -> Void) {
        db.collection("Users").document(senderUID).getDocument { document, error in
            if let error = error {
                print("Error fetching user details: \(error)")
                completion(nil, nil)
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                completion(nil, nil)
                return
            }
            
            let senderName = data["username"] as? String
            let profilePictureURL = data["profilePictureURL"] as? String
            
            completion(senderName, profilePictureURL)
        }
    }
}
struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var senderUID: String
    var senderName: String
    var profilePictureURL: String?
    var message: String
    var timestamp: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case id
        case senderUID
        case senderName
        case profilePictureURL
        case message
        case timestamp
    }
}

extension DateFormatter {
    static let shortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
