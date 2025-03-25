//
//  SubscriptionFinalPriceView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/24/24.
//

import SwiftUI
import SwiftyJSON
import TheTellerCheckout

struct SubscriptionFinalPriceView: View {
    // MARK: -- PROPERTIES
    @Binding var selectedIndex: Int
    var originalPrice: String
    var priceFinal: String
    var priceFinalLong: String
    var txnReference: String
    var merchantId: String
    var merchantApiUser: String
    var merchantApiKey: String
    var returnUrl: String
    var txnNarration: String
    var userEmail: String
    var userCurrency: String
    var subscriptionPersons: String
    var subscriptionMonths: String
    var subscriptionPickupTime: String
    var subscriptionPickupLocation: String
    var subscriptionPackageDescription1: String
    var subscriptionPackageDescription2: String
    var subscriptionPackageDescription3: String
    var subscriptionPackageDescription4: String
    var subscriptionCountryId: String
    @ObservedObject var model: MyModel = MyModel()
    @State var showButton: Bool = true
    @State var viewStage: String = "1"
    @State var paymentResponse: String = ""
    var merchantTestApiKey: String
    @State var paymentStatus: String = ""
    @ObservedObject var updateSubscriptionOrderPayment = updateSubscriptionOrderPaymentHttp()
    
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: -- BODY
    var body: some View {
        //NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20){
                    // MARK: -- SECTION 2
                    GroupBox(){
                        Text(userCurrency+originalPrice)
                            .font(.title)
                        Text(subscriptionPersons + " Person(s) for " + subscriptionMonths + " month")
                            .font(.callout)
                        Divider().padding(.vertical, 2)
                        FinalPriceListItemView(label: "-", name: subscriptionPackageDescription1)
                            .padding(.bottom, 5)
                        FinalPriceListItemView(label: "-", name: subscriptionPackageDescription2)
                            .padding(.bottom, 5)
                        FinalPriceListItemView(label: "-", name: subscriptionPackageDescription3)
                            .padding(.bottom, 5)
                        FinalPriceListItemView(label: "-", name: subscriptionPackageDescription4)
                            .padding(.bottom, 5)
                        
                    }label: {}
                    Divider().padding(.vertical, 2)
                    GroupBox(){
                        
                        
                        if updateSubscriptionOrderPayment.viewStage == "1"{
                            
                            
                            Link("By subscribing, you agree to our service and fair use policies. Click here to read", destination: URL(string: "https://memaww.com/fair-usage-policy")!)
                                .font(.caption)
                            
                            if showButton {
                                Button(action: {
                                    showButton = false
                                    //updateSubscriptionOrderPayment.viewStage = "3"
                                    
                                    let checkout = TheTellerCheckout(
                                        config: [
                                            "merchantID": self.merchantId,
                                            "API_Key_Prod" : self.merchantApiKey,
                                            "API_Key_Test" : self.merchantTestApiKey,
                                            "apiuser" : self.merchantApiUser,
                                            "redirect_url" : self.returnUrl,
                                            "isProduction" : true /*  if true  "API_Key_Prod" will be used to initiate checkout, set it  to false during test  */
                                        ])
                                    
                                    //if (updateSubscriptionOrderPayment.useLocalID){
                                    //print("txnReference LOCAL: " + self.txnReference)
                                    //txnReference2 = updateSubscriptionOrderPayment.newTransactionId
                                    //updateSubscriptionOrderPayment.generateNewTransactionID()
                                    //print("txnReference2 LOCAL: " + txnReference2)
                                    //}
                                    
                                    print("txnReference-: " + txnReference)
                                    let newtxnRef = Int(txnReference) ?? 0
                                    print("txnReference2-: " + String(newtxnRef))
                                    
                                    checkout.initCheckout(transId: self.txnReference, amount: self.priceFinal, desc: self.txnNarration, customerEmail: userEmail, paymentMethod: "momo", paymentCurrency: "GHS", callback: { string,error  in
                                        ///////////////////////////////////////
                                        ///////////////////////////////////////
                                        ///////////////////////////////////////
                                        ///////////////////////////////////////
                                        print("PAYMENT RESULT START")
                                        print(string ?? "Payment error occurred")
                                        
                                        let payment_status = string? ["status"] as! String
                                        paymentStatus = payment_status
                                        
                                        print("PAYMENT STATUS: " + paymentStatus)
                                        print("PAYMENT RESULT END")
                                        updateSubscriptionOrderPayment.viewStage = "3"
                                        
                                        
                                    }) // END OF initCheckout
                                    
                                }) {
                                    HStack (spacing: 8) {
                                        Text("PAY ONLINE")
                                            .foregroundColor(Color.white)
                                    }
                                    .foregroundColor(Color("ColorMeMawwBlueDark"))
                                } //: BUTTON
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                                .background(Color.green)
                                .cornerRadius(10)
                            } else {
                                ProgressView()
                            }
                        }
                        
                        if updateSubscriptionOrderPayment.viewStage == "2"{ // SHOW PAYMENT SUCCESSFUL AND CLOSE PAGE
                            
                            
                                ProgressView()
                            
                        }
                        
                        if updateSubscriptionOrderPayment.viewStage == "3"{ // SHOW PAYMENT UPDATE AND CLOSE PAGE
                            
                            VStack {}
                                .alert(isPresented: $model.isValid, content: {
                                Alert(title: Text("Order Payment"),
                                      message: Text((paymentStatus == "approved") ? "Payment successful. You just saved a lot on laundry" : "Payment failed. If you made the payment and this is an error, please contact us"),
                                      dismissButton: .default(
                                        Text("Okay"))
                                        {
                                            if paymentStatus == "approved" {
                                                selectedIndex = 2
                                                updateSubscriptionOrderPayment.updateSubscriptionOrder(subscription_payment_transaction_id: txnReference, subscription_amount_paid: originalPrice, subscription_max_number_of_people_in_home: subscriptionPersons, subscription_number_of_months: subscriptionMonths, subscription_pickup_time: subscriptionPickupTime, subscription_pickup_location: subscriptionPickupLocation, subscription_package_description: subscriptionPackageDescription1 + " | " + subscriptionPackageDescription2 + " | " + subscriptionPackageDescription3 + " | " + subscriptionPackageDescription4, subscription_country_id: subscriptionCountryId, subscription_purge: "0")
                                                //print("PAYMENT APPROVED: GONE TO ORDERS TAB NUMBERED: \(selectedIndex)")
                                            } else {
                                                updateSubscriptionOrderPayment.updateSubscriptionOrder(subscription_payment_transaction_id: txnReference, subscription_amount_paid: originalPrice, subscription_max_number_of_people_in_home: subscriptionPersons, subscription_number_of_months: subscriptionMonths, subscription_pickup_time: subscriptionPickupTime, subscription_pickup_location: subscriptionPickupLocation, subscription_package_description: subscriptionPackageDescription1 + " | " + subscriptionPackageDescription2 + " | " + subscriptionPackageDescription3 + " | " + subscriptionPackageDescription4, subscription_country_id: subscriptionCountryId, subscription_purge: "1")
                                                selectedIndex = 2
                                                selectedIndex = 6
                                                updateSubscriptionOrderPayment.viewStage = "1"
                                                print("selectedIndex 6")
                                                //
                                                
                                            }
                                            
                                        })
                            })
                        
                    }
                        
                    }
                    Divider().padding(.vertical, 2)
                    // MARK: -- SECTION 1
                    GroupBox(){
                        SettingsLogoutView(icon: "We hope you benefit and enjoy this service at least half as much as we love providing the service to you.",  name: "")
                    }
                }
            } // SCROLLVIEW
            .padding(.horizontal, 20)
       // } // NAVIGATION
    }
}

