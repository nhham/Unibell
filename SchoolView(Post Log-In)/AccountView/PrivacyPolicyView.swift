//
//  PrivacyPolicyView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/27/24.
//

import SwiftUI
import Foundation

struct PrivacyPolicyView: View {
    @Environment(\.largePaddingSize) var largePaddingSize
    @Environment(\.mediumPaddingSize) var mediumPaddingSize
    @Environment(\.smallPaddingSize) var smallPaddingSize
    @Environment(\.xSmallPaddingSize) var xSmallPaddingSize
    @Environment(\.xLargeFontSize) var xLargeFontSize
    @Environment(\.largeFontSize) var largeFontSize
    @Environment(\.mediumFontSize) var mediumFontSize
    @Environment(\.smallFontSize) var smallFontSize
    @Environment(\.xSmallFontSize) var xSmallFontSize
    @Binding var currentView: String
    @State var privacyPolicyText: String =
    
    """
    Privacy Policy

    Effective Date: July 27, 2024

    1. Introduction

    Welcome to Unibell. We respect your privacy and are committed to protecting your personal data. This privacy policy explains how we collect, use, and share information about you when you use our app, which uses Firebase as the backend to hold all data.

    2. Information We Collect

    We collect the following types of information:

    • Personal Information: When you sign up, we collect your username and email address to create and manage your account.
    • Photo Library Access: With your permission, we access your photo library to allow you to upload photos to our app.

    3. How We Use Your Information

    We use the information we collect for the following purposes:

    • Account Management: To create and manage your account, authenticate you, and provide customer support such as resetting password.
    • Save changes: The changes you make to your account like adding task items to the planner are saved to Firebase on a document associated with your provided email.
    • App Functionality: To enable features within the app, such as uploading and sharing photos.
    • Communication: To send you updates, security alerts, and other notifications related to your use of the app.

    4. Sharing Your Information

    We do not share your personal information with third parties except in the following circumstances:

    • Service Providers: We use Firebase as our backend service provider, which helps us operate and improve our app. Firebase is contractually obligated to protect your information.
    • Legal Requirements: We may disclose information if required to do so by law or in response to a valid request from law enforcement or other government agencies.

    5. Data Security

    We take reasonable measures to protect your information from unauthorized access, loss, misuse, or alteration. Firebase implements strong security measures to protect your data. However, no method of transmission over the Internet or electronic storage is completely secure, so we cannot guarantee absolute security.

    6. Your Choices

    You have the following choices regarding your information:

    • Access and Update: You can access and update your personal information through your account settings.
    • Permissions: You can control the app’s access to your photo library through your device settings.
    • Account Deletion: You can delete your account at any time through the app settings. This will remove your personal information from our systems and Firebase.

    7. Children’s Privacy

    Our app is not intended for children under the age of 4. We do not knowingly collect personal information from children under 4. If you believe we have collected information from a child under 4, please contact us, and we will promptly delete the information.

    8. Changes to This Privacy Policy

    We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page and updating the effective date. Your continued use of the app after the changes become effective signifies your acceptance of the revised policy.

    9. Contact Us

    If you have any questions or concerns about this privacy policy or our data practices, please contact us at:

    [Contact Information]

    ---

      Unibell
    
    unibell.companyservices@gmail.com
    """

    var body: some View {
        
        ScrollView {
            
            VStack {
                Button(action: {
                    currentView = "Account"
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .tint(.red)
                })
                .padding(.horizontal)
                .hSpacing(.leading)
                VStack {
                    HStack {
                        Image(systemName: "lock")
                            .padding(xSmallPaddingSize)
                        Text("Privacy Policy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                    }
                    .hAlign(.center)
                    .padding(.bottom)
                    
                    Text(privacyPolicyText)
                        .padding(smallPaddingSize)
                        .font(.body)
                        .clipShape(RoundedRectangle(cornerRadius: 30.0))
                    
                }
                .padding()
            }
      
        }
    }
}
