//
//  MainTeacherView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/27/24.
//

import SwiftUI
import WebKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

struct MainTeacherView: View {
    @Environment(\.xLargePaddingSize) var xLargePaddingSize
    @Environment(\.largePaddingSize) var largePaddingSize
    @Environment(\.mediumPaddingSize) var mediumPaddingSize
    @Environment(\.smallPaddingSize) var smallPaddingSize
    @Environment(\.xSmallPaddingSize) var xSmallPaddingSize
    @Environment(\.xLargeFontSize) var xLargeFontSize
    @Environment(\.largeFontSize) var largeFontSize
    @Environment(\.mediumFontSize) var mediumFontSize
    @Environment(\.smallFontSize) var smallFontSize
    @Environment(\.xSmallFontSize) var xSmallFontSize
    @StateObject var calendarModel = CalendarViewModel()
    @StateObject var loginModel = LoginViewViewModel()
    @StateObject var embedModel = GoogleSlidesEmbedModel()
    @State private var selectedIndex = 0
    @State private var isPortrait: Bool = true
    private let pageCount = 2

    var body: some View {
        GeometryReader { bound in
          

                VStack(spacing: 0) {
                    if calendarModel.events.isEmpty {
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
                        .frame(width: bound.size.width / 3, height: bound.size.height / 4)
                        .multilineTextAlignment(.center)
                    } else {
                       VStack(spacing: 0) {
                            if isPortrait {
                                // Portrait Mode with Pagination
                                VStack {
                                    SchoolTimeView()
                                        .modifier(FontSizeModifier())
                                        .modifier(PaddingSizeModifier())
                                        .hAlign(.center)
                                    
                            
                                    TabView {
                                        TeacherAnnouncementView()
                                        .tag(0)
                                        
                                        CurrentScheduleView()
                                        .tag(1)
                                    }
                                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                    
                                    Divider()
                                        .padding(.bottom)
                                    
                                    Text("\(calendarModel.schoolName)")
                                        .font(.system(size: xSmallFontSize))
                                        .hAlign(.center)
                                        .foregroundStyle(.gray)
                                        .padding(mediumPaddingSize)
                                }
                                
                            } else {
                                // Landscape Mode with Both Views on One Page
                                VStack(spacing: 0) {
                                    SchoolTimeView()
                                        .modifier(FontSizeModifier())
                                        .modifier(PaddingSizeModifier())
                                        .hAlign(.center)
                                
                                    HStack(spacing: 0) {
                                        TeacherAnnouncementView()
                
                                        
                                        CurrentScheduleView()
                                    
                                        
                                    }
                                    .padding()
                                    Text("\(calendarModel.schoolName)")
                                        .font(.system(size: xSmallFontSize))
                                        .hAlign(.center)
                                        .foregroundStyle(.gray)
                                        .padding(mediumPaddingSize)
                                }
                                
                            }
                        }
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

    private func width(for size: CGSize) -> CGFloat {
        size.width > size.height ? size.width / 1.8 : size.width * 0.9
    }
}
#Preview {
    MainStudentView()
}


