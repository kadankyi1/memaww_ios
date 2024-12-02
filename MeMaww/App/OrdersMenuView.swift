//
//  OrdersMenuView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 11/27/24.
//

import SwiftUI
import SwiftyJSON

struct OrdersMenuView: View {
    @Binding var selectedIndex: Int
    @ObservedObject var checkUserSubscriptionManager = checkMySubscriptionHttp()
    
    var body: some View {
        
        VStack(){
            Button(action: {
                    selectedIndex = 5
            }, label: {
                OrdersMenuItemView(imageName: "distribution", menuTitle: "Start Pickup Request", menuDescription: "Fill Info | Apply Discounts | Check Pricing", showLoading: false)
                }
            )
            
            if checkUserSubscriptionManager.viewStage ==  1 {
                    Button(action: {
                            selectedIndex = 6
                    }, label: {
                        OrdersMenuItemView(imageName: "user", menuTitle: "Finding Subscriptions", menuDescription: "We are looking for your subscription...", showLoading: true)
                        }
                    ).onAppear{
                        checkUserSubscriptionManager.checkMySubscription(fcm_token: "")
                    }
            } else if checkUserSubscriptionManager.viewStage ==  2 {
                Button(action: {
                        selectedIndex = 6
                }, label: {
                    CurrentSubscriptionView(subscription_end_note: "Your subscription ends on Dec 11, 2024", pickupsDone: "2/4", pickupTime: "12:00, Sundays", itemsWashed: "100 /  Unlimited")
                    }
                )
            } else {
                Button(action: {
                        selectedIndex = 6
                }, label: {
                    OrdersMenuItemView(imageName: "subscriptionactive", menuTitle: "Buy Subscription", menuDescription: "Weekly Pickups | Unlimited Items | Save up to 80%", showLoading: false)
                    }
                )
            }
            
                Button(action: {
                        selectedIndex = 2
                }, label: {
                    OrdersMenuItemView(imageName: "plus", menuTitle: "Request Callback", menuDescription: "We Call | Take Your Order | No Discounts", showLoading: false)
                    }
                )
            
        }
        
    }
}

struct OrdersMenuView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersMenuView(selectedIndex: .constant(1))
    }
}

class checkMySubscriptionHttp: ObservableObject {
    @Published var requestOngoing = false
    @Published var requestMessage = ""
    @Published var requestStatusSuccessful = false
    @Published var viewStage = 1
    @Published var subscriptionInfo = ""
    @Published var subscriptionPickupsDone = ""
    @Published var subscriptionPickupTime = ""
    @Published var subscriptionItemsWashed = ""
    
    
    func checkMySubscription(fcm_token: String) {
        
        self.requestOngoing = true
        guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/update-user-info")
        else {
            print("Request failed 1")
            return
            
        }
        
    let body: [String: String] =
        [
            "fcm_token" : fcm_token,
            "fcm_type" : "IPHONE",
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
            //print("response: \(response)")
            print("data: \(data)")
            
    do {
    let json = try JSON(data: data)
    if let status = json["status"].string {
    //Now you got your value
        print("status 1: \(status)")
        print("status 1: \(status)")
        
    DispatchQueue.main.async {
        self.requestOngoing = false
        if status == "success" {
            if let subscriptionInfo = json["subscription"]["subscription_info"].string {
                self.subscriptionInfo = subscriptionInfo
                print("subscriptionInfo: \(self.subscriptionInfo)")
                
                if let subscriptionPickupsDone = json["subscription"]["pickups_count"].string {
                    self.subscriptionPickupsDone = subscriptionPickupsDone
                    print("subscriptionPickupsDone: \(self.subscriptionPickupsDone)")
                    
                    if let subscriptionPickupTime = json["subscription"]["pickup_final_time"].string {
                        self.subscriptionPickupTime = subscriptionPickupTime
                        print("subscriptionPickupTime: \(self.subscriptionPickupTime)")

                        if let subscriptionItemsWashed = json["subscription"]["items_washed_info"].string {
                            self.requestStatusSuccessful = true
                            self.subscriptionItemsWashed = subscriptionItemsWashed
                            print("subscriptionItemsWashed: \(self.subscriptionItemsWashed)")
                            self.viewStage = 2
                        }
                                                                            
                    }
                }
            }
            
        } else {
            if let message = json["message"].string {
                //Now you got your value
                print("message: " + message)
                self.viewStage = 3
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
            self.viewStage = 3
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
