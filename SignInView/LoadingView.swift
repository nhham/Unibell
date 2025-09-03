//
//  LoadingView.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/28/24.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    var body: some View {
        ZStack{
            if show{
                ProgressView()
                    .padding(15)
                    .background(.white,in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                
            }
        }
        .vAlign(.center)
        .hAlign(.center)
        .animation(.easeInOut(duration: 0.25), value: show)
    }
}
