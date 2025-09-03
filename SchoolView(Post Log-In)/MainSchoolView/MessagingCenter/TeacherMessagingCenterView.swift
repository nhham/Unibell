//
//  TeacherMessagingCenterView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/27/24.
//

import SwiftUI

struct TeacherMessagingCenterView: View {
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
    @Environment(\.dismiss) var dismiss
 
    var body: some View {

        VStack {
            VStack (alignment: .center, spacing: 12) {
                Text("💬 Messages")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    
                Text("Read and send messages to students here.")
                    .font(.body.weight(.semibold))
                    .multilineTextAlignment(.center)
            }
            .hAlign(.center)
            .padding()
            .fillView(Color(hex: "2A48AE").opacity(0.25))
            .clipShape(.rect(cornerRadius: 20))
            
            
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showMessages.toggle()
            }
        }
        .sheet(isPresented: $showMessages, content: {
            TeacherMessageView()
                .modifier(FontSizeModifier())
                .modifier(PaddingSizeModifier())
                .presentationCornerRadius(30)
        })
    
    }

}

#Preview {
    TeacherMessagingCenterView()
}
