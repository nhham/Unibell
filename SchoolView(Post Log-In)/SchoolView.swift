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


struct schoolCode: View {
    @State private var schoolviewAccess = false
    
    
    
    var body: some View{
        Text("welcome")
    }
}

struct studentView: View {
    @StateObject var loginModel = LoginViewViewModel()
    
    
    var body: some View {
        TabView{
            MainSchoolView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Feed")
                }
            AgendaScheduleView()
                .tabItem{
                    Image(systemName: "pencil.and.list.clipboard")
                    Text("To-Do")
                }
            AccountView()
                .tabItem{
                    Image(systemName: "person")
                    Text("Account")
                }
 
        }
    }
}

#Preview {
    ContentView()
}
