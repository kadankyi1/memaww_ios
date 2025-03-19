//
//  NotificationsView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/17/24.
//

import SwiftUI
import SwiftyJSON

struct NotificationsView: View {
    // MARK: - PROPERTIES
    
    @Binding var selectedIndex: Int
    var orders: [OrderModel] = orderData
    var access_token: String = getSavedString("user_accesstoken");
    @ObservedObject var model: MyNotificationModel = MyNotificationModel()
    @ObservedObject var notifications_http_manager = HttpGetNotifications()
    

    // MARK: - BODY
    var body: some View {
            if notifications_http_manager.requestMade {
                if (notifications_http_manager.status == "success"){
                    List {
                        ForEach(notifications_http_manager.my_notifications) { item in
                                NotificationsListItemView(notification: item)
                                    //.padding(.vertical, 4)
                            
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
                VStack(){
                    
                Spacer()
                ProgressView()
                .onAppear(perform: {
                    print("Access Token request starting")
                    notifications_http_manager.getNotifications(user_accesstoken: access_token)
                })
                Spacer()
            }
        }
        
    }
}

class MyNotificationModel: ObservableObject {
    @Published var isValid: Bool = false

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.isValid = true
        }
    }
}

// MARK: - PREVIEW

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView(selectedIndex: .constant(7))
    }
}

class HttpGetNotifications: ObservableObject {

    @Published var requestMade = false
    @Published var message = ""
    @Published var status = "failed"
    @Published var my_notifications: [NotificationModel] = []

    func getNotifications(user_accesstoken: String) {
        guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/get-my-notifications")
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
                    if let notification_title = item["notification_title"].string {
                        print(notification_title)
                        if let notification_body = item["notification_body"].string {
                            print(notification_body)
                            if let notification_date = item["notification_date"].string {
                                print(notification_date)
                                
                                    self.my_notifications.append(NotificationModel(notification_title: notification_title, notification_body: notification_body, notification_date: notification_date))
                                
                            }
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
            self.message = "Failed to get notifications"
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

