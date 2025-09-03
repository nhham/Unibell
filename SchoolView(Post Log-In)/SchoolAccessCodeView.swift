//
//  SchoolAccessCodeView.swift
//  Unibell
//
//  Created by hyunsuh ham on 6/26/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SchoolAccessCodeView: View {
    
    @State var isLogout: Bool = false
    @State var fieldNumbers: Int = 6
    @State var enteredCode: [String]
    @State private var oldValue: String = ""
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("studentView_status") var studentViewStatus: Bool = false
    @AppStorage("teacherView_status") var teacherViewStatus: Bool = false
    @FocusState var focusedField: Int?
    @StateObject var accessModel = CalendarViewModel()
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

    
    init() {
        self.enteredCode = Array(repeating: "", count: 6)
    }
    
    
    var body: some View {
        GeometryReader { bound in
            VStack {
                
                Text("Unibell.")
                    .font(.custom("Koldby", size: largeFontSize))
                    .padding()
                
                HStack(spacing: smallPaddingSize) {
                    ForEach(0..<6, id: \.self) { index in
                        TextField("", text: $enteredCode[index].limit(1))
                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.height / 14)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(.rect(cornerRadius: 9))
                        .multilineTextAlignment(.center)
                        .textCase(.uppercase)
                        .focused($focusedField, equals: index)
                        .tag(index)
                        .onChange(of: enteredCode[index]) { _, newValue in
                            
                            if !newValue.isEmpty {
                                if index == fieldNumbers - 1 {
                                    
                                    hideKeyboard()
                                    let usedCode = enteredCode.joined()
                                    accessModel.checkCode(enteredCode: usedCode)
                                    
                                    
                                } else {
                                    focusedField = (focusedField ?? 0) + 1
                                }
                            } else {
                                focusedField = (focusedField ?? 0) - 1
                            }
                        }
                    }
                }
                .alert(isPresented: $isLogout) {
                    Alert(
                        title: Text("Log Out"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .default(Text("Yes")) {
                            // Action for "Yes" button
                            logOut()
                        },
                        secondaryButton: .cancel(Text("No"))
                    )
                }
                .vAlign(.center)
                .padding()
                if accessModel.showMessageError {
                    Text(accessModel.messageError)
                        .foregroundStyle(.red)
                        .font(.system(size: xSmallFontSize))
                }
                
             
                
                Text("Enter School Code")
                    .font(.custom("Koldby", size: mediumFontSize))
                    .padding()
                Button("Log Out") {
                    isLogout = true
                }
                .padding()
                .font(.custom("Koldby", size: xSmallFontSize))
                .tint(.red)
                Text("To join a school and access resources, the code (given by your school) must be used")
                    .font(.custom("Koldby", size: xSmallFontSize))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                
            }
            
            .hAlign(.center)
            
            .onAppear {
                focusedField = 0
            }
            .onReceive(accessModel.$showMessageError) { incorrect in
                if incorrect {
                    focusedField = 0
                    enteredCode = Array(repeating: "", count: 6)
                }
            }
        }
    }
    private func logOut() {
        do {
            try Auth.auth().signOut()
            withAnimation(.default) {
                logStatus = false
            }
            
        } catch {
            print(error)
        }
    }
}



#Preview {
    SchoolAccessCodeView()
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
extension Binding where Value == String {
    func limit(_ length: Int)-> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}
