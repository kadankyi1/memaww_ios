//
//  CallBackRequestView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 5/21/24.
//

import SwiftUI

struct CallBackRequestView: View {
    var name = "Request A Callback"
    
    var body: some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline).bold()
                    .foregroundColor(Color.white)
                
                Text("We call you | Take Your Order | No Discounts Apply")
                    .font(.caption)
                    .foregroundColor(Color.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Image(systemName: "phone.fill")
                .foregroundColor(.gray)
                .padding(10)
                .background(.white)
                .cornerRadius(50)
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .fixedSize(horizontal: false, vertical: false)
        .padding()
    }
}

struct CallBackRequestView_Previews: PreviewProvider {
    static var previews: some View {
        CallBackRequestView()
        .background(Color("ColorMeMawwBlueDark"))
    }
}
