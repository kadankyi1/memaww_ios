//
//  OrdersMenuItemView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 11/28/24.
//
import Foundation
import CoreLocation
import SwiftUI
import SwiftyJSON

struct SubscriptionView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @State var stepper: Int = 0
    
    @State private var numOfPeople = 1
    @State private var numOfMonths = 1
    
    @State private var pickupLocationFieldToggle = false
    @State private var pickupLocationGPS = ""
    @State private var pickupLocation = ""
    @State private var pickupLocationFinal = ""
    @State private var pickupDay = ""
    @State private var pickupTime = ""
    @State private var serviceType = ""
    
    @State var shouldShowModal = false
    
    @State private var specialInstructions = ""
    @State private var discountCode = ""

    @ObservedObject var getPriceManager = getSubscriptionPriceHttp()
    @Binding var selectedIndex: Int
    
    @State private var lastSelectedTimeIndex: Int?
    @State var allotedPickupTimes = ["7:00","12:00","16:00"] //Here Add Your data
    
    @State private var lastSelectedDayIndex: Int?
    @State var allotedPickupDays = ["Saturday","Sunday","Monday", "Tuesday", "Wednesday", "Thursady", "Friday"] //Here Add Your data
    
    @State private var lastSelectedServiceIndex: Int?
    @State var allotedServiceTypes = ["Wash And Fold","Wash And Iron","Just Iron"] //Here Add Your data
    
    var body: some View {
        
        NavigationView {
                VStack(spacing: 0) {
                    if !getPriceManager.requestOngoing {
                        if getPriceManager.requestStatusSuccessful {
                            NavigationLink(destination: SubscriptionFinalPriceView(selectedIndex:  Binding(projectedValue: $selectedIndex), originalPrice: getPriceManager.subscription_price, priceFinal:  getPriceManager.subscription_price_ios, priceFinalLong:  getPriceManager.subscription_price, txnReference:  getPriceManager.txn_reference, merchantId: getPriceManager.merchant_id, merchantApiUser: getPriceManager.merchant_api_user, merchantApiKey: getPriceManager.merchant_api_key, returnUrl: getPriceManager.return_url, txnNarration: getPriceManager.txn_narration, userEmail: getPriceManager.user_email, userCurrency: getPriceManager.currency_symbol, subscriptionPersons: String(self.numOfPeople), subscriptionMonths: String(self.numOfMonths), subscriptionPickupTime: self.pickupTime, subscriptionPickupLocation: self.pickupLocation, subscriptionPackageDescription1: getPriceManager.packageinfo1, subscriptionPackageDescription2: getPriceManager.packageinfo2, subscriptionPackageDescription3: getPriceManager.packageinfo3, subscriptionPackageDescription4: getPriceManager.packageinfo4, subscriptionCountryId: getPriceManager.subscription_country_id, merchantTestApiKey: getPriceManager.merchant_test_api_key, subscriptionServiceType: serviceType), isActive: $getPriceManager.requestStatusSuccessful){ }
                        } else {
                            Form {
                                Section(header: Text("Pickup & Drop-Off")){
                                    
                                    HStack(){
                                        TextField("Pickup Location", text: $pickupLocation)
                                            .disabled(pickupLocationFieldToggle)
                                            .onAppear {
                                                viewModel.checkIfLocationServicesIsEnabled()
                                                print("Checked for permission")
                                            }
                                        Spacer()
                                        Button(action: {
                                            print("viewModel.region 3")
                                            print(viewModel.region)
                                            print(viewModel.region.center.latitude)
                                            print(viewModel.region.center.longitude)
                                            pickupLocationGPS = String(viewModel.region.center.latitude) + "," + String(viewModel.region.center.longitude)
                                            pickupLocation = "Current Location"
                                            pickupLocationFieldToggle = true
                                            print("viewModel.region 4")
                                        }, label: {
                                            Image("map")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 35, height: 35)
                                            //.padding(20)
                                        }
                                        )
                                    }
                                    PickerTextField(data: ["Saturday","Sunday","Monday", "Tuesday", "Wednesday", "Thursady", "Friday"],placeholder: "Saturday",lastSelectedIndex: self.$lastSelectedDayIndex)
                                        .padding()
                                        .frame(width: 300, height: 50)
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(10)
                                    
                                    PickerTextField(data: ["7am - 8am","12pm - 1pm","4pm-5pm"],placeholder: "7am - 8am",lastSelectedIndex: self.$lastSelectedTimeIndex)
                                        .padding()
                                        .frame(width: 300, height: 50)
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(10)
                                }
                            
                                Section(header: Text("Members")){
                                    Stepper("Members On Subscription: \(numOfPeople) ", value: $numOfPeople, in: 1...10)
                                }
                                
                                Section(header: Text("Service & Duration")){
                                    Stepper("Number of Months: \(numOfMonths) ", value: $numOfMonths, in: 1...12)
                                    
                                    PickerTextField(data: ["Wash And Iron", "Wash And Fold", "Just Iron"],placeholder: "Wash And Iron",lastSelectedIndex: self.$lastSelectedServiceIndex)
                                        .padding()
                                        .frame(width: 300, height: 50)
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(10)
                                }
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        pickupTime = allotedPickupTimes[lastSelectedTimeIndex ?? 0]
                                        pickupDay = allotedPickupDays[lastSelectedDayIndex ?? 0]
                                        serviceType = allotedServiceTypes[lastSelectedDayIndex ?? 1]
                                        if(pickupLocationGPS == ""){
                                            pickupLocationFinal = pickupLocation
                                        } else {
                                            pickupLocationFinal = pickupLocationGPS
                                        }
                                        print("numOfPeople: \(self.numOfPeople)")
                                        print("numOfMonths: \(self.numOfMonths)")
                                        
                                        print("pickupLocationGPS: \(self.pickupLocationGPS)")
                                        print("pickupLocationFinal: \(self.pickupLocationFinal)")
                                        print("pickupDay: \(self.pickupDay)")
                                        print("pickupTime: \(self.pickupTime)")
                                        print("service_type: \(self.serviceType)")
                                        
                                        getPriceManager.getPrice(num_of_ppl: String(self.numOfPeople), num_of_months: String(self.numOfMonths), pickup_day: pickupDay, pickup_time: self.pickupTime, pickup_location: pickupLocationFinal, service_type: self.serviceType)
                                    }) {
                                        HStack (spacing: 8) {
                                            Text("GET SUBSCRIPTION PRICE")
                                                .foregroundColor(Color.white)
                                        }
                                    } //: BUTTON
                                    .frame(width: 300, height: 50)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .padding(.bottom, 50)
                                    Spacer()
                                }
                                
                            } // END FORM
                        }
                    } else {
                        ProgressView()
                    }
                    
                    
                }
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
        } // END NAVIGATIONVIEW
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView(selectedIndex: .constant(1))
    }
}

