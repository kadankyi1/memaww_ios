//
//  FinalPriceListItemView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/24/24.
//

import SwiftUI

struct FinalPriceListItemView: View {
    // MARK: -- PROPERTIES
    
    var label: String
    var name: String
    
    
    // MARK: -- BODY
    var body: some View {
        HStack {
            Text(label).foregroundColor(Color.gray)
            Spacer()
            Text(name).foregroundColor(Color.gray)
            
        }
    }
}

struct FinalPriceListItemView_Previews: PreviewProvider {
    static var previews: some View {
        FinalPriceListItemView(label: "Final Price", name: "$100")
    }
}
