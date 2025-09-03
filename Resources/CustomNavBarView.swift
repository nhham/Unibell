//
//  CustomNavBarView.swift
//  Unibell
//
//  Created by hyunsuh ham on 8/3/24.
//

import SwiftUI

struct CustomNavBarItem: View {
    let image: Image
    let action: ()-> Void
    var body: some View {
        Button(action: action, label: {
            image
                .frame(maxWidth: .infinity)
        })
    }
}