class getSubscriptionPriceHttp: ObservableObject {
    @Published var requestOngoing = false;
    @Published var requestMessage = "";
    @Published var requestStatusSuccessful = false
    @Published var txn_info = ""
    @Published var txn_narration = ""
    @Published var txn_reference = ""
    @Published var merchant_id = ""
    @Published var merchant_api_user = ""
    @Published var merchant_api_key = ""
    @Published var return_url = ""
    @Published var subscription_price = ""
    @Published var subscription_price_ios = ""
    @Published var currency_symbol = ""
    @Published var packageinfo1 = ""
    @Published var packageinfo2 = ""
    @Published var packageinfo3 = ""
    @Published var packageinfo4 = ""
    @Published var subscription_country_id = ""
    @Published var merchant_test_api_key = ""
    @Published var user_email = ""
    
    
    func getPrice(num_of_ppl: String, num_of_months: String, pickup_day: String, pickup_time: String, pickup_location: String, service_type: String) {
        
        self.requestOngoing = true
        guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/get-subscription-pricing")
        else {
            print("Request failed 1")
            return
            
        }
        
    let body: [String: String] =
        [
            "subscription_max_number_of_people_in_home" : num_of_ppl,
            "subscription_number_of_months" : num_of_months,
            "subscription_pickup_day" : pickup_day,
            "subscription_pickup_time" : pickup_time,
            "subscription_pickup_location" : pickup_location,
            "subscription_service_type" : service_type,
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
            if let txn_info = json["txn_info"].string {
                self.txn_info = txn_info
                print("txn_info: \(self.txn_info)")
                
                if let txn_narration = json["txn_narration"].string {
                    self.txn_narration = txn_narration
                    print("txn_narration: \(self.txn_narration)")
                    
                    if let txn_reference = json["txn_reference"].string {
                        self.txn_reference = txn_reference
                        print("txn_reference: \(self.txn_reference)")
                        
                        if let merchant_id = json["merchant_id"].string {
                            self.merchant_id = merchant_id
                            print("merchant_id: \(self.merchant_id)")
                            
                            if let merchant_api_user = json["merchant_api_user"].string {
                                self.merchant_api_user = merchant_api_user
                                print("merchant_api_user: \(self.merchant_api_user)")
                                
                                if let merchant_api_key = json["merchant_api_key"].string {
                                    self.merchant_api_key = merchant_api_key
                                    print("merchant_api_key: \(self.merchant_api_key)")
                                    
                                    if let return_url = json["return_url"].string {
                                        self.return_url = return_url
                                        print("return_url: \(self.return_url)")
                                        
                                        if let currency_symbol = json["currency_symbol"].string {
                                            self.currency_symbol = currency_symbol
                                            print("currency_symbol: \(self.currency_symbol)")
                                            
                                            if let packageinfo1 = json["packageinfo1"].string {
                                                self.packageinfo1 = packageinfo1
                                                print("packageinfo1: \(self.packageinfo1)")
                                                
                                                if let packageinfo2 = json["packageinfo2"].string {
                                                    self.packageinfo2 = packageinfo2
                                                    print("packageinfo2: \(self.packageinfo2)")
                                                    
                                                    if let packageinfo3 = json["packageinfo3"].string {
                                                        self.packageinfo3 = packageinfo3
                                                        print("packageinfo3: \(self.packageinfo3)")
                                                        
                                                        if let packageinfo4 = json["packageinfo4"].string {
                                                            self.packageinfo4 = packageinfo4
                                                            print("packageinfo4: \(self.packageinfo4)")
                                                            
                                                            if let subscription_country_id = json["subscription_country_id"].string {
                                                                self.subscription_country_id = subscription_country_id
                                                                print("subscription_country_id: \(self.subscription_country_id)")
                                                                
                                                                if let user_email = json["user_email"].string {
                                                                    self.user_email = user_email
                                                                    print("user_email: \(self.user_email)")
                                                                    
                                                                    if let merchant_test_api_key = json["merchant_test_api_key"].string {
                                                                        self.merchant_test_api_key = merchant_test_api_key
                                                                        print("merchant_test_api_key: \(self.merchant_test_api_key)")
                                                                        
                                                                            if let subscription_price = json["subscription_price"].string {
                                                                                self.subscription_price = subscription_price
                                                                                print("subscription_price: \(self.subscription_price)")
                                                                                
                                                                                    if let subscription_price_ios = json["subscription_price_ios"].string {
                                                                                        self.requestStatusSuccessful = true
                                                                                        self.subscription_price_ios = subscription_price_ios
                                                                                        print("subscription_price_ios: \(self.subscription_price_ios)")
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
