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
    @StateObject var newItemModel = newItemViewModel()
    @StateObject var agendaModel = AgendaScheduleViewModel()
    @State private var createNewItem: Bool = false
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
            .hSpacing(.leading)
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Task Title")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("Complete 3 MathXL Assignments!", text: $newItemModel.title)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            })
            .padding(.top, 5)
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Task Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    DatePicker("", selection: $newItemModel.dueDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                })
                .padding(.trailing, -15)
                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Task Color")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    ColorPicker("", selection: $newItemModel.Color, supportsOpacity: false)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 3)
                        .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 10)), in: .rect(cornerRadius: 10))
                        .font(.system(size: 15))
                        .hSpacing(.trailing)
                })
              
            }
            .padding(.top, 5)
            Spacer(minLength: 0)
            Button(action: {
                if newItemModel.canSave {
                    newItemModel.save()
                    dismiss()
                }else {
                    newItemModel.showAlert = true
                }
            }, label: {
                Text("Save New Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.black)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(.blue.opacity(0.25), in: .rect(cornerRadius: 10))
                
            })
            
        })
        .padding(15)
    }

}



struct NewAgendaItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewAgendaItemView(newItemPresented: Binding(get: {
            return true
        }, set: { _ in
        }))
    }
}
