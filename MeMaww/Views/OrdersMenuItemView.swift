//
//  OrdersMenuItemView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 11/27/24.
//

import SwiftUI

struct OrdersMenuItemView: View {
    
    var imageName: String
    var menuTitle: String
    var menuDescription: String
    var showLoading: Bool
    
    var body: some View {
        GroupBox(){
            if (showLoading){
                ProgressView()
            }
            VStack(){
                Image(imageName)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Text(menuTitle)
                    .padding(.bottom, 5)
                Text(menuDescription)
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .cornerRadius(10)
    }
}

struct OrdersMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersMenuItemView(imageName: "distribution", menuTitle: "Start Pickup Request", menuDescription: "Fill Info | Apply Discounts | Check Pricing", showLoading: false)
    }
}
