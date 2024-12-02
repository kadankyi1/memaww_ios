//
//  OrdersMenuItemView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 11/27/24.
//

import SwiftUI

struct CurrentSubscriptionView: View {
    
    var subscription_end_note: String
    var pickupsDone: String
    var pickupTime: String
    var itemsWashed: String
    
    var body: some View {
        GroupBox(){
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    
                        Text("Subscription")
                        .font(.headline).bold()
                    Spacer()
                    Image("subscriptionactive")
                        .foregroundColor(.gray)
                        .padding(10)
                        .cornerRadius(50)
                }
                    VStack(alignment: .leading) {
                        Text(subscription_end_note)
                            .lineLimit(2)
                            //.multilineTextAlignment(.left)
                            .font(.caption)
                        HStack(){
                            Text("Items: " + pickupsDone)
                                .font(.caption)
                            Spacer()
                            Text("Pickups: " + pickupsDone)
                                .font(.caption)
                            Spacer()
                            Text("Items: " + itemsWashed)
                                .font(.caption)
                        }
                    }
                
            }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .fixedSize(horizontal: false, vertical: false)
        .padding()
        }
        .padding()
        .cornerRadius(10)
    }
}

struct CurrentSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSubscriptionView(subscription_end_note: "Your subscription ends on Dec 11, 2024", pickupsDone: "2/4", pickupTime: "12:00, Sundays", itemsWashed: "100 /  Unlimited")
    }
}

