//
//  CalendarViewViewModel.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/25/24.
//

import SwiftUI
import Foundation
import Combine
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import UserNotifications

class CalendarViewModel: ObservableObject {
    @Published var showMessageError: Bool = false
    @Published var messageError: String = ""
    @Published var schoolName: String = ""
    @AppStorage("studentView_status") var studentViewStatus: Bool = false
    @AppStorage("teacherView_status") var teacherViewStatus: Bool = false
    @Published var events: [Event] = []
    @Published var randomQuote: String = ""
    @Published var schoolID: String = ""
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    var userUID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    let quotes = [
        "Don't waste your time waiting for your moment - Nathaniel Ham",
        "Believe you can and you're halfway there. – Theodore Roosevelt",
        "You are never too old to set another goal or to dream a new dream. – C.S. Lewis",
        "The only way to achieve the impossible is to believe it is possible. – Charles Kingsleigh",
        "Act as if what you do makes a difference. It does. – William James",
        "There's no one I'd rather be than me. - Ralph, Wreck-It Ralph",
        "You are braver than you believe, stronger than you seem, and smarter than you think. – A.A. Milne",
        "Reach high and you'll end up somewhere - Anonymous",
        "You are the most talented, most interesting, and most extraordinary person in the universe. - Emmett, Lego",
        "The best way to predict the future is to create it. – Peter Drucker",
        "Do not wait to strike till the iron is hot; but make it hot by striking. – William Butler Yeats",
        "The only limit to our realization of tomorrow is our doubts of today. – Franklin D. Roosevelt",
        "You are capable of more than you know. – Glinda, Wizard of Oz",
        "Start where you are. Use what you have. Do what you can. – Arthur Ashe",
        "Dream big and dare to fail. – Norman Vaughan",
        "Everything you’ve ever wanted is on the other side of fear. – George Addair",
        "The past can hurt. But the way I see it, you can either run from it or learn from it. - Rafiki, Lion King",
        "It always seems impossible until it’s done. – Nelson Mandela",
        "You don’t have to be great to start, but you have to start to be great. – Zig Ziglar",
        "Don't try, just do. - My Dad",
        "The future belongs to those who believe in the beauty of their dreams. – Eleanor Roosevelt",
        "With the new day comes new strength and new thoughts. – Eleanor Roosevelt",
        "Our greatest glory is not in never falling, but in rising every time we fall. – Confucius",
        "The harder you work for something, the greater you’ll feel when you achieve it. – Anonymous",
        "Don’t watch the clock; do what it does. Keep going. – Sam Levenson",
        "The secret of getting ahead is getting started. – Mark Twain",
        "The only place where success comes before work is in the dictionary. – Vidal Sassoon",
        "If you want to lift yourself up, lift up someone else. – Booker T. Washington",
        "Your limitation—it’s only your imagination. – Anonymous",
        "Push yourself, because no one else is going to do it for you. – Anonymous",
        "Everyone is good in heart so look for the good in others. - My Brother",
        "Great things never come from comfort zones. – Anonymous",
        "Don’t stop when you’re tired. Stop when you’re done. – Marilyn Monroe",
        "The way to get started is to quit talking and begin doing. – Walt Disney",
        "If you are not willing to risk the usual, you will have to settle for the ordinary. – Jim Rohn",
        "Go the extra mile. It's never crowded there. – Wayne Dyer",
        "Believe in yourself and all that you are. – Christian D. Larson",
        "Your time is limited, don't waste it living someone else's life. – Steve Jobs",
        "Whether you think you can or you think you can’t, you’re right. – Henry Ford",
        "Fall seven times and stand up eight. – Japanese Proverb",
        "The only way to do great work is to love what you do. – Steve Jobs",
        "I am not a product of my circumstances. I am a product of my decisions. – Stephen R. Covey",
        "Would you like to stay forever?! - Grandmother Fa, Mulan",
        "We generate fears while we sit. We overcome them by action. – Dr. Henry Link",
        "The only way to achieve the impossible is to believe it is possible. – Charles Kingsleigh",
        "Success is not in what you have, but who you are. – Bo Bennett",
        "In the middle of every difficulty lies opportunity. – Albert Einstein",
        "You are my joy, making everyone smile - My Mom, whom I love.",
        "The biggest adventure you can take is to live the life of your dreams. – Oprah Winfrey",
        "Do what you can, with what you have, where you are. – Theodore Roosevelt",
        "You are enough just as you are. – Meghan Markle",
        "It's not about perfect. It's about effort. – Jillian Michaels",
        "Dream big and dare to fail. – Norman Vaughan",
        "Your life does not get better by chance, it gets better by change. – Jim Rohn",
        "Don’t wait for opportunity. Create it. – Anonymous",
        "It’s not whether you get knocked down, it’s whether you get up. – Vince Lombardi",
        "Success is walking from failure to failure with no loss of enthusiasm. – Winston Churchill",
        "What we achieve inwardly will change outer reality. – Plutarch",
        "Believe you can and you’re halfway there. – Theodore Roosevelt",
        "Life is 10% what happens to us and 90% how we react to it. – Charles R. Swindoll",
        "Act as if what you do makes a difference. It does. – William James",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis",
        "If you can dream it, you can achieve it. – Zig Ziglar",
        "The only limit to our realization of tomorrow is our doubts of today. – Franklin D. Roosevelt",
        "The purpose of our lives is to be happy. – Dalai Lama",
        "Strive not to be a success, but rather to be of value. – Albert Einstein",
        "You are braver than you believe, stronger than you seem, and smarter than you think. – A.A. Milne",
        "The only way to do great work is to love what you do. – Steve Jobs",
        "Keep your face always toward the sunshine—and shadows will fall behind you. – Walt Whitman",
        "Don't watch the clock; do what it does. Keep going. – Sam Levenson",
        "You get in life what you have the courage to ask for. – Oprah Winfrey",
        "We become what we think about. – Earl Nightingale",
        "Success is not the key to happiness. Happiness is the key to success. – Albert Schweitzer",
        "Our greatest glory is not in never falling, but in rising every time we fall. – Confucius",
        "The secret of getting ahead is getting started. – Mark Twain",
        "Life is what happens when you’re busy making other plans. – John Lennon",
        "Success is not in what you have, but who you are. – Bo Bennett",
        "Believe you can and you're halfway there. – Theodore Roosevelt",
        "You are capable of amazing things. – Anonymous",
        "It always seems impossible until it’s done. – Nelson Mandela",
        "The harder you work for something, the greater you’ll feel when you achieve it. – Anonymous",
        "The best way to predict the future is to create it. – Peter Drucker",
        "The only place where success comes before work is in the dictionary. – Vidal Sassoon",
        "Not everyone is a great artist, but a great artist can come from anywhere. - Ego, Ratatouille",
        "Don't watch the clock; do what it does. Keep going. – Sam Levenson",
        "Believe in yourself and all that you are. – Christian D. Larson",
        "With the new day comes new strength and new thoughts. – Eleanor Roosevelt",
        "Dream big and dare to fail. – Norman Vaughan",
        "You get what you give. – Jennifer Lopez",
        "Push yourself, because no one else is going to do it for you. – Anonymous",
        "Success is the sum of small efforts, repeated day in and day out. – Robert Collier",
        "Your life does not get better by chance, it gets better by change. – Jim Rohn",
        "The only way to achieve the impossible is to believe it is possible. – Charles Kingsleigh",
        "Go the extra mile. It's never crowded there. – Wayne Dyer",
        "Your time is limited, don't waste it living someone else's life. – Steve Jobs",
        "I've never regretted a selfless decision, I have with a selfish one. - Sam Ham",
        
    ]
    
