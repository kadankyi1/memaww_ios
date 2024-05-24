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
    @Binding var currentStage: String
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
    @ObservedObject var model: MyModel = MyModel()
    @State var viewStage: String = "1"
    @State var paymentResponse: String = ""
    var merchantTestApiKey: String
    @State var paymentStatus: String = ""
    @ObservedObject var updateOrderPayment = updateOrderPaymentHttp()
    
    
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
                        
                        
                        if payOnline == "yes" && updateOrderPayment.viewStage == "1"{
                            Button(action: {
                                updateOrderPayment.viewStage = "2"
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
                                //self.priceFinalLong
                                checkout.initCheckout(transId:self.txnReference, amount: "000000000010", desc: self.txnNarration, customerEmail: userEmail, paymentMethod: "momo", paymentCurrency: "GHS", callback: { string,error  in
                                    ///////////////////////////////////////
                                    ///////////////////////////////////////
                                    ///////////////////////////////////////
                                    ///////////////////////////////////////
                                    print("PAYMENT RESULT START")
                                    print(string ?? "Payment error occurred")
                                    
                                    let payment_status = string? ["status"] as! String
                                    paymentStatus = payment_status
                                    let payment_reason = string? ["reason"] as! String
                                    paymentResponse = payment_reason
                                        
                                    print("PAYMENT STATUS: " + paymentResponse)
                                    
                                    print("PAYMENT RESULT END")
                                    ///////////////////////////////////////
                                    ///////////////////////////////////////
                                    ///////////////////////////////////////
                                    
                                    updateOrderPayment.updateOrder(txnReference: self.txnReference, paymentStatus: paymentStatus, paymentResponse: paymentResponse, paymentMethod: "PaySwitch")
                                
                                    
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
                                .onAppear(perform: {
                                    //print("Access Token request starting")
                                    //messages_http_manager.getArticles(user_accesstoken: access_token)
                                })
                            
                        }
                        
                        if updateOrderPayment.viewStage == "3"{ // SHOW PAYMENT UPDATE AND CLOSE PAGE
                            
                            VStack {}
                                .alert(isPresented: $model.isValid, content: {
                                Alert(title: Text("Order"),
                                      message: Text(paymentResponse),
                                      dismissButton: .default(
                                        Text("Okay"))
                                        {
                                            if paymentStatus == "approved" ||  paymentStatus == "pay_on_pickup" {
                                                selectedIndex = 0
                                                print("PAYMENT APPROVED: GONE TO ORDERS TAB NUMBERED: \(selectedIndex)")
                                            } else {
                                                
                                            }
                                            
                                        })
                            })
                        
                    }
                        
                    if payOnPickup == "yes" && updateOrderPayment.viewStage == "1"{
                            Button(action: {
                                updateOrderPayment.viewStage = "2"
                                paymentStatus = "pay_on_pickup"
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
        FinalPriceView(currentStage:  .constant("MainView"), selectedIndex: .constant(2), payOnline: "yes", payOnPickup:"yes", originalPrice: "$10", discountPercentage: "20%", discountAmount: "$2", priceFinal: "$8", priceFinalLong: "000000000010", txnReference: "Test Transaction", merchantId: "merchantId", merchantApiUser: "merchantApiUser", merchantApiKey: "merchantApiKey", returnUrl: "returnUrl", txnNarration: "txnNarration", userEmail: "userEmail", viewStage: "", paymentResponse: "", merchantTestApiKey: "merchantTestApiKey", paymentStatus: "")
    }
}


class updateOrderPaymentHttp: ObservableObject {
    @Published var requestOngoing = false;
    @Published var requestResponseStatus = "";
    @Published var requestMessage = "";
    @Published var viewStage = "1";
    
    
    func updateOrder(txnReference: String, paymentStatus: String, paymentResponse: String, paymentMethod: String) {
        
        self.requestOngoing = true
        guard let url = URL(string: MeMawwApp.app_domain + "/memaww/public/api/v1/user/update-order-payment")
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
                  print(status)
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
    
