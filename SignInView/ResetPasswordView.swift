//
//  ResetPasswordView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/26/24.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage


struct resetKeycodeView: View {
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
    
    // MARK: User Details
    @Environment(\.dismiss) var dismiss
    @State var emailID: String = ""
    @State var resetKeycode: Bool = false
    @State private var sentLink: Bool = false
    @State var isLoading: Bool = false
    
    var body: some View {
        
        
        VStack(spacing: 10){
            Text("Forgot Password?")
                .font(.system(size: mediumFontSize, design: .serif))
            
            VStack(spacing: 10){
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .autocapitalization(.none)
                    .padding(CGFloat(10))
                    .clipShape(.rect(cornerRadius: 10))
                    .frame(width: 300)
                    .font(.custom("Koldby", size: smallFontSize))
                
                Button(action: resetPassword){
                    
                    Text("send reset")
                    
                }
                .foregroundColor(.black)
                .fontWeight(.bold)
                .fillView(Color(hex: "A0BAFA"))
                .frame(width: 150, height: 50)
                .font(.custom("Koldby", size: smallFontSize))
                .alert("Link Sent!", isPresented: $sentLink) {
                    Button("Ok", role: .cancel) {}
                }
                
            }
        }
        
        HStack(spacing: 4) {
            Text("remember it?")
                .foregroundColor(.gray)
                .font(.custom("Koldby", size: smallFontSize))
            Button("login now"){
                dismiss()
            }
            .font(.custom("Koldby", size: smallFontSize))
            .foregroundColor(.black)
            
        }
        .vAlign(.bottom)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        
    }
    
    func resetPassword() {
        isLoading = true
        closeKeyboard()
        
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                // Ensure UI updates happen on main thread
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.sentLink = true
                }
            } catch {
                await setError(error)
            }
        }
    }
    
    // MARK: Displaying Errors VIA Alert
    func setError(_ error: Error) async {
        // Ensure UI updates happen on main thread
        await MainActor.run {
            isLoading = false
        }
    }
}
