//
//  StartButtonView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/17/24.
//

import SwiftUI

struct StartButtonView: View {
    // MARK: - PROPERTIES
    
    @Binding var currentStage: String
    @AppStorage("appStage") var appStage: String?
    
    
    // MARK: - BODY
    var body: some View {
        
        Button(action: {
            //appStage = "LoginView"
            self.currentStage = "SignupView"
        }) {
            HStack (spacing: 8) {
                Text("START")
                    .foregroundColor(Color.accentColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundColor(Color.accentColor)
        } //: BUTTON
        .accentColor(Color.accentColor)
        .background(Color.white)
        .cornerRadius(20)
        
        
    }
}

    // MARK - PREVIEW


struct StartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StartButtonView(currentStage: .constant("LoginView"))
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
}
 
