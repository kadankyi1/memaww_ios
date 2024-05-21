//
//  FinalPriceView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/24/24.
//

import SwiftUI

struct FinalPriceView: View {
    // MARK: -- PROPERTIES
    @Binding var currentStage: String
    var payOnline: String
    var payOnPickup: String
    var originalPrice: String
    var discountPercentage: String
    var discountAmount: String
    var priceFinal: String
    
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: -- BODY
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20){
                    // MARK: -- SECTION 2
                    GroupBox(){
                        
                        FinalPriceListItemView(label: "Sub-Total", name: self.originalPrice)
                        Divider().padding(.vertical, 2)
                        FinalPriceListItemView(label: "Discount", name: self.discountAmount)
                        Divider().padding(.vertical, 2)
                        FinalPriceListItemView(label: "Final Price", name: self.priceFinal)
                        
                    }label: {}
                    Divider().padding(.vertical, 2)
                    GroupBox(){
                        
                        
                        if payOnline == "yes"{
                            Button(action: {
                                //print("collect_loc_raw: \(self.pickupLocation)")
                                //getPriceManager.getPrice(collect_loc_raw: self.pickupLocation)
                            }) {
                                HStack (spacing: 8) {
                                    Text("PAY ONLINE")
                                        .foregroundColor(Color.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .foregroundColor(Color("ColorMeMawwBlueDark"))
                            } //: BUTTON
                            .frame(maxWidth: .infinity, alignment: .center)
                            .accentColor(Color.accentColor)
                            .background(Color("ColorMeMawwBlueDark"))
                            .cornerRadius(20)
                            .padding(.bottom, 50)
                        }
                        
                        if payOnPickup == "yes"{
                            Button(action: {
                                //print("collect_loc_raw: \(self.pickupLocation)")
                                //getPriceManager.getPrice(collect_loc_raw: self.pickupLocation)
                            }) {
                                HStack (spacing: 8) {
                                    Text("PAY ON PICKUP")
                                        .foregroundColor(Color.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .foregroundColor(Color("ColorMeMawwBlueDark"))
                            } //: BUTTON
                            .frame(maxWidth: .infinity, alignment: .center)
                            .accentColor(Color.accentColor)
                            .background(Color("ColorGrayDark"))
                            .cornerRadius(20)
                            .padding(.bottom, 50)
                        }
                        
                    }
                    Divider().padding(.vertical, 2)
                    // MARK: -- SECTION 1
                    GroupBox(){
                        SettingsLogoutView(currentStage: .constant("MainView"),  icon: "We hope you benefit and enjoy this service at least half as much as we love providing the service to you.",  name: "")
                    }
                }
            } // SCROLLVIEW
            .padding(.horizontal, 20)
        } // NAVIGATION
    }
}

struct FinalPriceView_Previews: PreviewProvider {
    static var previews: some View {
        FinalPriceView(currentStage:  .constant("MainView"), payOnline: "yes", payOnPickup:"yes", originalPrice: "$10", discountPercentage: "20%", discountAmount: "$2", priceFinal: "$8")
    }
}
