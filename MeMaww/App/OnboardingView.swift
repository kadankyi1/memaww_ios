//
//  OnboardingView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/17/24.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - PROPERTIES
    //@AppStorage("appStage") var appStage: String?
    var start: [SliderModel] = sliderData
    @Binding var currentStage: String
    
    // MARK: - BODY
    var body: some View {
        TabView {
            ForEach(start[0...0]) { item in
                SliderCardView(start: item, currentStage: $currentStage)
            } //: LOOP
        } //: TAB
        .tabViewStyle(PageTabViewStyle())
        //.padding(.vertical, 10)
    }
}

// MARK: - PREVIEW


struct OnboardingView_Previews: PreviewProvider {
    @Binding var currentStage: String
    static var previews: some View {
        OnboardingView(start: sliderData, currentStage: .constant("SignupView"))
    }
}
 
 
