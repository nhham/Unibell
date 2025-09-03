//
//  AgendaTasksRowView.swift
//  Unibell
//
//  Created by hyunsuh ham on 5/23/24.
//
import FirebaseFirestoreSwift
import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct AgendaTasksRowView: View {
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
    @StateObject var scheduleModel: AgendaScheduleViewViewModel
    let item: agendaItem
    var body: some View {
        GeometryReader { bound in
            HStack(alignment: .top, spacing: 15) {
                VStack(spacing: 0){
                    Button {
                        listModel.toggleIsDone(item: item)
                        print("pressed")
                    } label: {
                        Image(systemName: "circle")
                            .foregroundColor(indicatorColor)
                            .overlay {
                                Circle()
                                    .fill(indicatorColor)
                                    .padding(4)
                                    .background(.white.shadow(.drop(color: .black.opacity(0.3), radius: 3)), in: .circle)
                                    .vAlign(.top)
                                
                            }
                    }
                }
                VStack(alignment: .leading, spacing: 10, content: {
                    ScrollView(.horizontal) {
                        Text(item.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                    }
                    Label((Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened)), systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.black)
                    
                })
                
                .hSpacing(.leading)
                .padding(mediumPaddingSize)
                .frame(width: bound.size.width, height: UIScreen.main.bounds.height / 13)
                .background(Color(hex: item.color).opacity(0.40), in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
                .strikethrough(item.isDone, pattern: .solid, color: .black)
                .contentShape(.contextMenuPreview, .rect(cornerRadius: 13))
                .contextMenu {
                    
                    Button("Delete Task", systemImage: "trash", role: .destructive){
                        scheduleModel.delete(id: item.id)
                    }
                }
                .offset(y: -8)
            }
        }
        
    }
    var indicatorColor: Color {
        
        if item.isDone {
            return .green
        }
        let date = Date(timeIntervalSince1970: item.dueDate)
        return date.isSameHour ? .blue : (date.isPast ? .black : .red)
    }
  
}

#Preview {
    AgendaTasksRowView(scheduleModel: AgendaScheduleViewViewModel(userUID: "asdasd"), item: .init(id: "123", title: "Walk my dog", dueDate: Date().timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, color: "#000080", isDone: false))
}
