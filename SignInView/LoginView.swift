//
//  LoginView.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/28/24.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    // MARK: View Properties
    @Environment(\.dismiss) var dismiss
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var showMessageError: Bool = false
    @State var messageError: String = ""
    @State var isLoading: Bool = false
    // MARK: Other
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
    
    @StateObject var loginModel = LoginViewViewModel()
    
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 10.0){
                Text("Unibell.")
                    .foregroundColor(.black)
                    .font(.custom("Koldby", size: largeFontSize))
                    .hAlign(.leadingFirstTextBaseline)
                    .vAlign(.topLeading)
                    .fontWeight(.light)
                    .padding(30)
                    .fontWeight(.semibold)
            }
            VStack(spacing: 10.0){
                Text("Sign In")
                    .font(.custom("Koldby", size: mediumFontSize))
                    .hAlign(.center)
                    .vAlign(.centerFirstTextBaseline)
                    .fontWeight(.light)
                    .padding(30)
                
                
                VStack(spacing: 10){
                    
                    
                    TextField("Email", text: $loginModel.emailID)
                        .textContentType(.emailAddress)
                        .border(1, .gray.opacity(0.5))
                        .padding(.top,25)
                        .autocapitalization(.none)
                        .frame(width: 300)
                        .font(.custom("Koldby", size: smallFontSize))
                    
                    SecureField("Password", text: $loginModel.password)
                        .textContentType(.password)
                        .border(1, .gray.opacity(0.5))
                        .autocapitalization(.none)
                        .frame(width: 300)
                        .font(.custom("Koldby", size: smallFontSize))
                    
                    if loginModel.showMessageError {
                        Text(loginModel.messageError)
                            .foregroundStyle(Color.red)
                            .font(.custom("Koldby", size: smallFontSize))
                            .padding(10)
                    }
                    
                    Button(action: loginModel.login){
                        // MARK: Login Button
                        Text("log in")
                        
                    }
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .hAlign(.center)
                    .fillView(Color(hex: "B0D8EE"))
                    .font(.custom("Koldby", size: smallFontSize))
                    .frame(width: 150, height: 50)
                    .padding()
                }
                
                
                // MARK: Reset Password Button
                HStack{
                    Button("forgot your password?"){
                        loginModel.resetKeycode.toggle()
                    }
                    .padding()
                    .font(.custom("Koldby", size: smallFontSize))
                    .tint(.black)
                    .hAlign(.trailing)
                }
                // MARK: Register Button
                HStack{
                    Text("don't have an account?")
                        .foregroundColor(.gray)
                        .font(.custom("Koldby", size: smallFontSize))
                    
                    Button("register now"){
                        loginModel.createAccount.toggle()
                        
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .font(.custom("Koldby", size: smallFontSize))
                }
                .vAlign(.bottom)
            }
            .padding(15)
            .overlay(content: {
                LoadingView(show: $loginModel.isLoading)
            })
        }
        // MARK: Register View VIA Sheets
        .fullScreenCover(isPresented: $loginModel.createAccount) {
            RegisterView()
        }
        .fullScreenCover(isPresented: $loginModel.resetKeycode) {
            resetKeycodeView()
        }
    }
    
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
