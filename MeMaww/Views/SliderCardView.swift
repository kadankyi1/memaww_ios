//
//  SliderCardView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/17/24.
//

import SwiftUI

struct SliderCardView: View {
    // MARK: - PROPERTIES
    
    var start: SliderModel
    @State private var isAnimating: Bool = false
    @Binding var currentStage: String
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack (spacing: -70) {
                // FRUIT IMAGE
                VStack(){
                    Spacer()
                    Image(start.image)
                        .resizable()
                        .scaledToFit()
                        .padding(50)
                        .shadow(color: Color(red: 0, green: 0, blue: 0), radius: 0.15, x: 6, y: 8)
                    
                    Spacer()
                }
            
                // FRUIT TITLE
                Text(start.title)
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: 480)
                Text(start.body)
                    .foregroundColor(Color.white)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 70)
                    .frame(maxWidth: 480)
                
                // FRUIT HEADLINE
            
                // BUTTON: START
                StartButtonView(currentStage: $currentStage)
                    .padding(.vertical, 35)
            } //: VSTACK
        } //: ZSTACK
        .onAppear{
            withAnimation(.easeOut(duration: 0.5)){
                isAnimating = true
            }
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(LinearGradient(gradient: Gradient(colors: [Color("ColorMeMawwBlueDark")]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
        //.cornerRadius(20)
        //.padding(.horizontal, 10)
    }
}

// MARK: - PREVIEW
struct SliderCardView_Previews: PreviewProvider {
    static var previews: some View {
        SliderCardView(start: sliderData[0], currentStage: .constant("SignupView"))
            .previewLayout(.fixed(width: 320, height: 640))
    }
}
 
