//
//  FirebaseItemsViewModel.swift
//  Unibell
//
//  Created by hyunsuh ham on 6/28/24.
//


import Swift
import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI

class FirestoreQueryManager: ObservableObject {

    @Published var items: [agendaItem] = []
    @Published var errorMessage: String = ""
    
    private var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    func updateQuery(userUID: String, currentDate: Date) {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: currentDate).timeIntervalSince1970
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: Date(timeIntervalSince1970: startOfDate))!.timeIntervalSince1970
        print("Updating query for user: \(userUID), startOfDate: \(startOfDate), endOfDate: \(endOfDate)")
        
        listener?.remove()
        listener = Firestore.firestore().collection("Users").document(userUID).collection("agendaItems")
            .whereField("dueDate", isGreaterThanOrEqualTo: startOfDate)
            .whereField("dueDate", isLessThan: endOfDate)
            .order(by: "dueDate")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error fetching documents: \(error.localizedDescription)"
                        print(self.errorMessage)
                    }
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    DispatchQueue.main.async {
                        self.errorMessage = "No documents found."
                        print(self.errorMessage)
                    }
                    return
                }
                
                let fetchedItems = documents.compactMap { doc in
                    let result = Result { try doc.data(as: agendaItem.self) }
                    switch result {
                    case .success(let item):
                        print("Successfully decoded document: \(item)")
                        return item
                    case .failure(let error):
                        print("Error decoding document: \(error)")
                        return nil
                    }
                }
                
                DispatchQueue.main.async {
                    self.items = fetchedItems
                    if self.items.isEmpty {
                        print("No items found matching the query.")
                        self.errorMessage = "No items found"
                    } else {
                        print("Fetched items: \(self.items)")
                        self.errorMessage = ""
                    }
                }
            }
    }
}

