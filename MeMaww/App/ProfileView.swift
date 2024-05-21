//
//  ProfileView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/19/24.
//

import SwiftUI

struct ProfileView: View {
    // MARK: -- PROPERTIES
    @Binding var currentStage: String
    var user_name: String
    var user_phone: String
    var user_address: String
    var user_email: String
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: -- BODY
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20){
                    // MARK: -- SECTION 2
                    GroupBox(){
                        SettingsRowView(icon: "people", name: user_name)
                        Divider().padding(.vertical, 2)
                        SettingsRowView(icon: "smartphone", name: user_phone)
                        Divider().padding(.vertical, 2)
                        SettingsRowView(icon: "location", name: user_address)
                        Divider().padding(.vertical, 2)
                        SettingsRowView(icon: "email", name: user_email)
                        
                    }label: {}
                    Divider().padding(.vertical, 2)
                    GroupBox(){
                        
                        SettingsRowView(icon: "info", name: "", content: nil, linkLabel: "Service Policy", linkDestination: "https://memaww.com/privacy-policy")
                        SettingsRowView(icon: "star", name: "", content: nil, linkLabel: "Rate The App", linkDestination: "https://www.facebook.com/theHoly.Generation20")
                        
                    }
                    Divider().padding(.vertical, 2)
                    // MARK: -- SECTION 1
                    GroupBox(){
                        SettingsLogoutView(currentStage: .constant("MainView"),  icon: "We hope you benefit and enjoy this service at least half as much as we love providing the service to you.",  name: "")
                    }
                }
            } // SCROLLVIEW
            .padding(.horizontal, 20)
        } // NAVIGATION
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(currentStage: .constant("MainView"), user_name: "Mark Caw", user_phone: "02333333333", user_address: "Not Set", user_email: "Not Set")
    }
}
