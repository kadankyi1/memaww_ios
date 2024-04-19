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
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: -- BODY
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20){
                    // MARK: -- SECTION 1
                    GroupBox(){
                        SettingsLogoutView(currentStage: .constant("MainView"),  icon: user_name, name: "Log Out")
                    }
                    Divider().padding(.vertical, 2)
                    // MARK: -- SECTION 2
                    GroupBox(){
                        SettingsRowView(icon: "invite", name: "Prayer Requests")
                        Divider().padding(.vertical, 2)
                        SettingsRowView(icon: "invite", name: "Prayer Requests")
                        Divider().padding(.vertical, 2)
                        SettingsRowView(icon: "invite", name: "Prayer Requests")
                        
                    }label: {}
                    Divider().padding(.vertical, 2)
                    GroupBox(){
                        
                        SettingsRowView(icon: "invite", name: "", content: nil, linkLabel: "Pastor Julius G ChristLord", linkDestination: "https://web.facebook.com/PastorJuliusGChristLord")
                        SettingsRowView(icon: "invite", name: "", content: nil, linkLabel: "The Holy Generation", linkDestination: "https://www.facebook.com/theHoly.Generation20")
                        SettingsRowView(icon: "invite", name: "", content: nil, linkLabel: "Impact Train", linkDestination: "https://thegloryhub.fishpott.com/uploads/pdfs/hog.pdf")
                        
                    }
                }
            } // SCROLLVIEW
            .padding(.horizontal, 20)
        } // NAVIGATION
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(currentStage: .constant("MainView"), user_name: "Mark Caw")
    }
}
