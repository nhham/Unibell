//
//  TeacherMessageView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/25/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift

struct TeacherMessageView: View {
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
    @StateObject private var heightCalculator = TextEditorHeightCalculator()
    @StateObject var messageModel = MessagingCenterViewModel()
    @State private var messageText: String = ""
    @State private var isSending: Bool = false
    @State var showMessages = false
    @Namespace var namespace
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
                VStack {
                    ForEach(messageModel.messages) { message in
                        MessageView(message: message)
                            .contentShape(.contextMenuPreview, .rect(cornerRadius: 13))
                            .contextMenu {
                                Button("Delete Message", systemImage: "trash", role: .destructive){
                                    messageModel.deleteMessage(schoolID: messageModel.schoolID, messageID: message.id ?? "")
                                }
                            }
                            .modifier(FontSizeModifier())
                            .modifier(PaddingSizeModifier())
                            .padding(xSmallPaddingSize)
                    }
                }
            }
            .onAppear {
                print("Messages in view: \(messageModel.messages.count)") // Debugging
            }
            if messageModel.messages.isEmpty {
                Text("No messages found")
                    .padding()
            }
            
            
            HStack {
                TextEditor(text: $messageText)
                    .padding(xSmallPaddingSize)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(radius: 1)
                    .font(.system(size: 20))
                    .frame(height: heightCalculator.height)
                    .fixedSize(horizontal: false, vertical: true)
                    .overlay (
                        Text(messageText.isEmpty ? "Enter your message..." : "")
                            .padding()
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    )
                    .onChange(of: messageText) { _, newValue in
                        let textView = UITextView()
                        textView.font = UIFont.systemFont(ofSize: 24)
                        textView.text = newValue
                        heightCalculator.height = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: .infinity)).height + 20
                    }
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color(hex: "A0BAFA"))
                        .clipShape(.rect(cornerRadius: 10))
                        .frame(height: heightCalculator.height)
                        .scaledToFit()
                        .opacity(messageText.isEmpty ? 0.3 : 0.8)
                    
                }
                .disabled(messageText.isEmpty || isSending)
                
            }
            .padding()
        }
        .onAppear {
            messageModel.fetchSchoolID()
        }
    }
    
  
    private func sendMessage() {
        guard !messageText.isEmpty else {
            isSending = true
            return
        }
        
         guard let user = Auth.auth().currentUser else { return }
         let senderUID = user.uid
         let schoolID = messageModel.schoolID
         
         guard !schoolID.isEmpty else {
             print("School ID is empty")
             return
         }
         
         messageModel.sendMessage(
             schoolID: schoolID,
             senderUID: senderUID,
             message: messageText
         )
         
         messageText = ""
     }
}

class TextEditorHeightCalculator: ObservableObject {
    @Published var height: CGFloat = 50
}
