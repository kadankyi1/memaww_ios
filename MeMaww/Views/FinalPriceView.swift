//
//  FinalPriceView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/24/24.
//

import SwiftUI
import SwiftyJSON
import TheTellerCheckout

struct FinalPriceView: View {
    // MARK: -- PROPERTIES
    @State private var finalPriceViewMainView: String = "MainView"
    @Binding var selectedIndex: Int
    var payOnline: String
    var payOnPickup: String
    var originalPrice: String
    var discountPercentage: String
    var discountAmount: String
    var priceFinal: String
    var priceFinalLong: String
    var txnReference: String
    var merchantId: String
    var merchantApiUser: String
    var merchantApiKey: String
    var returnUrl: String
    var txnNarration: String
    var userEmail: String
    var finalPriceIos: String
    @ObservedObject var model: MyModel = MyModel()
    @State var viewStage: String = "1"
    @State var paymentResponse: String = ""
    var merchantTestApiKey: String
    @State var paymentStatus: String = ""
    @ObservedObject var updateOrderPayment = updateOrderPaymentHttp()
    
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: -- BODY
    var body: some View {
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
                        
                        
                        if payOnline == "yes" && updateOrderPayment.viewStage == "1"{
                            Button(action: {
                                updateOrderPayment.viewStage = "2"
                                let txnrefInt = (txnReference as NSString).integerValue

                                
                                let checkout = TheTellerCheckout(
                                    /* */
                                    config: [
                                        "merchantID": self.merchantId,
                                        "API_Key_Prod" : self.merchantApiKey,
                                        "API_Key_Test" : self.merchantTestApiKey,
                                        "apiuser" : self.merchantApiUser,
                                        "redirect_url" : self.returnUrl,
                                        "isProduction" : true /*  if true  "API_Key_Prod" will be used to initiate checkout, set it  to false during test  */
                                    ])
                                //"000000000010"
                                checkout.initCheckout(transId: self.txnReference, amount: self.priceFinalLong, desc: self.txnNarration, customerEmail: userEmail, paymentMethod: "momo", paymentCurrency: "GHS", callback: { string,error  in
                                    ///////////////////////////////////////
                                    ///////////////////////////////////////
                                    ///////////////////////////////////////
                                    ///////////////////////////////////////
                                    print("PAYMENT RESULT START")
                                    print(string ?? "Payment error occurred")
                                    
                                    let payment_status = string? ["status"] as! String
                                    paymentStatus = payment_status
                                    updateOrderPayment.viewStage = "3"
                                    print("PAYMENT STATUS: " + paymentStatus)
                                    print("PAYMENT RESULT END")
                                    
                                }) // END OF initCheckout

                                
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
                        
                        if updateOrderPayment.viewStage == "2"{ // SHOW PAYMENT SUCCESSFUL AND CLOSE PAGE
                            
                            
                                ProgressView()
                            
                        }
                        
                        if updateOrderPayment.viewStage == "3"{ // SHOW PAYMENT UPDATE AND CLOSE PAGE
                            
                            VStack {}
                                .alert(isPresented: $model.isValid, content: {
                                Alert(title: Text("Order"),
                                      message: Text((paymentStatus == "approved") ? "Order successful. We will be on our way to pickup your items" : "Payment failed. If you made the payment and this is an error, please contact us"),
                                      dismissButton: .default(
                                        Text("Okay"))
                                        {
                                            if paymentStatus == "approved" ||  paymentStatus == "pay_on_pickup" {
                                                
                                                updateOrderPayment.updateOrder(txnReference: self.txnReference, paymentStatus: paymentStatus, paymentResponse: "Check from PaySwitch", paymentMethod: "PaySwitch")
                                                selectedIndex = 0
                                                print("PAYMENT APPROVED: GONE TO ORDERS TAB NUMBERED: \(selectedIndex)")
                                            } else {
                                                updateOrderPayment.updateOrder(txnReference: self.txnReference, paymentStatus: "failed", paymentResponse: "Failed to pay", paymentMethod: "failed")
                                                selectedIndex = 2
                                                selectedIndex = 5
                                            }
                                            
                                        })
                            })
                        
                    }
                        
                    if payOnPickup == "yes" && updateOrderPayment.viewStage == "1"{
                            Button(action: {
                                updateOrderPayment.viewStage = "2"
                                paymentStatus = "approved"
                                paymentResponse = "Order successfull."
                                updateOrderPayment.updateOrder(txnReference: self.txnReference, paymentStatus: "pay_on_pickup", paymentResponse: "User will pay on pickup", paymentMethod: "PAY-ON-PICKUP")
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
                        SettingsLogoutView(icon: "We hope you benefit and enjoy this service at least half as much as we love providing the service to you.",  name: "")
                    }
                }
            } // SCROLLVIEW
            .padding(.horizontal, 20)
    }
}

struct FinalPriceView_Previews: PreviewProvider {
    static var previews: some View {
        FinalPriceView(selectedIndex: .constant(2), payOnline: "yes", payOnPickup:"yes", originalPrice: "$10", discountPercentage: "20%", discountAmount: "$2", priceFinal: "$8", priceFinalLong: "000000000010", txnReference: "Test Transaction", merchantId: "merchantId", merchantApiUser: "merchantApiUser", merchantApiKey: "merchantApiKey", returnUrl: "returnUrl", txnNarration: "txnNarration", userEmail: "userEmail", finalPriceIos: "000000000010", viewStage: "", paymentResponse: "", merchantTestApiKey: "merchantTestApiKey", paymentStatus: "")
    }
}


class updateOrderPaymentHttp: ObservableObject {
    @Published var requestOngoing = false;
    @Published var requestResponseStatus = "";
    @Published var requestMessage = "";
    @Published var viewStage = "1";
    
    
    func updateOrder(txnReference: String, paymentStatus: String, paymentResponse: String, paymentMethod: String) {
        
        self.requestOngoing = true
        guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/update-order-payment")
        else {
            print("Request failed 1")
            return
            
        }
        
        let body: [String: String] =
        [
            "order_id": txnReference,
            "order_payment_status": paymentStatus,
            "order_payment_details": paymentResponse,
            "order_payment_method": paymentMethod,
            "purge": "1",
            "app_type": "IOS",
            "app_version_code": MeMawwApp.app_version
        ]
        
        print("order_id: \(txnReference)")
        print("order_payment_status: \(paymentStatus)")
        print("order_payment_details: \(paymentResponse)")
        print("order_payment_method: \(paymentMethod)")
        
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
            self.viewStage = "3"
            
        } else {
            if let message = json["message"].string {
                //Now you got your value
                  print(message)
                    self.viewStage = "3"
                  
                  DispatchQueue.main.async {
                      self.requestMessage = message
                  }
              }
            }
          }
         }
        } catch  let error as NSError {
            DispatchQueue.main.async {
            self.requestOngoing = false
            self.viewStage = "3"
            self.requestMessage = "Failed to get messages"
                print("Request failed 3")
                print(error)
            }
    }
            
        }.resume()
    }
}
    
