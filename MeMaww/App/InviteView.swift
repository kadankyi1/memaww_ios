//
//  InviteView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/20/24.
//

import SwiftUI

struct InviteView: View {
    
    @State private var isAnimating: Bool = false
    @Binding var currentStage: String
    var referral_code: String
    
    var body: some View {
        ZStack {
            VStack (spacing: -70) {
                // FRUIT IMAGE
                VStack(){
                    Spacer()
                    // FRUIT TITLE
                    Text("**INVITE A FRIEND**")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.system(size: 20, weight: .heavy, design: .default))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .frame(maxWidth: 480)
                    
                    Text("Send the code below to a friend and when they make their first order, you both get up to a 100% off.")
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: 480)
                    
                    Spacer()
                    
                    Image("gift")
                        .resizable()
                        .scaledToFit()
                        .padding(100)
                        .shadow(color: Color(red: 0, green: 0, blue: 0), radius: 0.15, x: 6, y: 8)
                    
                    Spacer()
                    
                    Text(referral_code)
                        .font(.system(size: 30, weight: .heavy, design: .default))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 70)
                        .frame(maxWidth: .infinity, maxHeight: 80)
                        .foregroundColor(Color("ColorMeMawwBlueDark"))
                        .background(Color.white)
                    
                    // FRUIT HEADLINE
                
                    // BUTTON: START
                    InviteButtonView(currentStage: $currentStage)
                        .padding(.vertical, 35)
                }
            
            } //: VSTACK
        } //: ZSTACK
        .onAppear{
            withAnimation(.easeOut(duration: 0.5)){
                isAnimating = true
            }
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(LinearGradient(gradient: Gradient(colors: [Color("ColorMeMawwBlueDark")]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
    }
}

struct InviteView_Previews: PreviewProvider {
    static var previews: some View {
        InviteView(currentStage: .constant("MainView"), referral_code: "IQ7E9K1")
    }
}
