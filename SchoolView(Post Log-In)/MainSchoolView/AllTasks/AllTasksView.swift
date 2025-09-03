//
//  AllTasksView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/23/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

struct AllTasksView: View {
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
    @StateObject var listModel = AgendaScheduleViewModel()
    @StateObject var loginModel = LoginViewViewModel()
    @Environment(\.dismiss) var dismiss
    
    @FirestoreQuery var items: [agendaItem]
    
    init(userUID: String) {
        self._items = FirestoreQuery(collectionPath: "Users/\(userUID)/agendaItems", predicates: [.orderBy("dueDate", false)])
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
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
                VStack(alignment: .leading, spacing: 30) {
                    ForEach(items) { item in
                        
                        AgendaTasksRowView(scheduleModel: AgendaScheduleViewViewModel(userUID: loginModel.userUID), item: item)
                            .padding(mediumPaddingSize)
                            .modifier(FontSizeModifier())
                            .modifier(PaddingSizeModifier())
                            
                    }
                }
                .overlay {
                    if items.isEmpty {
                        Text("No Tasks Found")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .frame(width: 150)
                    }
                }
            }
        })
    }
}
