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
                            .fixedSize(horizontal: true, vertical: false)
                            //.multilineTextAlignment(.left)
                            .font(.caption)
                        HStack(){
                            Text("Pickups: " + pickupsDone)
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.caption)
                            Spacer()
                            Text("Items Washed: " + itemsWashed)
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.caption)
                        }
                        .padding(.top, 1)
                    Text("Pickup Time: " + pickupTime)
                        .fixedSize(horizontal: true, vertical: false)
                        .font(.caption)
                        .padding(.top, 1)
                        .padding(.bottom, 10)
                    }
                
            }
        .frame(maxWidth: .infinity, maxHeight: 65)
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

