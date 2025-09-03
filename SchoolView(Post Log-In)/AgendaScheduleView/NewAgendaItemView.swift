//
//  NewAgendaItemView.swift
//  Unibell
//
//  Created by hyunsuh ham on 5/28/24.
//

import FirebaseFirestoreSwift
import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import FirebaseStorage


struct NewAgendaItemView: View {
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
    @StateObject var newItemModel = NewItemViewModel()
    @StateObject var agendaModel = AgendaScheduleViewModel()
    @Environment(\.dismiss) private var dismiss
    @Binding var newItemPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .padding(.top)
            .hSpacing(.leading)
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Task Title")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("Complete 3 MathXL Assignments!", text: $newItemModel.title)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(Color.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: RoundedRectangle(cornerRadius: 10))
            })
            .padding(.top)
            
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Task Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    DatePicker("", selection: $newItemModel.dueDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                        .labelsHidden()
                })
                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Task Color")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    ColorPicker("", selection: $newItemModel.Color)
                        .background(Color.white.shadow(.drop(color: .black.opacity(0.25), radius: 10)), in: RoundedRectangle(cornerRadius: 20))
                        .labelsHidden()
                })
            }
            Spacer(minLength: 0)
            Button(action: {
                if newItemModel.canSave {
                    newItemModel.save()
                    dismiss()
                } else {
                    newItemModel.showAlert = true
                }
            }, label: {
                Text("Save New Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.black)
                    .hSpacing(.center)
                    .padding(.vertical)
                    .background(Color.blue.opacity(0.25), in: RoundedRectangle(cornerRadius: 10))
            })
        })
        .padding()
        .alert(isPresented: $newItemModel.showAlert) {
            Alert(title: Text("Error"), message: Text("Please fill out all fields correctly."), dismissButton: .default(Text("OK")))
        }
    }
}



struct NewAgendaItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewAgendaItemView(newItemPresented: .constant(true))
    }
}

