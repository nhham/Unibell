//
//  PostLoginView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/26/24.
//

import SwiftUI

struct PostLoginView: View {
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
        if accessModel.studentViewStatus || studentViewStatus {
            StudentView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
        } else if accessModel.teacherViewStatus || teacherViewStatus {
            TeacherView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
        }  else {
            SchoolAccessCodeView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
        }
    }
}

#Preview {
    PostLoginView()
}
