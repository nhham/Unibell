//
//  AnnouncementsView.swift
//  Unibell
//
//  Created by hyunsuh ham on 8/3/24.
//

import SwiftUI
import WebKit
import Firebase

struct AnnouncementsView: View {
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
    @State private var webViewHeight: CGFloat = .zero
   
    var body: some View {
        GeometryReader { bound in

            ScrollView(.vertical) {
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            Text("Quick Links")
                                .bold()
                                .padding(.leading)
                            Text("(not affiliated)")
                                .font(.system(size: xSmallFontSize))
                            Text(":")
                            Link(destination: URL(string: "https://app.schoology.com/login?destination=home" )!,
                                 label: {
                                Text("🍎 Schoology")
                                    .foregroundStyle(.white)
                                    .padding(xSmallPaddingSize)
                                    .fillView(.gray.opacity(0.25))
                                    .clipShape(.rect(cornerRadius: 20))
                            })
                            .padding()
                            Link(destination: URL(string: "https://www.infinitecampus.com/audience/parents-students/login-search" )!,
                                 label: {
                                Text("📋 Infinite Campus")
                                    .foregroundStyle(.white)
                                    .padding(xSmallPaddingSize)
                                    .fillView(.gray.opacity(0.25))
                                    .clipShape(.rect(cornerRadius: 20))
                            })
                            
                        }
                    }
                    StudentMessagingCenterView()
                    
                    AllTasksCenterView()
                    
                    if !embedModel.embedLink.isEmpty {
                        WebView(url: URL(string: embedModel.embedLink)!)
                            .frame(height: UIScreen.main.bounds.height / 2)
                            .clipShape(.rect(cornerRadius: 20))
                            .allowsHitTesting(true)
                    } else {
                        Text("Find school announcements here.")
                            .font(.system(size: xLargeFontSize).bold())
                            .frame(height: UIScreen.main.bounds.height / 2)
                            .clipShape(.rect(cornerRadius: 20))
                            .foregroundStyle(.white)
                            .fillView(.black.opacity(0.3))
                    }
                    
                }
                .onAppear {
                    embedModel.findUserSchool(userUID: loginModel.userUID)
                }
            }
            
        }
    }
}
