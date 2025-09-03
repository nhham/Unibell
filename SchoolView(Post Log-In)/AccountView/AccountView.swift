//
//  AccountView.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/28/24.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @StateObject var accountModel = AccountViewModel()
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        NavigationView {
            VStack{
                if let user = accountModel.user {
                    profile(user: user)
                } else {
                    Text("Loading Profile...")
                }
                    
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            accountModel.fetchUser()
        }
    }
    
    @ViewBuilder
    func profile(user: User) -> some View {
        // Avatar
        
        Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.gray)
            .frame(width: 125,  height: 125)
            .padding()
            
        // Info: Name, Email
        
        VStack(alignment: .leading) {
            HStack {
                Text("Name: ")
                    .bold()
                Text(user.username)
            }
            HStack {
                Text("Email: ")
                    .bold()
                Text(user.userEmail)
            }
            
        }
        .padding()
        //Sign out
        
        Button("Log Out") {
            logOut()
        }
        .tint(.red)
        .padding()
        Spacer()
    }
    private func logOut() {
        do {
            try Auth.auth().signOut()
            logStatus = false
        } catch {
            print(error)
        }
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View{
        AccountView()
    }
}


