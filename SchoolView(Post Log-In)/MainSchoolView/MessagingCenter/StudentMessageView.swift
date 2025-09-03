//
//  StudentMessageView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/25/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift
import Foundation

struct StudentMessageView: View {
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
    @StateObject var messageModel = MessagingCenterViewModel()
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        VStack {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .padding()
            .hSpacing(.leading)
            
            ScrollView {
                ForEach(messageModel.messages) { message in
                    MessageView(message: message)
                        .modifier(FontSizeModifier())
                        .modifier(PaddingSizeModifier())
                        .padding()
                }
            }
            .onAppear {
                messageModel.fetchSchoolID()
            }
            if messageModel.messages.isEmpty {
                Text("No messages found")
            }
        }
        .onAppear {
            messageModel.fetchSchoolID()
        }
    }
        
}

#Preview {
    StudentMessageView()
}
