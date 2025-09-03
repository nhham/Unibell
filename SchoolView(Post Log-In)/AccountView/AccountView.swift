//
//  AccountView.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/28/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import PhotosUI
import Firebase
import FirebaseStorage

struct AccountView: View {
    @Environment(\.xLargePaddingSize) var xLargePaddingSize
    @Environment(\.largePaddingSize) var largePaddingSize
    @Environment(\.mediumPaddingSize) var mediumPaddingSize
    @Environment(\.smallPaddingSize) var smallPaddingSize
    @Environment(\.xSmallPaddingSize) var xSmallPaddingSize
    @Environment(\.xLargeFontSize) var xLargeFontSize
    @Environment(\.largeFontSize) var largeFontSize
    @Environment(\.mediumFontSize) var mediumFontSize
    @Environment(\.smallFontSize) var smallFontSize
    @Environment(\.xSmallFontSize) var xSmallFontSize
    @Environment(\.frameSize) var frameSize
    @StateObject var accountModel = AccountViewModel()
    @StateObject var loginModel = LoginViewViewModel()
    @StateObject var accessModel = CalendarViewModel()
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("studentView_status") var studentViewStatus: Bool = false
    @AppStorage("teacherView_status") var teacherViewStatus: Bool = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: UIImage?
    @State private var imagePickerPresented = false
    @State private var errorMessage: String?
    @State var isLogout: Bool = false
    @State var isLeaveSchool: Bool = false
    @State private var currentView: String = "Account"
    @State private var showAlert: Bool = false
    @State private var showingConfirmationAlert: Bool = false
    @State private var showingResultAlert: Bool = false
    
    var body: some View {
        VStack {
            if currentView == "Account" {
                accountContent
            } else if currentView == "Information" {
                InformationView(currentView: $currentView)
                    .modifier(FontSizeModifier())
                    .modifier(PaddingSizeModifier())
                    .transition(.slide)
            } else if currentView == "PrivacyPolicy" {
                PrivacyPolicyView(currentView: $currentView)
                    .modifier(FontSizeModifier())
                    .modifier(PaddingSizeModifier())
                    .transition(.slide)
            }
        }
        .animation(.default, value: currentView)
    }
    
