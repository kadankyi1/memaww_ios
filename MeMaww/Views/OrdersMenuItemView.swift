//
//  OrdersMenuItemView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 11/27/24.
//

import SwiftUI

struct OrdersMenuItemView: View {
    //@Environment(\.sizeCategory) var sizeCategory

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
                Spacer()
                Image(imageName)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                
                Text(menuTitle)
                    .font(.headline)
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(menuDescription)
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .center)

                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding()
        .cornerRadius(10)
    }
    
    /*
    func getSize() -> CGFloat {
        switch sizeCategory {
        case .extraSmall, .small:
            print("12---")
            return 12
        case .medium:
            print("16---")
            return 16
        case .large:
            print("20---")
            return 20
        case .extraLarge, .extraExtraLarge, .extraExtraExtraLarge:
            print("24---")
            return 24
        default:
            print("16---")
            return 16
        }
      }
     */
}

struct OrdersMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersMenuItemView(imageName: "distribution", menuTitle: "Start Pickup Request", menuDescription: "Fill Info | Apply Discounts | Check Pricing", showLoading: false)
    }
}


