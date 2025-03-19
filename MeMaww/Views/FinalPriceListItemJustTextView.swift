//
//  FinalPriceListItemJustTextView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 11/28/24.
//

import SwiftUI

struct FinalPriceListItemJustTextView: View {
    var image: String
    var name: String
    
    var body: some View {
        HStack {
            Image(image)
                .foregroundColor(Color.gray)
            Spacer()
            Text(name).foregroundColor(Color.gray)
            
        }
    }
}

struct FinalPriceListItemJustTextView_Previews: PreviewProvider {
    static var previews: some View {
        FinalPriceListItemJustTextView(image: "plus", name: "Unlimited Items")
    }
}
