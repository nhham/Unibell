//
//  AdaptiveLayout.swift
//  Unibell
//
//  Created by hyunsuh ham on 6/27/24.
//

import Foundation
import SwiftUI

  
struct XLargeFontKey: EnvironmentKey {
    static let defaultValue: CGFloat = 70
}
struct LargeFontKey: EnvironmentKey {
    static let defaultValue: CGFloat = 50
}
struct MediumFontKey: EnvironmentKey {
    static let defaultValue: CGFloat = 25
}
struct SmallFontKey: EnvironmentKey {
    static let defaultValue: CGFloat = 18
}
struct XSmallFontKey: EnvironmentKey {
    static let defaultValue: CGFloat = 9
}


extension EnvironmentValues {
    var xLargeFontSize: CGFloat {
        get { self[XLargeFontKey.self]}
        set { self[XLargeFontKey.self] = newValue}
    }
    
    var largeFontSize: CGFloat {
        get { self[LargeFontKey.self]}
        set { self[LargeFontKey.self] = newValue}
    }
    var mediumFontSize: CGFloat{
        get { self[MediumFontKey.self]}
        set { self[MediumFontKey.self] = newValue}
    }
    var smallFontSize: CGFloat{
        get { self[SmallFontKey.self]}
        set { self[SmallFontKey.self] = newValue}
    }
    var xSmallFontSize: CGFloat{
        get { self[XSmallFontKey.self]}
        set { self[XSmallFontKey.self] = newValue}
    }
}
struct FontSizeModifier: ViewModifier {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    func body(content: Content) -> some View {
         
        let xLargeFontSize: CGFloat
        let largeFontSize: CGFloat
        let mediumFontSize: CGFloat
        let smallFontSize: CGFloat
        let xSmallFontSize: CGFloat
        
        
        switch (horizontalSizeClass, verticalSizeClass, isLandscape) {
        case (.regular, .regular, true):
            
            xLargeFontSize = 60
            largeFontSize = 45
            mediumFontSize = 30
            smallFontSize = 22
            xSmallFontSize = 18
            
        case (.regular, .regular, false):
            
            xLargeFontSize = 60
            largeFontSize = 45
            mediumFontSize = 30
            smallFontSize = 22
            xSmallFontSize = 18
            
        case (.compact, .regular, false):
            
            xLargeFontSize = 55
            largeFontSize = 35
            mediumFontSize = 25
            smallFontSize = 18
            xSmallFontSize = 14
            
        case (.regular, .compact, true):
            
            xLargeFontSize = 55
            largeFontSize = 35
            mediumFontSize = 25
            smallFontSize = 18
            xSmallFontSize = 14
            
        case (.compact, .compact, true):
            xLargeFontSize = 50
            largeFontSize = 30
            mediumFontSize = 20
            smallFontSize = 18
            xSmallFontSize = 14
        default:
            xLargeFontSize = 50
            largeFontSize = 45
            mediumFontSize = 25
            smallFontSize = 18
            xSmallFontSize = 14
        }
        
        return content
            .environment(\.xLargeFontSize, xLargeFontSize)
            .environment(\.largeFontSize, largeFontSize)
            .environment(\.mediumFontSize, mediumFontSize)
            .environment(\.smallFontSize, smallFontSize)
            .environment(\.xSmallFontSize, xSmallFontSize)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                    if UIDevice.current.orientation.isLandscape {
                        isLandscape = true
                    } else if UIDevice.current.orientation.isPortrait {
                        isLandscape = false
                    }
                }
            }
        
        
        
    }
}
struct XLargePaddingKey: EnvironmentKey{
    static let defaultValue: CGFloat = 30
}

struct LargePaddingKey: EnvironmentKey {
    static let defaultValue: CGFloat = 20
}
struct MediumPaddingKey: EnvironmentKey {
    static let defaultValue: CGFloat = 15
}
struct SmallPaddingKey: EnvironmentKey {
    static let defaultValue: CGFloat = 10
}
struct XSmallPaddingKey: EnvironmentKey {
    static let defaultValue: CGFloat = 5
}
struct frameKey: EnvironmentKey {
    static let defaultValue: CGFloat = 100
}



