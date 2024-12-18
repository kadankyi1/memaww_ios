//
//  StartOrderView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/22/24.
//

import SwiftUI
import SwiftyJSON

struct StartOrderView: View {
    @State var stepper: Int = 0
    @State private var pickupLocation = ""
    @State private var contactPhoneNumber = ""
    
    @State private var pickupTime = ""
    @State private var lastSelectedTimeIndex: Int?
    @State var allotedPickupTimes = ["7:00","12:00","16:00"] //Here Add Your data
    
    
    @State private var lightWeightWashAndFold = 0
    @State private var lightWeightWashAndIron = 0
    @State private var lightWeightJustIron = 0
    
    @State private var mediumWeightWashAndFold = 0
    @State private var mediumWeightWashAndIron = 0
    @State private var mediumWeightJustIron = 0
    
    @State private var bulkyItemsWashAndFold = 0
    @State private var bulkyItemsWashAndIron = 0
    
    @State var shouldShowModal = false
    
    @State private var specialInstructions = ""
    @State private var discountCode = ""

    @ObservedObject var getPriceManager = getPriceHttp()
    @Binding var selectedIndex: Int
    
    var body: some View {
        
        NavigationView {
                VStack(spacing: 0) {
                    //CallBackRequestView()
                        //.padding()
                        //.frame(width: .infinity, height: 50)
                        //.background(Color("ColorMeMawwBlueDark"))
                    if !getPriceManager.requestOngoing {
                        if getPriceManager.requestStatusSuccessful {
                            NavigationLink(destination:
                                            FinalPriceView(currentStage: .constant("MainView"), selectedIndex:  Binding(projectedValue: $selectedIndex), payOnline:  getPriceManager.payOnline, payOnPickup:  getPriceManager.payOnPickup, originalPrice:  getPriceManager.originalPrice, discountPercentage:  getPriceManager.discountPercentage, discountAmount:  getPriceManager.discountAmount, priceFinal:  getPriceManager.priceFinal,
                                                           priceFinalLong: getPriceManager.priceFinalLong, txnReference: getPriceManager.txnReference, merchantId: getPriceManager.merchantId, merchantApiUser: getPriceManager.merchantApiUser, merchantApiKey: getPriceManager.merchantApiKey, returnUrl: getPriceManager.returnUrl, txnNarration: getPriceManager.txnNarration, userEmail: getPriceManager.userEmail, finalPriceIos: getPriceManager.priceFinalIOS, viewStage: "1", paymentResponse: "", merchantTestApiKey: getPriceManager.merchantTestApiKey, paymentStatus: ""), isActive: $getPriceManager.requestStatusSuccessful){ }
                        } else {
                            Form {
                                Section(header: Text("Collection & DropOff")){
                                    TextField("Pickup Location", text: $pickupLocation)
                                    TextField("Contact Phone", text: $contactPhoneNumber)
                                    
                                    PickerTextField(data: ["7am - 8am","12pm - 1pm","4pm-5pm"],placeholder: "7am - 8am",lastSelectedIndex: self.$lastSelectedTimeIndex)
                                        .padding()
                                        .frame(width: 300, height: 50)
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(10)
                                }
                                Section(header: Text("Lightweight Items")){
                                    Stepper("Wash & Fold: \(lightWeightWashAndFold) items", value: $lightWeightWashAndFold, in: 0...100)
                                    Stepper("Wash & Iron: \(lightWeightWashAndIron) items", value: $lightWeightWashAndIron, in: 0...100)
                                    Stepper("Just & Iron: \(lightWeightJustIron) items", value: $lightWeightJustIron, in: 0...100)
                                }
                                Section(header: Text("Mediumweight Items")){
                                    Stepper("Wash & Fold: \(mediumWeightWashAndFold) items", value: $mediumWeightWashAndFold, in: 0...100)
                                    Stepper("Wash & Iron: \(mediumWeightWashAndIron) items", value: $mediumWeightWashAndIron, in: 0...100)
                                    Stepper("Just & Iron: \(mediumWeightJustIron) items", value: $mediumWeightJustIron, in: 0...100)
                                }
                                Section(header: Text("Bulky Items")){
                                    Stepper("Wash & Fold: \(bulkyItemsWashAndFold) items", value: $bulkyItemsWashAndFold, in: 0...100)
                                    Stepper("Wash & Iron: \(bulkyItemsWashAndIron) items", value: $bulkyItemsWashAndIron, in: 0...100)
                                }
                                Section(header: Text("Anything Else?")){
                                    TextField("Any Special Instructions", text: $specialInstructions)
                                    TextField("Discount Code", text: $discountCode)
                                }
                                
                                    Button(action: {
                                        pickupTime = allotedPickupTimes[lastSelectedTimeIndex ?? 0]
                                        print("collect_loc_raw: \(self.pickupLocation)")
                                        print("collect_loc_gps: EMPTY")
                                        print("collect_datetime: \(self.pickupTime)")
                                        print("contact_person_phone: \(self.contactPhoneNumber)")
                                        print("drop_loc_raw: EMPTY")
                                        print("drop_loc_gps: EMPTY")
                                        print("drop_datetime: EMPTY")
                                        print("smallitems_justwash_quantity: \(self.lightWeightWashAndFold)")
                                        print("smallitems_washandiron_quantity: \(self.lightWeightWashAndIron)")
                                        print("smallitems_justiron_quantity: \(self.lightWeightJustIron)")
                                        print("mediumitems_justwash_quantity: \(self.mediumWeightWashAndFold)")
                                        print("smallitems_washandiron_quantity: \(self.mediumWeightWashAndIron)")
                                        print("smallitems_justiron_quantity: \(self.mediumWeightJustIron)")
                                        print("bigitems_justwash_quantity: \(self.bulkyItemsWashAndFold)")
                                        print("bigitems_washandiron_quantity: \(self.lightWeightJustIron)")
                                        print("special_instructions: \(self.specialInstructions)")
                                        print("discount_code: \(self.discountCode)")
                                        
                                        getPriceManager.getPrice(collect_loc_raw: self.pickupLocation, collect_loc_gps: "", collect_datetime: self.pickupTime, contact_person_phone: self.contactPhoneNumber, drop_loc_raw: "", drop_loc_gps: "", drop_datetime: "", smallitems_justwash_quantity: String(self.lightWeightWashAndFold), smallitems_washandiron_quantity: String(self.lightWeightWashAndIron), smallitems_justiron_quantity: String(self.lightWeightJustIron), mediumitems_justwash_quantity: String(self.mediumWeightWashAndFold), mediumitems_washandiron_quantity: String(self.mediumWeightWashAndIron), mediumitems_justiron_quantity: String(self.mediumWeightJustIron), bigitems_justwash_quantity: String(self.bulkyItemsWashAndFold), bigitems_washandiron_quantity: String(self.bulkyItemsWashAndIron), special_instructions: self.specialInstructions, discount_code: self.discountCode)
                                    }) {
                                        HStack (spacing: 8) {
                                            Text("GET PRICE")
                                                .foregroundColor(Color.white)
                                        }
                                    } //: BUTTON
                                    .foregroundColor(.white)
                                    .frame(width: 300, height: 50)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .padding(.bottom, 50)
                                
                            } // END FORM
                        }
                    } else {
                        ProgressView()
                    }
                    
                    
                }
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
        } // END NAVIGATIONVIEW
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct StartOrderView_Previews: PreviewProvider {
    static var previews: some View {
        StartOrderView(selectedIndex: .constant(1))
    }
}

class getPriceHttp: ObservableObject {
    @Published var requestOngoing = false;
    @Published var requestMessage = "";
    @Published var requestStatusSuccessful = false
    @Published var payOnline = ""
    @Published var payOnPickup = ""
    @Published var originalPrice = ""
    @Published var discountPercentage = ""
    @Published var discountAmount = ""
    @Published var priceFinal = ""
    @Published var priceFinalIOS = ""
    @Published var txnReference = ""
    @Published var merchantId = ""
    @Published var merchantApiUser = ""
    @Published var merchantApiKey = ""
    @Published var returnUrl = ""
    @Published var priceFinalLong = ""
    @Published var txnNarration = ""
    @Published var userEmail = ""
    @Published var merchantTestApiKey = ""
    
    
    func getPrice(collect_loc_raw: String, collect_loc_gps: String, collect_datetime: String, contact_person_phone: String, drop_loc_raw: String, drop_loc_gps: String, drop_datetime: String, smallitems_justwash_quantity: String, smallitems_washandiron_quantity: String, smallitems_justiron_quantity: String,mediumitems_justwash_quantity: String, mediumitems_washandiron_quantity: String, mediumitems_justiron_quantity: String, bigitems_justwash_quantity: String, bigitems_washandiron_quantity: String, special_instructions: String, discount_code: String) {
        
        self.requestOngoing = true
        guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/request-collection")
        else {
            print("Request failed 1")
            return
            
        }
        
    let body: [String: String] =
        [
            "collect_loc_raw" : collect_loc_raw,
            "collect_loc_gps" : collect_loc_gps,
            "collect_datetime" : collect_datetime,
            "contact_person_phone" : contact_person_phone,
            "drop_loc_raw" : drop_loc_raw,
            "drop_loc_gps" : drop_loc_gps,
            "drop_datetime" : drop_datetime,
            "smallitems_justwash_quantity" : smallitems_justwash_quantity,
            "smallitems_washandiron_quantity" : smallitems_washandiron_quantity,
            "smallitems_justiron_quantity" : smallitems_justiron_quantity,
            
            "mediumitems_justwash_quantity" : mediumitems_justwash_quantity,
            "mediumitems_washandiron_quantity" : mediumitems_washandiron_quantity,
            "mediumitems_justiron_quantity" : mediumitems_justiron_quantity,
            
            "bigitems_justwash_quantity" : bigitems_justwash_quantity,
            "bigitems_washandiron_quantity" : bigitems_washandiron_quantity,
            "special_instructions" : special_instructions,
            "discount_code" : discount_code,
            "app_type": "IOS",
            "app_version_code": MeMawwApp.app_version
        ]

    let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        let auth_pass = "Bearer " + getSavedString("user_accesstoken")
        
        print("auth_pass:  \(auth_pass)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(auth_pass, forHTTPHeaderField: "Authorization")
        
        print("About to start request")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            print("data: \(data)")
            
    do {
    let json = try JSON(data: data)
    if let status = json["status"].string {
    //Now you got your value
    print("status 1: \(status)")
        
    DispatchQueue.main.async {
        self.requestOngoing = false
        if status == "success" {
            if let pay_online = json["pay_online"].string {
                self.payOnline = pay_online
                print("payOnline: \(self.payOnline)")
                
                if let pay_on_pickup = json["pay_on_pickup"].string {
                    self.payOnPickup = pay_on_pickup
                    print("payOnPickup: \(self.payOnPickup)")
                    
                    if let original_price = json["original_price"].string {
                        self.originalPrice = original_price
                        print("originalPrice: \(self.originalPrice)")
                        
                        if let discount_percentage = json["discount_percentage"].string {
                            self.discountPercentage = discount_percentage
                            print("discountPercentage: \(self.discountPercentage)")
                            
                            if let discount_amount = json["discount_amount"].string {
                                self.discountAmount = discount_amount
                                print("discountAmount: \(self.discountAmount)")
                                
                                if let txn_reference = json["txn_reference"].string {
                                    self.txnReference = txn_reference
                                    print("txn_reference: \(self.txnReference)")
                                    
                                    if let merchant_id = json["merchant_id"].string {
                                        self.merchantId = merchant_id
                                        print("merchant_id: \(self.merchantId)")
                                        
                                        if let merchant_api_user = json["merchant_api_user"].string {
                                            self.merchantApiUser = merchant_api_user
                                            print("merchant_api_user: \(self.merchantApiUser)")
                                            
                                            if let merchant_api_key = json["merchant_api_key"].string {
                                                self.merchantApiKey = merchant_api_key
                                                print("merchant_api_key: \(self.merchantApiKey)")
                                                
                                                if let return_url = json["return_url"].string {
                                                    self.returnUrl = return_url
                                                    print("return_url: \(self.returnUrl)")
                                                    
                                                    if let price_final_no_currency_long = json["price_final_no_currency_long"].string {
                                                        self.priceFinalLong = price_final_no_currency_long
                                                        print("price_final_no_currency_long: \(self.priceFinalLong)")
                                                        
                                                        if let txn_narration = json["txn_narration"].string {
                                                            self.txnNarration = txn_narration
                                                            print("txn_narration: \(self.txnNarration)")
                                                            
                                                            if let user_email = json["user_email"].string {
                                                                self.userEmail = user_email
                                                                print("user_email: \(self.userEmail)")
                                                                
                                                                
                                                                if let merchant_test_api_key = json["merchant_test_api_key"].string {
                                                                    self.merchantTestApiKey = merchant_test_api_key
                                                                    print("merchant_test_api_key: \(self.merchantTestApiKey)")
                                                                    
                                                                    if let price_final = json["price_final"].string {
                                                                        self.priceFinal = price_final
                                                                        print("priceFinal: \(self.priceFinal)")
                                                                        
                                                                        if let price_final_ios = json["price_final_ios"].string {
                                                                            self.requestStatusSuccessful = true
                                                                            self.priceFinalIOS = price_final_ios
                                                                            print("priceFinalIOS: \(self.priceFinalIOS)")
                                                                        }
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }
                                                            
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                
                                                
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                            
                        }
                    }
                }
            }
            
        } else {
            if let message = json["message"].string {
                //Now you got your value
                  print(status)
                  
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
            self.requestStatusSuccessful = false
            self.requestMessage = "Failed to get messages"
                print("Request failed 3")
                print(error)
            }
    }
            
            /*
            let resData = try! JSONDecoder().decode(ServerMessage.self, from: data)
            print(resData)
            if resData.res == "correct" {
                DispatchQueue.main.async {
                    self.authenticated = true
                }
            }
             */
            
        }.resume()
    }
    
}
