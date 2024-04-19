//
//  SettingsLogoutView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/19/24.
//

import SwiftUI

struct SettingsLogoutView: View {
    // MARK: -- PROPERTIES
    
    @Binding var currentStage: String
    var icon: String
    var name: String
    var content: String? = nil
    var linkLabel: String? = nil
    var linkDestination: String? = nil
    
    
    // MARK: -- BODY
    var body: some View {
        HStack {
            Text(icon).foregroundColor(Color.black)
            Spacer()
            /*
             Text(name)
                .foregroundColor(Color.black)
                .font(.system(size: 14, weight: .heavy, design: .default))
                .onTapGesture {
                    deleteUserData()
                    self.currentStage = "OnboardingView"
                    print("currentStage: OnboardingView")
                }
             */
            
            if(content != nil){
                
            } else if(linkLabel != nil && linkDestination != nil){
                Link(linkLabel!, destination: URL(string: linkDestination!)!)
                Image(systemName: "arrow.up.right.square").foregroundColor(.pink)
            } else {
                EmptyView()
            }
        }
    }
}


// MARK: -- PREVIEW
struct SettingsLogoutView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLogoutView(currentStage: .constant("SignupView"), icon: "newwitness",name: "Prayer Requests")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
