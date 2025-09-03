//
//  SchoolView.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/28/24.
//

import FirebaseFirestoreSwift
import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import FirebaseStorage


struct StudentView: View {
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
    @StateObject var loginModel = LoginViewViewModel()
    @StateObject private var accessModel = CalendarViewModel()
    @AppStorage("studentView_status") private var studentViewStatus: Bool = false
    @AppStorage("teacherView_status") private var teacherViewStatus: Bool = false
    
    var body: some View {
        
        TabView{
            MainStudentView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
                .overlay(
                    RoundedRectangle(cornerRadius: 44)
                        .stroke(Color(hex: "B0D8EE"), lineWidth: 2)
                        .padding(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(hex: "A0BAFA"), lineWidth: 2)
                                .padding(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(hex: "2A48AE"), lineWidth: 2)
                                        .padding(6)
                                )
                        )
                )

                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            AgendaScheduleView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
                .tabItem{
                    Image(systemName: "pencil.and.list.clipboard")
                    Text("To-Do")
                }
            AccountView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
                .tabItem{
                    Image(systemName: "person")
                    Text("Account")
                }
        }
    }
}

struct TeacherView: View {
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
    @StateObject var loginModel = LoginViewViewModel()
    @StateObject private var accessModel = CalendarViewModel()
    @AppStorage("studentView_status") private var studentViewStatus: Bool = false
    @AppStorage("teacherView_status") private var teacherViewStatus: Bool = false
    
    
    var body: some View {
        TabView{
            
            MainTeacherView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
                .overlay(
                    RoundedRectangle(cornerRadius: 44)
                        .stroke(Color(hex: "B0D8EE"), lineWidth: 2)
                        .padding(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(hex: "A0BAFA"), lineWidth: 2)
                                .padding(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(hex: "2A48AE"), lineWidth: 2)
                                        .padding(6)
                                )
                        )
                )

                .tabItem {
                    Image(systemName: "house")
                    Text("Feed")
                }
            AgendaScheduleView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
                .tabItem{
                    Image(systemName: "pencil.and.list.clipboard")
                    Text("To-Do")
                }
            AccountView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
                .tabItem{
                    Image(systemName: "person")
                    Text("Account")
                }
        }
    }
}

