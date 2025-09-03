//
//  SchoolTimesModel.swift
//  Unibell
//
//  Created by hyunsuh ham on 6/8/24.
//


import Foundation
import Combine
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import UserNotifications

enum Block: String {
    case block1 = "1st Block"
    case block2 = "2nd Block"
    case block3 = "3rd Block"
    case block4 = "4th Block"
    case aLunch = "3rd Block (A-Lunch)"
    case bLunch = "3rd Block (B-Lunch)"
    case cLunch = "3rd Block (C-Lunch)"
    case dLunch = "3rd Block (D-Lunch)"
    case passingPeriod = "Passing Period"
    case schoolsOut = "Dismissed"
    case summerTime = "Summer School"
    case summerBreak = "Summer Break"
    case assemblyTime = "Assembly!"
    case blueTeam = "Blue Assembly"
    case orangeTeam = "Orange Assembly"
    
    
}
enum BellSchedule {
    case regular
    case lateStart
    case earlyDismissal
    case assemblyBell
    case assemblySplit
    case summerSchool
    case noSchool
}

class CountdownTimer: ObservableObject {
    @Published var timeUntilNextEvent: String = "        "
    @Published var currentTimeInSchedule: Block = .schoolsOut

    var schoolTimes: [Date] = []
    var nextDaySchoolTimes: [Date] = []
    var timer: Timer?
    var schedule: BellSchedule
    var nextDaySchedule: BellSchedule
    var timesInSchedule: [Date: Block] = [:]
    var nextValidEventDate: Date?

    init(currentSchedule: BellSchedule) {
        self.schedule = currentSchedule
        self.nextDaySchedule = currentSchedule // Initialize nextDaySchedule to currentSchedule
        setupSchoolTimes()
        startTimer()
    }
    

    func setupSchoolTimes() {
        // Clear previous school times
        schoolTimes.removeAll()
        nextDaySchoolTimes.removeAll()
        timesInSchedule.removeAll()

        // DateFormatter for parsing time strings
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()

        // Define a list of event start times for different schedules
        let schedules: [BellSchedule: [(String, Block)]] = [
            .lateStart: [("08:50", .block1), ("10:03", .passingPeriod), ("10:08", .block2), ("11:21", .passingPeriod), ("11:26", .aLunch), ("11:56", .passingPeriod), ("12:01", .bLunch), ("12:26", .passingPeriod), ("12:31", .cLunch), ("12:56", .passingPeriod), ("13:01", .dLunch), ("13:26", .passingPeriod), ("13:31", .block4), ("14:45", .schoolsOut)],
            .earlyDismissal: [("07:30", .block1), ("08:30", .passingPeriod), ("08:35", .block2), ("09:35", .passingPeriod), ("09:45", .block3), ("10:45", .passingPeriod), ("10:50", .block4), ("11:50", .schoolsOut)],
            .assemblyBell: [("07:30", .block1), ("08:51", .passingPeriod), ("08:58", .block2), ("10:19", .passingPeriod), ("10:26", .aLunch), ("10:56", .passingPeriod), ("11:00", .passingPeriod), ("11:04", .bLunch), ("11:30", .passingPeriod), ("11:34", .cLunch), ("12:04", .passingPeriod), ("12:08", .dLunch), ("12:38", .passingPeriod), ("12:45", .block4), ("14:05", .passingPeriod), ("14:15", .assemblyTime), ("14:45", .schoolsOut)],
            .assemblySplit: [("07:30", .block1), ("08:50", .passingPeriod), ("08:55", .block2), ("08:57", .passingPeriod), ("09:05", .blueTeam), ("09:55", .passingPeriod), ("10:00", .orangeTeam), ("10:25", .block2), ("11:15", .orangeTeam), ("11:20", .aLunch), ("11:55", .passingPeriod), ("12:00", .bLunch), ("12:25", .passingPeriod), ("12:30", .cLunch), ("12:50", .passingPeriod), ("13:00", .dLunch), ("13:20", .passingPeriod), ("13:25", .block4), ("14:45", .schoolsOut)],
            .summerSchool: [("07:15", .summerTime), ("12:30", .summerBreak)],
            .regular: [("07:30", .block1), ("09:04", .passingPeriod), ("09:11", .block2), ("10:45", .passingPeriod), ("10:52", .aLunch), ("11:22", .passingPeriod), ("11:26", .passingPeriod), ("11:30", .bLunch), ("11:56", .passingPeriod), ("12:00", .cLunch), ("12:30", .passingPeriod), ("12:34", .dLunch), ("13:04", .passingPeriod), ("13:11", .block4), ("14:45", .schoolsOut)],
            .noSchool: []
        ]

        // Get the selected schedule times
        let selectedSchedule = schedules[schedule] ?? []
        let nextDaySelectedSchedule = schedules[nextDaySchedule] ?? []

        // Convert event start times to Date objects for today
        for (timeString, block) in selectedSchedule {
            if let timeDate = dateFormatter.date(from: timeString) {
                // Combine the time with today's date
                let calendar = Calendar.current
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
                let timeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)
                dateComponents.hour = timeComponents.hour
                dateComponents.minute = timeComponents.minute
                if let fullDate = calendar.date(from: dateComponents) {
                    schoolTimes.append(fullDate)
                    timesInSchedule[fullDate] = block
                }
            }
        }

            // Convert event start times to Date objects for next day
            if let chosenDate = nextValidEventDate {
                  for (timeString, block) in nextDaySelectedSchedule {
                      if let fullDate = combineDateAndTime(date: chosenDate, timeString: timeString) {
                          nextDaySchoolTimes.append(fullDate)
                          timesInSchedule[fullDate] = block
                      }
                  }
              }

        // Sort the arrays of times
        schoolTimes.sort()
        nextDaySchoolTimes.sort()
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTimeUntilNextEvent()
        }
    }

    private func updateTimeUntilNextEvent() {
        let now = Date()
        if let nextEvent = schoolTimes.first(where: { $0 > now }) ?? nextDaySchoolTimes.first(where: { $0 > now }) {
            let timeInterval = nextEvent.timeIntervalSince(now)
            let hours = Int(timeInterval) / 3600
            let minutes = Int(timeInterval) % 3600 / 60
            let seconds = Int(timeInterval) % 60

            DispatchQueue.main.async {
                self.timeUntilNextEvent = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                self.currentTimeInSchedule = self.getCurrentBlock(now: now)
            }
        } else {
            DispatchQueue.main.async {
                self.timeUntilNextEvent = "        "
                self.currentTimeInSchedule = .schoolsOut
            }
        }
    }
    private func getCurrentBlock(now: Date) -> Block {
        var previousBlock: Block = .schoolsOut
        
        for (currentTime, block) in timesInSchedule.sorted(by: { $0.key < $1.key }) {
            if now >= currentTime {
                previousBlock = block
            } else {
                break
            }
        }
        return previousBlock
    }
    func combineDateAndTime(date: Date, timeString: String) -> Date? {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "HH:mm"

           guard let timeDate = dateFormatter.date(from: timeString) else {
               return nil
           }

           let calendar = Calendar.current
           let timeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)
           var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
           dateComponents.hour = timeComponents.hour
           dateComponents.minute = timeComponents.minute

           return calendar.date(from: dateComponents)
       }
}



  
  


