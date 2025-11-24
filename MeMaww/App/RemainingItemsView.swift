//
//  RemainingItemsView.swift
//  MeMaww
//
//  Created by Kwaku Dankyi on 24/04/2025.
//

import SwiftUI
import SwiftyJSON

struct RemainingItemsView: View {
    // MARK: - PROPERTIES
    
    @Binding var selectedIndex: Int
    var access_token: String = getSavedString("user_accesstoken");
    @ObservedObject var model: MyNotificationModel = MyNotificationModel()
    @ObservedObject var remaining_items_http_manager = HttpGetRemainingItems()
    

    // MARK: - BODY
    var body: some View {
        if remaining_items_http_manager.viewStage ==  4 {
            
            VStack {}.alert(isPresented: $model.isValid, content: {
                Alert(title: Text("Update Required"),
                      message: Text("Please update your app"),
                      dismissButton: .default(
                        Text("Go To Store"))
                        {
                            //openURL(URL(string: "https://memaww.com/privacy-policy")!)
                            if let u = URL(string: "itms-apps://itunes.apple.com/app/id6740815969"),
                                  UIApplication.shared.canOpenURL(u) {
                                    UIApplication.shared.open(u)
                            }
                            //Link("Store", destination: URL(string: "https://memaww.com/privacy-policy")!)
                            
                        })
            })
        }
            if remaining_items_http_manager.requestMade {
                if (remaining_items_http_manager.status == "success"){
                    List {
                        ForEach(remaining_items_http_manager.remaining_items) { item in
                            RemainingItemsListItemView(remaining_item: item)
                                    //.padding(.vertical, 4)
                            
                        }
                    }
                } else {
                    VStack {}
                        .alert(isPresented: $model.isValid, content: {
                        Alert(title: Text("Oops"),
                              message: Text("No Details found"),
                              dismissButton: .default(
                                Text("Okay"))
                                {
                                    //print("do something")
                                    
                                })
                    })
                }
            } else {
                VStack(){
                    
                Spacer()
                ProgressView()
                .onAppear(perform: {
                    print("Access Token request starting")
                    remaining_items_http_manager.getRemainingItems(user_accesstoken: access_token)
                })
                Spacer()
            }
        }
        
    }
}


// MARK: - PREVIEW

struct RemainingItemsView_Previews: PreviewProvider {
    static var previews: some View {
        RemainingItemsView(selectedIndex: .constant(7))
    }
}

class HttpGetRemainingItems: ObservableObject {

    @Published var requestMade = false
    @Published var message = ""
    @Published var status = "failed"
    @Published var viewStage = 1
    @Published var remaining_items: [RemainingItemsModel] = []

    func getRemainingItems(user_accesstoken: String) {
        guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/get-remaining-laundry")
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
            print("data getRemainingItems: \(data)")
            
    do {
    let json = try JSON(data: data)
    if let status = json["status"].string {
    //Now you got your value
    print("status: \(status)")
        
    DispatchQueue.main.async {
        self.requestMade = true
        self.status = status
        if status == "update"{
            self.viewStage = 4
            print("viewStage 444: \(self.viewStage)")
        } else if status == "success" {
            print(status)
            if let items = json["data"].array {
                for item in items {
                        if let remaining_items_body = item["remaining_laundry_description"].string {
                            print(remaining_items_body)
                            if let remaining_items_date = item["remaining_laundry_date"].string {
                                print(remaining_items_date)
                                
                                self.remaining_items.append(RemainingItemsModel(remaining_items_body: remaining_items_body, remaining_items_date: remaining_items_date))
                                
                            }
                        }
                }
            }
        } else {
            if let message = json["message"].string {
                //Now you got your value
                  print(message)
                  
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
            self.message = "Failed to get data"
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

