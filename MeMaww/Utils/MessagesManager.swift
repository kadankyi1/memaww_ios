//
//  MessagesManager.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/22/24.
//

import Foundation
import SwiftyJSON

class MessagesManager: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageId: String = ""
    
    
    // On initialize of the MessagesManager class, get the messages from Firestore
    init() {
        //getMessages()
    }

    // Read message from Firestore in real-time with the addSnapShotListener
    func getMessages() {
        guard let url = URL(string: MeMawwApp.app_domain + "/memaww/public/api/v1/user/get-my-messages")
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
        
        let auth_pass = "Bearer " + getSavedString("user_accesstoken");
        
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
    print("status: \(status)")
        
    DispatchQueue.main.async {
        if status == "success" {
            print(status)
            if let items = json["data"].array {
                for item in items {
                    if let message_id_string = item["message_id_string"].string {
                        print(message_id_string)
                        if let message_text = item["message_text"].string {
                            print(message_text)
                            if let message_sender_user_id = item["message_sender_user_id"].string {
                                print(message_sender_user_id)
                                if let message_received = item["message_received"].bool {
                                        print(message_received)
                                        if let timestamp = item["timestamp"].string {
                                            print(timestamp)
                                            self.messages.append(Message(
                                                //id: message_id_string,
                                                text: message_text,
                                                received: message_received,
                                                timestamp: timestamp
                                            ))
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
                  
              }
            }
          }
         }
        } catch  let error as NSError {
                print("Request failed 3")
                print(error)
    }
            
        }.resume()

    }
    
    
    // Add a message in Firestore
    func sendMessage(text: String) {
        
            guard let url = URL(string: MeMawwApp.app_domain + "/memaww/public/api/v1/user/send-message")
            else {
                print("Request failed 1")
                return
            }
            
        let body: [String: String] =
            [
                "message": text,
                "app_type": "IOS",
                "app_version_code": MeMawwApp.app_version
            ]

        let finalBody = try! JSONSerialization.data(withJSONObject: body)
            
            let auth_pass = "Bearer " + getSavedString("user_accesstoken");
        
        print("auth_pass:  \(auth_pass)")
        print("body:  \(body)")
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
                print("status: \(status)")
            
            }
        } catch  let error as NSError {
                print("Request failed 3")
                print(error)
        }
                
            }.resume()
    }
}

 
