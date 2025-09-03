//
//  LaunchScreenView.swift
//  Unibell
//
//  Created by hyunsuh ham on 8/7/24.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        VStack {
            Image("IMG_1551 2")
                .resizable()
                .frame(width: 150, height: 150)
                .scaledToFit()
            Text("Unibell.")
                .font(.custom("Koldby", size: 26))

        }
    }
}

#Preview {
    LaunchScreenView()
}
