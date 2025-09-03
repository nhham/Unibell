//
//  TLButton.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/28/24.
//

import SwiftUI

import UIKit
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

import SwiftUI
import UIKit

struct AlwaysVisibleScrollView<Content: View>: UIViewRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.indicatorStyle = .black
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10) // Adjust for better visibility
        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: uiView.bounds.width, height: uiView.bounds.height)
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        if let oldView = uiView.subviews.first {
            oldView.removeFromSuperview()
        }

        uiView.addSubview(hostingController.view)
        uiView.contentSize = hostingController.view.intrinsicContentSize
    }
}