    var accountContent: some View {
        VStack {
            HStack {
                Text("Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                Button("Log out") {
                    isLogout = true
                }
                .padding()
                .font(.system(size: smallFontSize))
                .tint(.red)
                .alert(isPresented: $isLogout) {
                    Alert(
                        title: Text("Log out"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .destructive(Text("Yes")) {
                            logOut()
                        },
                        secondaryButton: .cancel(Text("No"))
                    )
                }
                
            }
            
            if let user = accountModel.user {
                Form {
                    Section {
                        VStack {
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .clipShape(Circle())
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: frameSize, height: frameSize)
                                    .hAlign(.center)
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .clipShape(Circle())
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: frameSize, height: frameSize)
                                    .hAlign(.center)
                            }
                        }
                        .padding()
                        .onAppear {
                            fetchProfilePictureURL(for: user.userUID)
                        }
                        .onTapGesture {
                            imagePickerPresented = true
                        }
                        .sheet(isPresented: $imagePickerPresented) {
                            ImagePicker(selectedImage: $selectedImage, onImageSelected: { image in
                                uploadProfilePicture(image) { result in
                                    switch result {
                                    case .success(let urlString):
                                        updateProfilePictureURL(urlString, for: user.userUID) { error in
                                            if let error = error {
                                                print("Error updating profile picture URL: \(error.localizedDescription)")
                                            } else {
                                                self.profileImage = image
                                            }
                                        }
                                    case .failure(let error):
                                        errorMessage = error.localizedDescription
                                    }
                                }
                            })
                            
                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                    }
                    
                    Section(header: Text("Account info")) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(user.username)")
                                .fontWeight(.semibold)
                                .font(.system(size: smallFontSize))
                            Text("Email: \(user.userEmail)")
                                .foregroundStyle(.gray)
                                .font(.system(size: smallFontSize))
                        }
                        .padding()
                    }
                    
                    Section(header: Text("General")) {
                        Button(action: {
                            currentView = "Information"
                        }) {
                            HStack {
                                Image(systemName: "info.circle")
                                Text("About Unibell")
                                    .font(.system(size: smallFontSize))
                            }
                            
                        }
                        
                        Button(action: {
                            currentView = "PrivacyPolicy"
                        }) {
                            HStack {
                                Image(systemName: "lock")
                                Text("Privacy Policy")
                                    .font(.system(size: smallFontSize))
                            }
                        }
                    }
                    Section {
                        Button("Leave School") {
                            isLeaveSchool = true
                        }
                        .tint(.red)
                        .font(.system(size: smallFontSize))
                        .alert(isPresented: $isLeaveSchool) {
                            Alert(
                                title: Text("Leave School"),
                                message: Text("Are you sure you want to leave? (App reset required)"),
                                primaryButton: .destructive(Text("Yes")) {
                                    showAlert = true
                                    accessModel.removeCurrentUserFromSchool()
                                },
                                secondaryButton: .cancel(Text("No"))
                            )
                        }
                    }
                    
                    Section {
                        Button("Delete Account") {
                            showingConfirmationAlert = true
                        }
                        .tint(.red)
                        .font(.system(size: smallFontSize))
                        .alert(isPresented: $showingConfirmationAlert) {
                            Alert(
                                title: Text("Delete Account"),
                                message: Text("Are you sure you want to delete this account?"),
                                primaryButton: .destructive(Text("Yes")) {
                                    showAlert = true
                                    requestAccountDeletion(userUID: user.userUID)
                                },
                                secondaryButton: .cancel(Text("No"))
                            )
                        }
                    }
                }
                .clipShape(.rect(cornerRadius: 20))
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.white)
            }
        }
        .onAppear {
            accountModel.fetchUser()
        }
    }
    
    func fetchProfilePictureURL(for userUID: String) {
        let db = Firestore.firestore()
        db.collection("Users").document(userUID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching profile picture URL: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot, snapshot.exists, let data = snapshot.data() else {
                print("Document does not exist")
                return
            }
            if let urlString = data["profilePictureURL"] as? String, let url = URL(string: urlString) {
                downloadImage(from: url)
            }
        }
    }

    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.profileImage = image
                }
            }
        }.resume()
    }

    func uploadProfilePicture(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(.failure(NSError(domain: "ImageConversion", code: -1, userInfo: nil)))
            return
        }
        
        let fileName = UUID().uuidString + ".jpg"
        let storageRef = Storage.storage().reference().child("profile_pictures/\(fileName)")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url.absoluteString))
                    }
                }
            }
        }
    }
    private func requestAccountDeletion(userUID: String) {
        guard let currentUser = Auth.auth().currentUser else {
            self.errorMessage = "No user is currently signed in."
            self.showingResultAlert = true
            return
        }

        // Attempt to delete the user from Firebase Auth
        currentUser.delete { error in
            if let error = error {
                self.errorMessage = "Error deleting user: \(error.localizedDescription)"
                self.showingResultAlert = true
                return
            }

            // Optionally, handle Firestore data deletion here
            deleteUserData(userUID: currentUser.uid)
        }
    }

    private func deleteUserData(userUID: String) {
        let db = Firestore.firestore()

        // Delete user's data from Firestore
        db.collection("users").document(userUID).delete { error in
            if let error = error {
                self.errorMessage = "Error deleting user data: \(error.localizedDescription)"
                self.showingResultAlert = true
                return
            }

            self.errorMessage = nil
            self.showingResultAlert = true
        }
    }
    func updateProfilePictureURL(_ url: String, for userUID: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let userDocRef = db.collection("Users").document(userUID)
        
        userDocRef.setData(["profilePictureURL": url], merge: true) { error in
            completion(error)
        }
    }
    
    func logOut() {
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

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}



