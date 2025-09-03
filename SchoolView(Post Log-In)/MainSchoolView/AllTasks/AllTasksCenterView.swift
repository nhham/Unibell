//
//  AllTasksCenterView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/27/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

struct AllTasksCenterView: View {
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
    @StateObject var listModel = AgendaScheduleViewModel()
    @StateObject var loginModel = LoginViewViewModel()
    @Environment(\.dismiss) var dismiss
    @State var showTasks = false
  
    var body: some View {
        
        VStack {
            VStack (alignment: .center, spacing: 12) {
                Text("📚 Tasks")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Find all recent and past tasks made here.")
                    .font(.body.weight(.semibold))
                    .multilineTextAlignment(.center)
            }
            .hAlign(.center)
            .padding()
            .fillView(Color(hex: "B0D8EE").opacity(0.4))
            .clipShape(.rect(cornerRadius: 20))
            
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showTasks.toggle()
            }
        }
        .sheet(isPresented: $showTasks, content: {
            AllTasksView(userUID: loginModel.userUID)
                .presentationCornerRadius(30)
        })
        
    }
}


