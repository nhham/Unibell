//
//  ContentView.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/28/24.
//


import SwiftUI

struct ContentView: View {
    @AppStorage("studentView_status") var studentViewStatus: Bool = false
    @AppStorage("teacherView_status") var teacherViewStatus: Bool = false
    @AppStorage("log_status") var logStatus: Bool = false
    @StateObject var accessModel = CalendarViewModel()
    @StateObject var loginModel = LoginViewViewModel()
    var body: some View {
        // MARK: Redirecting User Based on Log Status
        if loginModel.logStatus || logStatus {
            PostLoginView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
        } else{
            LoginView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
