//
//  GoogleSlidesEmbedModel.swift
//  Unibell
//
//  Created by hyunsuh ham on 8/3/24.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

   
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = true
        webView.isUserInteractionEnabled = true
        webView.configuration.websiteDataStore = .default() // Ensure proper data store configuration
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

import SwiftUI
import Firebase
import FirebaseFirestore

class GoogleSlidesEmbedModel: ObservableObject {
    @Published var embedLink: String = ""
    private var listener: ListenerRegistration?
    @Published var newLink: String = ""
    @Published var updateStatus: String = ""

    func updateEmbedLink(userUID: String) {

           // Validate the embed link
           guard isValidEmbedLink(self.newLink) else {
               self.updateStatus = "Invalid embed link format"
               return
           }

           let db = Firestore.firestore()
           let schoolsRef = db.collection("Schools")

           schoolsRef.getDocuments { (querySnapshot, error) in
               if let error = error {
                   self.updateStatus = "Error: \(error.localizedDescription)"
                   return
               }

               guard let documents = querySnapshot?.documents else {
                   self.updateStatus = "No school documents found"
                   return
               }

               for document in documents {
                   let data = document.data()
                   let students = data["students"] as? [String] ?? []
                   let teachers = data["teachers"] as? [String] ?? []

                   if students.contains(userUID) || teachers.contains(userUID) {
                       // User is found in either students or teachers array
                       let schoolDocumentID = document.documentID
                       db.collection("Schools").document(schoolDocumentID).updateData([
                           "embedLink": self.newLink
                       ]) { error in
                           if let error = error {
                               self.updateStatus = "Error: \(error.localizedDescription)"
                           } else {
                               self.updateStatus = "Embed link updated successfully"
                           }
                       }
                       return
                   }
               }

               self.updateStatus = "User's school document not found"
           }
       }

    private func isValidEmbedLink(_ link: String) -> Bool {
        let pattern = #"https:\/\/docs\.google\.com\/presentation\/d\/e\/[a-zA-Z0-9_-]+\/pub\?start=false&loop=false&delayms=\d+"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: link.utf16.count)
        if let match = regex?.firstMatch(in: link, options: [], range: range) {
            return match.range.location != NSNotFound
        }
        return false
    }
    
    func findUserSchool(userUID: String) {
        let db = Firestore.firestore()
        let schoolsRef = db.collection("Schools")

        schoolsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }

            for document in documents {
                let data = document.data()
                let students = data["students"] as? [String] ?? []
                let teachers = data["teachers"] as? [String] ?? []

                if students.contains(userUID) || teachers.contains(userUID) {
                    self.findEmbedLink(for: document.documentID)
                    break
                }
            }
        }
    }

    private func findEmbedLink(for schoolID: String) {
        let db = Firestore.firestore()
        let schoolRef = db.collection("Schools").document(schoolID)

        listener = schoolRef.addSnapshotListener { (document, error) in
            if let document = document, document.exists {
                self.embedLink = document.data()?["embedLink"] as? String ?? ""
            } else {
                print("Document does not exist or there was an error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    deinit {
        listener?.remove()
    }
}