struct SubscriptionFinalPriceView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionFinalPriceView(selectedIndex: .constant(2), originalPrice: "10", priceFinal: "10", priceFinalLong: "0000010", txnReference: "Test Txn", merchantId: "merchantId", merchantApiUser: "merchantApiKey", merchantApiKey: "merchantApiKey", returnUrl: "returnUrl", txnNarration: "txnNarration", userEmail: "userEmail", userCurrency: "Ghc", subscriptionPersons: "1", subscriptionMonths: "1", subscriptionPickupTime: "7:00", subscriptionPickupLocation: "Madina", subscriptionPackageDescription1: "Unlimited Items", subscriptionPackageDescription2: "1 Pickup per week", subscriptionPackageDescription3: "Delivery in 48hrs", subscriptionPackageDescription4: "Wash & Fold/Iron", subscriptionCountryId: "81", merchantTestApiKey: "merchantTestApiKey")
    }
}


class updateSubscriptionOrderPaymentHttp: ObservableObject {
    @Published var requestOngoing = false;
    @Published var requestResponseStatus = "";
    @Published var requestMessage = "";
    @Published var viewStage = "1";
    @Published var useLocalID = false;
    @Published var newTransactionId = ""
    
    
    func generateNewTransactionID(){
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyMMmmss"
        newTransactionId = getSavedString("user_userid")
        newTransactionId += df.string(from: date)
        
        let n = Int(newTransactionId) ?? 0
        
        newTransactionId = String(format: "%012d", n)
    }
    
    
    func updateSubscriptionOrder(subscription_payment_transaction_id: String, subscription_amount_paid: String, subscription_max_number_of_people_in_home: String, subscription_number_of_months: String, subscription_pickup_time: String, subscription_pickup_location: String, subscription_package_description: String, subscription_country_id: String, subscription_purge: String) {
        
        self.requestOngoing = true
        guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/set-user-subscription")
        else {
            print("Request failed 1")
            return
            
        }
        
        let body: [String: String] =
        [
            "subscription_payment_transaction_id": subscription_payment_transaction_id,
            "subscription_amount_paid": subscription_amount_paid,
            "subscription_max_number_of_people_in_home": subscription_max_number_of_people_in_home,
            "subscription_number_of_months": subscription_number_of_months,
            "subscription_pickup_time":subscription_pickup_time,
            "subscription_pickup_location":subscription_pickup_location,
            "subscription_package_description":subscription_package_description,
            "subscription_country_id":subscription_country_id,
            "subscription_purge":subscription_purge,
            "app_type": "IOS",
            "app_version_code": MeMawwApp.app_version
        ]
        
        print("subscription_payment_transaction_id: \(subscription_payment_transaction_id)")
        print("subscription_amount_paid: \(subscription_amount_paid)")
        print("subscription_max_number_of_people_in_home: \(subscription_max_number_of_people_in_home)")
        print("subscription_number_of_months: \(subscription_number_of_months)")
        print("subscription_pickup_time: \(subscription_pickup_time)")
        print("subscription_pickup_location: \(subscription_pickup_location)")
        print("subscription_package_description: \(subscription_package_description)")
        print("subscription_country_id: \(subscription_country_id)")
        print("subscription_purge: \(subscription_purge)")
        print("user_accesstoken: \(getSavedString("user_accesstoken"))")
        
    let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        let auth_pass = "Bearer " + getSavedString("user_accesstoken")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(auth_pass, forHTTPHeaderField: "Authorization")
        

        print("PAYMENT RECORDING ABOUT TO START REQUEST")
        URLSession.shared.dataTask(with: request) { (data, response, error) in guard let data = data else { return }
        print("data: \(data)")
            
    do {
    let json = try JSON(data: data)
    if let status = json["status"].string {
    //Now you got your value
    
    print("PAYMENT RECORDING STATUS:  \(status)" )
        
    DispatchQueue.main.async {
        self.requestOngoing = false
        if status == "success" {
            self.requestResponseStatus = status
            //self.viewStage = "3"
            
        } else {
            if let message = json["message"].string {
                //Now you got your value
                print(status)
                print(message)
                
                    //self.viewStage = "3"
                  
                  DispatchQueue.main.async {
                      self.requestMessage = message
                      self.useLocalID = true
                  }
              }
            }
          }
         }
        } catch  let error as NSError {
            DispatchQueue.main.async {
            self.requestOngoing = false
            //self.viewStage = "3"
            self.requestMessage = "Failed to get messages"
            self.useLocalID = true
                print("Request failed 3")
                print(error)
            }
    }
            
        }.resume()
    }
}
    
