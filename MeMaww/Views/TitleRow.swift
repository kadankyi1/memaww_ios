//
//  TitleRow.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/22/24.
//

import SwiftUI

struct TitleRow: View {
    var name = "MeMaww Support"
    
    var body: some View {
        
        VStack(){
        HStack(spacing: 5) {
            
            
                Image("ImageLogoBlack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(20)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline).bold()
                    .foregroundColor(Color.white)
                
                Text("Chat is currently unavailable. Kindly call us on +233538815095")
                    .font(.caption)
                    .foregroundColor(Color.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            
            Button {
                let tel = "tel://+233538815095"
                let formattedString = tel
                guard let url = URL(string: formattedString) else { return }
                UIApplication.shared.open(url)
            } label: {
                Image(systemName: "phone.fill")
                    .foregroundColor(.gray)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(50)
                }
            }
        .padding()
        }
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow()
            .background(Color("ColorMeMawwBlueDark"))
    }
}
