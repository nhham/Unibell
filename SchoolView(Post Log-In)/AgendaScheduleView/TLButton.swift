//
//  TLButton.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/28/24.
//

import SwiftUI

struct TLButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                    
                Text(title)
                    .foregroundColor(.black)
                    .bold()
            }
        }
    }
}

struct TLButton_Previews: PreviewProvider{
    static var previews: some View{
        TLButton(title: "Value", background: .lavender) {
            
        }
    }
}
