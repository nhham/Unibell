//
//  CurrentScheduleView.swift
//  Unibell
//
//  Created by hyunsuh ham on 8/1/24.
//

import SwiftUI

struct CurrentScheduleView: View {
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
    @StateObject private var timer =
    CountdownTimer(currentSchedule: .regular)
    @State private var scheduleColors: [Date: Color] = [:]
    var body: some View {
        GeometryReader { bound in
            
            VStack(alignment: .leading) {
                Text("📆 Schedule")
                    .font(.title3)
                    .fontWeight(.bold)
                    .hAlign(.leading)
                
                    .clipShape(.rect)
                    .fillView(Color(hex: "B0D8EE").opacity(0.2))
                    .padding()
            
                ScrollView(.vertical) {
                    ForEach(timer.schoolTimes, id: \.self) { time in
                        HStack {
                            Divider()
                            Divider()
                            if let block = timer.timesInSchedule[time] {
                                Text(block.rawValue)
                                   
                                    .font(.body.bold())
                                    .clipShape(.rect)
                                    .fillView(scheduleColors[time]?.opacity(0.4) ?? Color.clear)
                                    
                                
                                
                            }
                            Divider()
                            Divider()
                            Spacer()
                            Divider()
                            Divider()
                            Text(time, style: .time)
                                
                                .fontWeight(.semibold)
                                .font(.body)
                                .fillView((scheduleColors[time]?.opacity(0.6) ?? Color.clear))
                                .clipShape(.rect(cornerRadius: 40))
                   
                            
                            
                            Divider()
                            Divider()
                            
                        }
                        
                    }
                    
                }
                
                .onAppear {
                    randomBlue()
                }
            }
        }
    }
    
    func randomBlue() {
        let colors = ["A0BAFA","2A48AE","B0D8EE"]
        scheduleColors = [:]
        for time in timer.schoolTimes {
            let color = colors.randomElement()!
            scheduleColors[time] = Color(hex: color)
        }
    }
}
#Preview {
    CurrentScheduleView()
}
