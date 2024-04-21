//
//  OrdersView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/17/24.
//

import SwiftUI
import SwiftyJSON

struct OrdersView: View {
    // MARK: - PROPERTIES
    
    var orders: [OrderModel] = orderData
    var access_token: String = getSavedString("user_accesstoken");
    @ObservedObject var model: MyModel = MyModel()
    @ObservedObject var orders_http_manager = HttpGetOrders()
    

    // MARK: - BODY
    var body: some View {
        NavigationView {
            if orders_http_manager.requestMade {
                if (orders_http_manager.status == "success"){
                    List {
                        ForEach(orders_http_manager.received_orders) { item in
                            //NavigationLink(destination: ArticleDetailView(article: item)){
                                OrderRowView(order: item)
                                    .padding(.vertical, 4)
                            //}
                        }
                    }
                } else {
                    VStack {}
                        .alert(isPresented: $model.isValid, content: {
                        Alert(title: Text("Oops"),
                              message: Text("Something went awry"),
                              dismissButton: .default(
                                Text("Okay"))
                                {
                                    //print("do something")
                                    
                                })
                    })
                }
            } else {
                ProgressView()
                .onAppear(perform: {
                    print("Access Token request starting")
                    orders_http_manager.getArticles(user_accesstoken: access_token)
                })
            }
            
        } // NAVIGATION
    }
}


// MARK: - PREVIEW

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(orders: orderData)
    }
}

class HttpGetOrders: ObservableObject {

    @Published var requestMade = false
    @Published var message = ""
    @Published var status = "failed"
    @Published var received_orders: [OrderModel] = []

    func getArticles(user_accesstoken: String) {
        guard let url = URL(string: MeMawwApp.app_domain + "/memaww/public/api/v1/user/get-my-orders")
        else {
            print("Request failed 1")
            return
            
        }
        
    let body: [String: String] =
        [
            "app_type": "IOS",
            "app_version_code": MeMawwApp.app_version
        ]

    let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        let auth_pass = "Bearer " + user_accesstoken
        
        print("auth_pass:  \(auth_pass)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(auth_pass, forHTTPHeaderField: "Authorization")
        
        print("About to start request")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            print("data: \(data)")
            
    do {
    let json = try JSON(data: data)
    if let status = json["status"].string {
    //Now you got your value
    print("status: \(status)")
        
    DispatchQueue.main.async {
        self.requestMade = true
        self.status = status
        if status == "success" {
            print(status)
            if let items = json["data"].array {
                for item in items {
                    if let order_user_id_string = item["order_user_id_string"].string {
                        print(order_user_id_string)
                        if let all_items = item["all_items"].string {
                            print(all_items)
                            if let order_status = item["order_status"].int {
                                print(order_status)
                                if let order_status_message = item["order_status_message"].string {
                                        print(order_status_message)
                                        if let order_collection_location_raw = item["order_collection_location_raw"].string {
                                            print(order_collection_location_raw)
                                        if let order_final_amt_with_currency = item["order_final_amt_with_currency"].string {
                                            print(order_final_amt_with_currency)
                                            if let order_date = item["order_date"].string {
                                                print(order_date)
                                                
                                                if let order_user_id_string = item["order_user_id_string"].string {
                                                    print(order_user_id_string)
                                                    
                                                    
                                                    if let order_id_string = item["order_id_string"].string {
                                                        print(order_id_string)
                                                    
                                                    var type_color = "ColorLightRed"
                                                    if(order_status == 0){
                                                        type_color = "ColorLightGray";
                                                    } else if(order_status == 2){
                                                        type_color =  "ColorLightBlue";
                                                    } else if(order_status == 3){
                                                        type_color =  "ColorLightOrange";
                                                    } else if(order_status == 4){
                                                        type_color =  "ColorLightYellow";
                                                    } else if(order_status == 5){
                                                        type_color =  "ColorLightBlue";
                                                    } else if(order_status == 6){
                                                        type_color =  "ColorLightGreen";
                                                    }
                                                    
                                                    self.received_orders.append(OrderModel(
                                                        orderId: order_id_string,
                                                        orderAllItemsQuantity: all_items,
                                                        orderStatus: order_status,
                                                        orderStatusColor: type_color,
                                                        orderStatusMessage: order_status_message,
                                                        orderPickupLocation: order_collection_location_raw,
                                                        orderAmount: order_final_amt_with_currency,
                                                        orderDate: order_date,
                                                        orderUserId: order_user_id_string
                                                    ))
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
                      self.message = message
                  }
              }
            }
          }
         }
        } catch  let error as NSError {
            DispatchQueue.main.async {
            self.requestMade = true
            self.message = "Failed to get orders"
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