extension EnvironmentValues {
    var xLargePaddingSize: CGFloat {
        get { self[XLargePaddingKey.self]}
        set { self[XLargePaddingKey.self] = newValue}
    }
    var largePaddingSize: CGFloat {
        get { self[LargePaddingKey.self]}
        set { self[LargePaddingKey.self] = newValue}
    }
    var mediumPaddingSize: CGFloat {
        get { self[MediumPaddingKey.self]}
        set { self[MediumPaddingKey.self] = newValue}
    }
    var smallPaddingSize: CGFloat {
        get { self[SmallPaddingKey.self]}
        set { self[SmallPaddingKey.self] = newValue}
    }
    var xSmallPaddingSize: CGFloat {
        get { self[XSmallPaddingKey.self]}
        set { self[XSmallPaddingKey.self] = newValue}
    }
    var frameSize: CGFloat {
        get { self[frameKey.self]}
        set { self[frameKey.self] = newValue}
    }
}

struct PaddingSizeModifier: ViewModifier {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    func body(content: Content) -> some View {
         
        let xLargePaddingSize: CGFloat
        let largePaddingSize: CGFloat
        let mediumPaddingSize: CGFloat
        let smallPaddingSize: CGFloat
        let xSmallPaddingSize: CGFloat
        let frameSize: CGFloat
        
        
        switch (horizontalSizeClass, verticalSizeClass, isLandscape) {
        case (.regular, .regular, true):
            
            xLargePaddingSize = 35
            largePaddingSize =  30
            mediumPaddingSize = 25
            smallPaddingSize = 20
            xSmallPaddingSize = 20
            frameSize = 250
            
        case (.regular, .regular, false):
            
            xLargePaddingSize = 35
            largePaddingSize = 30
            mediumPaddingSize = 25
            smallPaddingSize = 22
            xSmallPaddingSize = 20
            frameSize = 250
            
        case (.compact, .regular, false):
            
            xLargePaddingSize = 22
            largePaddingSize = 18
            mediumPaddingSize = 15
            smallPaddingSize = 12
            xSmallPaddingSize = 6
            frameSize = 100
            
            
        case (.regular, .compact, true):
            
            xLargePaddingSize = 22
            largePaddingSize = 18
            mediumPaddingSize = 15
            smallPaddingSize = 12
            xSmallPaddingSize = 6
            frameSize = 100
            
        case (.compact, .compact, true):
            
            xLargePaddingSize = 20
            largePaddingSize = 18
            mediumPaddingSize = 13
            smallPaddingSize = 10
            xSmallPaddingSize = 6
            frameSize = 100
            
        case (.compact, .compact, false):
            
            xLargePaddingSize = 20
            largePaddingSize = 18
            mediumPaddingSize = 13
            smallPaddingSize = 10
            xSmallPaddingSize = 6
            frameSize = 100
            
        default:
            
            xLargePaddingSize = 20
            largePaddingSize = 18
            mediumPaddingSize = 15
            smallPaddingSize = 10
            xSmallPaddingSize = 5
            frameSize = 100
        }
        
        return content
            .environment(\.xLargePaddingSize, xLargePaddingSize)
            .environment(\.largePaddingSize, largePaddingSize)
            .environment(\.mediumPaddingSize, mediumPaddingSize)
            .environment(\.smallPaddingSize, smallPaddingSize)
            .environment(\.xSmallPaddingSize, xSmallPaddingSize)
            .environment(\.frameSize, frameSize)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                    if UIDevice.current.orientation.isLandscape {
                        isLandscape = true
                    } else if UIDevice.current.orientation.isPortrait {
                        isLandscape = false
                    }
                }
            }
    }
}
class ReferenceModel: ObservableObject {
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
    @Environment(\.frameSize) var frameSize
    
    init() {}
}


// MARK: View Extensions For UI Building
extension View{
    // Closing All Active Keyboards
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // MARK: Disabling with Opacity
    func disableWithOpacity(_ condition: Bool)->some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func hAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment)->some View{
        self
            .frame(maxHeight: .infinity,alignment: alignment)
    }
    
    // MARK: Custom Border View With Padding
    func border(_ width: CGFloat,_ color: Color)->some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    // MARK: Custom Fill View With Padding
    func fillView(_ color: Color)->some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
}
struct UITextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UITextViewWrapper
        
        init(parent: UITextViewWrapper) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
