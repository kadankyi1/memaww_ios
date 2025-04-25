//
//  RemaningItemsListItemView.swift
//  MeMaww
//
//  Created by Kwaku Dankyi on 24/04/2025.
//


import SwiftUI
//import URLImage // Import the package module

struct RemainingItemsListItemView: View {
    // MARK: - PROPERTIES
    var remaining_item: RemainingItemsModel
    
    // MARK: - BODY
    var body: some View {
                        
        GroupBox(){
                VStack(){
                    
                    Text(remaining_item.remaining_items_body)
                            .font(.caption)
                            .foregroundColor(Color.black)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    Text(remaining_item.remaining_items_date)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - PREVIEW
struct RemainingItemsListItemView_Previews: PreviewProvider {
    static var previews: some View {
        RemainingItemsListItemView(remaining_item: RemainingItemsData[0])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