    init() {
        auth.addStateDidChangeListener { [weak self] (auth, user) in
            if let user = user {
                self?.isUserInSchool(userUID: user.uid)
            } else {
                self?.studentViewStatus = false
                self?.teacherViewStatus = false
            }
        }
        self.randomQuote = getRandomQuote()
    }
    
    func checkCode(enteredCode: String) {
           guard let userUID = userUID else { return }
           
           let enteredCode = enteredCode.lowercased()
           
           db.collection("Schools").getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("Error getting document: \(error)")
                   return
               }
               if let snapshot = querySnapshot {
                   for document in snapshot.documents {
                       let storedStudentCode = (document.data()["code"] as? String ?? "").lowercased()
                       let storedTeacherCode = (document.data()["teacherkey"] as? String ?? "").lowercased()
                       
                       if storedStudentCode == enteredCode {
                           self.addUserToSchool(userUID: userUID, schoolID: document.documentID, userType: "student")
                           self.schoolID = document.documentID
                           return
                       } else if storedTeacherCode == enteredCode {
                           self.addUserToSchool(userUID: userUID, schoolID: document.documentID, userType: "teacher")
                           self.schoolID = document.documentID
                           return
                       }
                   }
               }
               
               self.showMessageError = true
               self.messageError = "School does not exist"
           }
       }
       
       func addUserToSchool(userUID: String, schoolID: String, userType: String) {
           let fieldToUpdate = userType == "student" ? "students" : "teachers"
           let viewStatusKeyPath = userType == "student" ? \CalendarViewModel.studentViewStatus : \CalendarViewModel.teacherViewStatus
           
           db.collection("Schools").document(schoolID).updateData([
               fieldToUpdate: FieldValue.arrayUnion([userUID])
           ]) { error in
               if let error = error {
                   print("Error adding user to school: \(error.localizedDescription)")
                   return
               }
               
               self.db.collection("Schools").document(schoolID).getDocument { (document, error) in
                   if let document = document, document.exists {
                       if let icsFile = document.get("icsFile") as? String {
                           self.loadEvents(from: icsFile)
                       }
                       if let school = document.get("name") as? String {
                           self.schoolName = school
                       }
                   }
                   withAnimation(.interactiveSpring) {
                       self[keyPath: viewStatusKeyPath] = true
                   }
               }
           }
       }
       
       func isUserInSchool(userUID: String) {
           db.collection("Schools").whereField("students", arrayContains: userUID).getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("Error getting document: \(error)")
                   self.studentViewStatus = false
                   return
               }
               
               if let snapshot = querySnapshot, !snapshot.documents.isEmpty {
                   self.studentViewStatus = true
                   let document = snapshot.documents.first
                   if let icsFile = document?.data()["icsFile"] as? String {
                       self.loadEvents(from: icsFile)
                   }
                   if let school = document?.data()["name"] as? String {
                       self.schoolName = school
                   }
               } else {
                   self.db.collection("Schools").whereField("teachers", arrayContains: userUID).getDocuments { (querySnapshot, error) in
                       if let error = error {
                           print("Error getting document: \(error)")
                           self.teacherViewStatus = false
                           return
                       }
                       
                       if let snapshot = querySnapshot, !snapshot.documents.isEmpty {
                           self.teacherViewStatus = true
                           let document = snapshot.documents.first
                           if let icsFile = document?.data()["icsFile"] as? String {
                               self.loadEvents(from: icsFile)
                           }
                           if let school = document?.data()["name"] as? String {
                               self.schoolName = school
                           }
                       } else {
                           self.studentViewStatus = false
                           self.teacherViewStatus = false
                       }
                   }
               }
           }
       }
    
    
    func getRandomQuote() -> String {
        guard let randomIndex = quotes.indices.randomElement() else {
            return "No quotes available"
        }
        return quotes[randomIndex]
    }
    
    func getIcsFileForUser() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Error, could not get user")
            return
        }
        
        db.collection("Schools").whereField("students", arrayContains: userUID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            if let snapshot = querySnapshot, !snapshot.documents.isEmpty {
                for document in snapshot.documents {
                    if let filePath = document.data()["icsFile"] as? String {
                        self.loadEvents(from: filePath)
                        return
                    }
                    if let school = document.data()["name"] as? String {
                        self.schoolName = school
                    }
                }
            } else {
                self.db.collection("Schools").whereField("teachers", arrayContains: userUID).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                        return
                    }
                    if let snapshot = querySnapshot, !snapshot.documents.isEmpty {
                        for document in snapshot.documents {
                            if let filePath = document.data()["icsFile"] as? String {
                                self.loadEvents(from: filePath)
                                return
                            }
                            if let school = document.data()["name"] as? String {
                                self.schoolName = school
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getIcsFileForSchool(schoolID: String) {
        db.collection("Schools").document(schoolID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let icsFile = document.get("icsFile") as? String {
                    self.loadEvents(from: icsFile)
                } else {
                    print("ICS File not found.")
                }
            } else {
                print("No matching document.")
            }
        }
    }
    
    func loadEvents(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data, let fileContents = String(data: data, encoding: .utf8) else {
                print("Failed to load data or convert to string")
                return
            }
            
            DispatchQueue.main.async {
                self.events = self.parseICalFile(fileContents: fileContents)
            }
        }.resume()
    }
    func removeCurrentUserFromSchool() {
        
        let db = Firestore.firestore()
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated.")
            return
        }
        
        db.collection("Schools").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let snapshot = querySnapshot else {
                print("Error: No school documents found.")
                return
            }
            
            for document in snapshot.documents {
                let schoolID = document.documentID
                
                // Check both "students" and "teachers" arrays
                for fieldToUpdate in ["students", "teachers"] {
                    db.collection("Schools").document(schoolID).updateData([
                        fieldToUpdate: FieldValue.arrayRemove([userUID])
                    ]) { error in
                        if let error = error {
                            print("Error removing user from \(fieldToUpdate): \(error.localizedDescription)")
                            
                        } else {
                            print("User removed successfully from \(fieldToUpdate) in \(schoolID).")
                            withAnimation(.default) {
                                self.teacherViewStatus = false
                                self.studentViewStatus = false
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    private func parseICalFile(fileContents: String) -> [Event] {
        var events: [Event] = []
        let lines = fileContents.components(separatedBy: .newlines)
        var currentEvent: Event?
        
        for line in lines {
            if line.starts(with: "BEGIN:VEVENT") {
                currentEvent = Event(startDate: Date(), summary: "", description: "")
            } else if line.starts(with: "DTSTART:") {
                let dateString = String(line.dropFirst(8))
                currentEvent?.startDate = parseDate(from: dateString) ?? Date()
            } else if line.starts(with: "SUMMARY:") {
                let summary = String(line.dropFirst(8))
                currentEvent?.summary = summary.removingPercentEncoding ?? summary
            } else if line.starts(with: "SUMMARY;ENCODING=QUOTED-PRINTABLE:") {
                let summary = String(line.dropFirst(34))
                currentEvent?.summary = summary.removingPercentEncoding ?? summary
            } else if line.starts(with: "DESCRIPTION:") {
                let description = String(line.dropFirst(12))
                currentEvent?.description = description.removingPercentEncoding ?? description
            } else if line.starts(with: "END:VEVENT") {
                if let event = currentEvent {
                    events.append(event)
                }
            }
        }
        return events
    }
    
    
    private func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        // Handle different formats
        if dateString.contains("T") {
            if dateString.contains("Z") {
                // Format: yyyyMMdd'T'HHmmss'Z'
                dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            } else {
                // Format: yyyyMMdd'T'HHmmss
                dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
            }
        } else {
            // Format: yyyyMMdd
            dateFormatter.dateFormat = "yyyyMMdd"
        }
        
        return dateFormatter.date(from: dateString)
    }
}
struct Event: Identifiable, Equatable {
    let id = UUID()
    var startDate: Date
    var summary: String
    var description: String
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id &&
        lhs.startDate == rhs.startDate &&
        lhs.summary == rhs.summary &&
        lhs.description == rhs.description
        
    }
}
