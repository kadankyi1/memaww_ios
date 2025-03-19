//
//  InviteButtonView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/20/24.
//

import SwiftUI

struct InviteButtonView: View {
    // MARK: - PROPERTIES
    
    @Binding var currentStage: String
    @AppStorage("appStage") var appStage: String?
    @State var isPresentedShareInvitationText: Bool = false
    @State var inviteCode: String
    
    
    // MARK: - BODY
    var body: some View {
        
        Button(action: {
            isPresentedShareInvitationText = true
        }) {
            HStack (spacing: 8) {
                Text("SEND INVITE")
                    .foregroundColor(Color.accentColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundColor(Color.accentColor)
        } //: BUTTON
        .accentColor(Color.accentColor)
        .background(Color.white)
        .cornerRadius(20)
        .sheet(isPresented: $isPresentedShareInvitationText) {
            ShareSheet(text: "You and I will get a discount on our laundry if you use my invite code " + inviteCode + " to register on the MeMaww Laundry App and place your first order")
        }
        
        
    }
}

    // MARK - PREVIEW


struct InviteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        InviteButtonView(currentStage: .constant("LoginView"), inviteCode: "S-A-M-P-L-E-CODE")
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
}
 
