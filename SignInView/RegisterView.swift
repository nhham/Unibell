//
//  RegisterView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/26/24.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

// MARK: Register View
struct RegisterView: View {
    // MARK: Font Size Layout
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
    
    
    // MARK: View Properties
    @Environment(\.dismiss) var dismiss
    @State var isLoginView: Bool = false
    @StateObject var registerModel = RegisterViewViewModel()
    
    // MARK: UserDefaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        
        VStack(spacing: 10) {
            Text("Welcome!")
                .foregroundColor(.black)
                .font(.custom("Koldby", size: largeFontSize))
                .hAlign(.leadingFirstTextBaseline)
                .vAlign(.topLeading)
                .fontWeight(.light)
                .padding(30)
                .fontWeight(.semibold)
        }
        VStack(spacing: 10.0) {
            Text("Create Unibell Account:")
                .font(.custom("Koldby", size: mediumFontSize))
                .fontWeight(.light)
                .padding(30)
            
            VStack(spacing: 10) {
                TextField("First & Last Name", text: $registerModel.userName)
                    .textContentType(.name)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top, 25)
                    .autocapitalization(.none)
                    .frame(width: 300)
                    .font(.custom("Koldby", size: smallFontSize))
                
                TextField("Email", text: $registerModel.emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .autocapitalization(.none)
                    .frame(width: 300)
                    .font(.custom("Koldby", size: smallFontSize))
                
                SecureField("Password (At least 6 Characters, or  School ID number)", text: $registerModel.password)
                    .textContentType(.password)
                    .border(1, .gray.opacity(0.5))
                    .autocapitalization(.none)
                    .frame(width: 300)
                    .font(.custom("Koldby", size: smallFontSize))
                
                Button(action: registerModel.register) {
                    // MARK: signup Button
                    Text("sign up")
                }
                .foregroundColor(.black)
                .hAlign(.center)
                .vAlign(.center)
                .fontWeight(.bold)
                .fillView(Color(hex: "2A48AE"))
                .frame(width: 150, height: 50)
                .font(.custom("Koldby", size: smallFontSize))
                .disableWithOpacity(registerModel.userName == "" || registerModel.emailID == "" || registerModel.password == "")
                .padding()
            }
        }
        
        // MARK: Login Button
        HStack {
            Text("already have an account?")
                .foregroundColor(.gray)
                .font(.custom("Koldby", size: smallFontSize))
            
            Button("login now") {
                withAnimation(.default) {
                    dismiss()
                }
            }
            .fontWeight(.bold)
            .foregroundColor(.black)
            .font(.custom("Koldby", size: smallFontSize))
        }
        
        .vAlign(.bottom)
        
        // MARK: Displaying Alert
        .alert(isPresented: $registerModel.showError) {
            Alert(title: Text("Unable to register (You might already have an account)"),
                  message: Text(registerModel.messageError))
        }
        
        .padding(15)
        .overlay(content: {
            LoadingView(show: $registerModel.isLoading)
        })
    }
    
}
