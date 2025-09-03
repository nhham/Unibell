//
//  MessageView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/25/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


struct MessageView: View {
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
    @StateObject private var viewModel = LoginViewViewModel()
    @State private var showImagePicker = false
    let message: Message

    var body: some View {
        
        let size = UIScreen.main.bounds.height * 0.08
        VStack {
            Text(message.senderName)
                .font(.system(size: smallFontSize))
                .fontWeight(.semibold)
                .hAlign(.bottomLeading)
                .padding(.horizontal, smallPaddingSize)
                .foregroundStyle(.black)
            
            HStack(alignment: .top, spacing: 3) {
                if let urlString = message.profilePictureURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                              
                                .frame(width: size, height: size)
                                .padding(.horizontal, smallPaddingSize)
                                .foregroundStyle(.black)
                            
                            
                        case .success(let image):
                            image
                           
                                .resizable()
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size, height: size)
                             
                        case .failure(_):
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: size, height: size)
                                .padding(.horizontal, xSmallPaddingSize)
                                .foregroundStyle(.black)
                            
                            
                        @unknown default:
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: size, height: size)
                                .padding(.horizontal, xSmallPaddingSize)
                                .foregroundStyle(.black)
                            
                            
                        }
                    }
                    .padding(.horizontal)
                    
                } else {
                    Image(systemName: "person.circle")
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fill)
                        .padding(.horizontal, xSmallPaddingSize)
                        .foregroundStyle(.black)
                }
                
                
                VStack(alignment: .leading) {
                    Text(message.message)
                        .padding()
                        .font(.system(size: smallFontSize))
                        .background(.white.shadow(.drop(color: .black.opacity(0.3), radius: 3)), in: .rect(cornerRadius: 10))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.black)
                    
                    
                    HStack(alignment: .bottom) {
                        Text("Sent at: \(message.timestamp.dateValue(), formatter: DateFormatter.shortTime)")
                            .font(.system(size: xSmallFontSize))
                            .hAlign(.leading)
                            .padding()
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(.rect(cornerRadius: 10))
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMessages =
            Message(id: "", senderUID: "", senderName: "Mr. Bird", message: "Good Morning \n\n Class Welcome To First Day of School! This Will be a great day and Go Hawks!", timestamp: Timestamp(date: Date()))
        
        MessageView(message: sampleMessages)
    }
}
            
