//
//  AgendaScheduleModel.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/28/24.
//

import FirebaseFirestoreSwift
import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

/// ViewModel for single to do list itme view (each row in items list)
/// Primary tab
class AgendaScheduleViewViewModel: ObservableObject {
    @Published var showingNewItemView: Bool = false
    private let userUID: String
    init(userUID: String) {
        self.userUID =  userUID
    }
    
    /// Delete agenda list item
    ///  - Parameter id: Item id to delete
    func delete(id: String) {
        let db = Firestore.firestore()
        
        db.collection("Users")
            .document(userUID)
            .collection("agendaItems")
            .document(id)
            .delete()
    }
}

class AgendaScheduleViewModel: ObservableObject {
    init() {}
     
    func toggleIsDone(item: agendaItem){
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let db = Firestore.firestore()
        db.collection("Users")
            .document(uid)
            .collection("agendaItems")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
        
      
    }
    
}

class newItemViewModel: ObservableObject {
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var showAlert: Bool = false
    @Published var Color: Color = .mint
    init() {}
    
    func save() {
        guard canSave else {
            return
        }
        
        // Get current user ID
        
        guard let useruid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create Model
        let newId = UUID().uuidString
        let newItem =  agendaItem(id: newId, title: title, dueDate: dueDate.timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, color: Color.toHexString()!, isDone: false)
        
        
        
        // Save Model
        let db = Firestore.firestore()
        
        db.collection("Users")
            .document(useruid)
            .collection("agendaItems")
            .document(newId)
            .setData(newItem.asDictionary())
            
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
        
        return true
    }
}

struct agendaItem: Codable, Identifiable {
    let id: String
    let title: String
    let dueDate: TimeInterval
    var createdDate: TimeInterval
    var color: String
    var isDone: Bool
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
 
}

extension Date {
    static func updateHour(_ value: Int) -> Date{
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}

extension View {
    
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    func vSpacing(_ alignment: Alignment) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
         return Calendar.current.isDate(date1, inSameDayAs: date2)
     }
}

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    var isSameHour: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
    }
    var isPast: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedAscending
    }

    
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startofDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startofDate)
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        
        /// Iterating to get the Full Week
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startofLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startofLastDate) else {
            return[]
        }
        return fetchWeek(nextDate)
    }
    
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startofFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startofFirstDate) else {
            return[]
        }
        return fetchWeek(previousDate)
    }

    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}

struct OffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

