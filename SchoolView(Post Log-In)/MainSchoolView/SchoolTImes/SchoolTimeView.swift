//
//  SchoolTimeView.swift
//  Unibell
//
//  Created by hyunsuh ham on 6/10/24.
//

import SwiftUI
import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth
import Firebase
import UserNotifications

struct SchoolTimeView: View {
    @Environment(\.xLargeFontSize) var xLargeFontSize
    @Environment(\.largeFontSize) var largeFontSize
    @Environment(\.mediumFontSize) var mediumFontSize
    @Environment(\.smallFontSize) var smallFontSize
    @Environment(\.xSmallFontSize) var xSmallFontSize
    @Environment(\.xLargePaddingSize) var xLargePaddingSize
    @Environment(\.largePaddingSize) var largePaddingSize
    @Environment(\.mediumPaddingSize) var mediumPaddingSize
    @Environment(\.smallPaddingSize) var smallPaddingSize
    @Environment(\.xSmallPaddingSize) var xSmallPaddingSize
    @StateObject private var loginModel = LoginViewViewModel()
    @StateObject private var calendarModel = CalendarViewModel()
    @StateObject private var timer = CountdownTimer(currentSchedule: .regular)
    @State private var typeOfDay: String = ""
    @State private var eventString: String = "Regular Day"
    @State private var nextEventString: String = "Regular Day"
    @State private var nextDayEvent: String = "Regular Day"
    @State private var showTaskView: Bool = false
  
    
    var body: some View {

        VStack(alignment: .center, spacing: 10) {
            GeometryReader { bound in
                VStack {
                    ZStack {
                        ClockImageView()
                            .frame(width: 200, height: 200)
                            .opacity(0.4)
                            .hAlign(.center)
                        Text(timer.timeUntilNextEvent)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: largeFontSize))
                            .fontWeight(.bold)
                        
                    }
                    Text(timer.currentTimeInSchedule.rawValue)
                        .font(.system(size: smallFontSize))
                        .foregroundStyle(.gray)
                        .padding(xSmallPaddingSize)
                        .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 20)), in: .rect(cornerRadius: 20))
                   
                }
            }
         
        }
     
        .onAppear {
         
            calendarModel.getIcsFileForUser()
            
        }
        .onChange(of: calendarModel.events) { _, newValue in
            updateView()
        }
        .sheet(isPresented: $showTaskView, content: {
            AllTasksView(userUID: loginModel.userUID)
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
                .presentationCornerRadius(30)
                .presentationBackground(.white)
                .padding()
            
        })
    }
    private func updateView() {
        let today = Calendar.current.startOfDay(for: Date())
        var foundToday = false
        var nextValidDay: Event?
        var earliestFutureDate: Date? // To track the earliest valid future event

        // Iterate through all events
        for event in calendarModel.events {
            let eventDate = Calendar.current.startOfDay(for: event.startDate)

            if eventDate == today {
                // Check for valid event today
                if let validEvent = findValidEvent(for: event, currentBest: nil) {
                    determineEventString(for: validEvent, isNextEvent: false)
                    print(eventString)
                    typeOfDay = validEvent.summary
                    timer.schedule = determineSchedule(for: eventString)
                    timer.setupSchoolTimes()
                    foundToday = true

                    // Schedule notifications for passing periods
                    for passingPeriod in timer.schoolTimes {
                        if timer.timesInSchedule[passingPeriod] == .passingPeriod {
                            let notificationDate = passingPeriod.addingTimeInterval(-2 * 60) // 2 minutes before end
                            scheduleNotification(for: notificationDate, withTitle: "Class starts soon!", body: "You have 2 minutes until the next class.")
                        }
                    }
                }
            } else if eventDate > today {
                // Handle future valid events
                if let validEvent = findValidEvent(for: event, currentBest: nil) {
                    if let earliest = earliestFutureDate {
                        if eventDate < earliest {
                            nextValidDay = validEvent
                            earliestFutureDate = eventDate
                        }
                    } else {
                        nextValidDay = validEvent
                        earliestFutureDate = eventDate
                    }
                }
            }
        }

        // Handle case where no valid event is found today
        if !foundToday {
            typeOfDay = "No School"
            eventString = "No School"
            timer.schedule = .noSchool
        }

        // Handle next valid event
        if let nextEvent = nextValidDay {
            nextDayEvent = nextEvent.summary
            timer.nextValidEventDate = Calendar.current.startOfDay(for: nextEvent.startDate)
            determineEventString(for: nextEvent, isNextEvent: true)
            print(nextDayEvent)
            timer.nextDaySchedule = determineSchedule(for: nextEventString)
            timer.setupSchoolTimes()

            // Calculate the time difference between now and the next valid event
            let timeUntilNextEvent = Calendar.current.dateComponents([.hour], from: Date(), to: nextEvent.startDate)
            print("Time until next valid event: \(timeUntilNextEvent.hour ?? 0) hours")
        }
    }

    private func findValidEvent(for event: Event, currentBest: Event?) -> Event? {
        // Define precedence for event types
        let precedence = [
            "Assembly": 1,
            "Homecoming Assembly": 1,
            "Multicultural Assembly": 1,
            "Early Dismissal": 2,
            "Late Start": 3,
            "A-Day": 4,
            "B-Day": 4,
            "Summer School": 5,
            "No School": 6
        ]

        // Compare the current event with the best found so far based on precedence
        var bestEvent = currentBest
        var highestPrecedence: Int = Int.max

        if let currentBest = currentBest {
            for (keyword, eventPrecedence) in precedence {
                if event.summary.contains(keyword), eventPrecedence < highestPrecedence {
                    highestPrecedence = eventPrecedence
                    bestEvent = event
                }
            }
        } else {
            for (keyword, eventPrecedence) in precedence {
                if event.summary.contains(keyword) {
                    highestPrecedence = eventPrecedence
                    bestEvent = event
                }
            }
        }

        return bestEvent
    }

    private func determineEventString(for event: Event, isNextEvent: Bool) {
        if event.summary.contains("No School") || event.summary.contains("No Summer School") || event.summary.contains("Closed") || event.summary.contains("No Classes"){
            if isNextEvent {
                nextEventString = "No School"
            } else {
                eventString = "No School"
            }
        } else if event.summary.contains("Summer School") {
            if isNextEvent {
                nextEventString = "Summer School"
            } else {
                eventString = "Summer School"
            }
        } else if event.summary.contains("Late Start") || event.summary.contains("Late Start (A-Day)") || event.summary.contains("Late Start (B-Day") {
            if isNextEvent{
                nextEventString = "Late Start"
            } else {
                eventString = "Late Start"
            }
        } else if event.summary.contains("Early Dismissal") || event.summary.contains("Early Dismissal (A-Day)") || event.summary.contains("Early Dismissal (B-Day)") {
            if isNextEvent {
                nextEventString = "Early Dismissal"
            } else {
                eventString = "Early Dismissal"
            }
        } else if event.summary.contains("Multicultural Assembly") {
            if isNextEvent {
                nextEventString = "Assembly Split"
            } else {
                eventString = "Assembly Split"
            }
        } else if event.summary.contains("Homecoming Assembly") || event.summary.contains("Homecoming Kickoff Assembly") {
            if isNextEvent {
                nextEventString = "Assembly Bell"
            } else {
                eventString = "Assembly Bell"
            }
        } else if event.summary.contains("A-Day") || event.summary.contains("B-Day") {
            if isNextEvent {
                nextEventString = "Regular Day"
            } else {
                eventString = "Regular Day"
            }
        } else {
            nextEventString = "No School"
            eventString = "No School"
        }
    }
    
    
    private func determineSchedule(for event: String) -> BellSchedule {
        switch event {
        case "Summer School":
            return .summerSchool
        case "Late Start":
            return .lateStart
        case "Early Dismissal":
            return .earlyDismissal
        case "Assembly Bell":
            return .assemblyBell
        case "Assembly Split":
            return .assemblySplit
        case "Regular Day":
            return .regular // Assuming A-Day and B-Day use the regular schedule
        default:
            return .noSchool
        }
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
      
    private func scheduleNotification(for date: Date, withTitle title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Create a date components from the date
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}


