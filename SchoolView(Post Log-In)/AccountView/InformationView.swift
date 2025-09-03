//
//  InformationView.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/27/24.
//

import SwiftUI

struct InformationView: View {
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
    @State var infoText: String =

    """
Dear User,
    
Thank you for downloading Unibell, a student app to provide you with easy access to school resources, planners, and hopefully much more. As we are still developing, please be patient with the slight chance of bugs within our App. In the near future, we have plans to implement a multitude of features such as:
    
    
    • Add your classes to match up with the blocks/periods of the day
    
    • Allow for schools to show all announcements regarding special events, sports games, etc.
    
    • Customizable options, such as fonts, colors, themes, and images to your user interface
    
    • The option to add a 360° view model of schools.
    
However, it could take some time before these features could be implemented.
    
Finally, below you will find known bug(s) that I am currently trying to fix, but are small and do not impact the accessibility of the app:
    
    • When leaving school, you will not be automatically put into the code screen, please log out and sign again or simply restart the app.
    
Thank you once again for downloading Unibell and if you would like to provide feedback or something you would like to see in this app, please contact me at:
    
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
                
                HStack {
                    Image(systemName: "info.circle")
                        .padding(xSmallPaddingSize)
                    Text("About Unibell")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .hAlign(.center)
                .padding(.bottom)
                VStack {
                    Text(infoText)
                        .padding(.horizontal)
                    Divider()
                    HStack {
                        Text("""
                    Nathaniel Ham,
                    
                    Developer and Founder of Unibell
                    """)
                    Divider()
                    Text("Credits: Samuel Ham, Logo Designer")
                    }
                    .hAlign(.leading)
                    .padding()
                }
                .padding()
                .font(.body)
            }
        }
    }
}

