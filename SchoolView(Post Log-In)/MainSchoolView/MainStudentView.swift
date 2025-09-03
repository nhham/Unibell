//
//  MainStudentView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/27/24.
//

import SwiftUI
import WebKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

struct MainStudentView: View {
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
    @StateObject var calendarModel = CalendarViewModel()
    @StateObject var loginModel = LoginViewViewModel()
    @StateObject var embedModel = GoogleSlidesEmbedModel()
    @State private var isPortrait: Bool = true
    
    var body: some View {
        GeometryReader { bound in
            
            VStack(spacing: 0) {
                if calendarModel.events.isEmpty {
                    LoadingView()
                } else {
                    MainContentView(isPortrait: $isPortrait, bound: bound)
                        .padding()
                }
            }
            .onAppear {
                isPortrait = bound.size.width < bound.size.height
                embedModel.findUserSchool(userUID: loginModel.userUID)
            }
            .onChange(of: bound.size) { _, newSize in
                isPortrait = newSize.width < newSize.height
            }
            
        }
    }
    
    private struct LoadingView: View {
        @Environment(\.xSmallPaddingSize) var xSmallPaddingSize
        @StateObject var calendarModel = CalendarViewModel()
        @Environment(\.xSmallFontSize) var xSmallFontSize
        
        var body: some View {
            VStack(spacing: 10) {
                ProgressView()
                    .progressViewStyle(DefaultProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding(.top, xSmallPaddingSize)

                Text(calendarModel.randomQuote)
                    .font(.custom("Koldby", size: xSmallFontSize))
                    .foregroundStyle(.gray)
                    .padding()
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
        }
    }
    
    private struct MainContentView: View {
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
        @Binding var isPortrait: Bool
        @StateObject var calendarModel = CalendarViewModel()
        let bound: GeometryProxy
        
        var body: some View {
            VStack {
                SchoolTimeView()
                    .modifier(FontSizeModifier())
                    .modifier(PaddingSizeModifier())
                    .hAlign(.center)
                if isPortrait {
                    TabView {
                        AnnouncementsView().tag(0)
                        CurrentScheduleView().tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                } else {
                    HStack(spacing: 0) {
                        AnnouncementsView()
                    
                        CurrentScheduleView()
                            
                    }
                }
                
                Divider()
                    .padding(.bottom)
                
                Text("\(calendarModel.schoolName)")
                    .font(.system(size: xSmallFontSize))
                    .hAlign(.center)
                    .foregroundStyle(.gray)
                    .padding()
            
            }
        }
    }
}

#Preview {
    MainStudentView()
}



