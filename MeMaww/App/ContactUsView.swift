//
//  ContactUsView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/19/24.
//

import SwiftUI
import SwiftyJSON


struct ContactUsView: View {
    // MARK: - PROPERTIES
    
    //@StateObject var messagesManager = MessagesManager()
    var messages: [Message] = messageData
    var access_token: String = getSavedString("user_accesstoken");
    @ObservedObject var model: MyModel = MyModel()
    @ObservedObject var messages_http_manager = HttpGetmessages()
    @State private var message = ""

    // MARK: - BODY
    var body: some View {
        VStack {
            VStack {
            TitleRow()
            if messages_http_manager.requestMade {
                if (messages_http_manager.status == "success"){
                             ScrollViewReader { proxy in
                                ScrollView {
                                    ForEach(messages_http_manager.received_messages, id: \.id) { message in
                                        MessageBubble(message: message)
                                    }
                                    /*
                                    ForEach(messages_http_manager.received_messages) { item in
                                        MessageBubble(message: item)
                                    }
                                    */
                                    
                                    Text("").id("bottomID")
                                }.onAppear{
                                    withAnimation{
                                        // scrolling to the text value present at bottom
                                        proxy.scrollTo("bottomID")
                                    }
                                }
                                .padding(.top, 10)
                                .background(.white)
                                .cornerRadius(30, corners: [.topLeft, .topRight]) // Custom cornerRadius modifier added in Extensions file
                                
                                .onChange(of: messages_http_manager.lastMessageId) { id in
                                    // When the lastMessageId changes, scroll to the bottom of the conversation
                                    withAnimation {
                                        proxy.scrollTo(id, anchor: .bottom)
                                    }
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
                    messages_http_manager.getArticles(user_accesstoken: access_token)
                })
            }
                
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("ColorMeMawwBlueDark"))
        
            if (messages_http_manager.message_sent == "success"){
                VStack {}
                    .alert(isPresented: $model.isValid, content: {
                    Alert(title: Text("Message Sent"),
                          message: Text("We received your message. You will get a notification when we respond"),
                          dismissButton: .default(
                            Text("Okay"))
                            {
                                //print("do something")
                                messages_http_manager.message_sent = ""
                            })
                })
            }
            HStack {
                // Custom text field created below
                CustomTextField(placeholder: Text("Enter your message here"), text: $message)
                    .frame(height: 52)
                    .disableAutocorrection(true)

                Button {
                    messages_http_manager.sendMessage(text: message)
                    message = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color("ColorMeMawwBlueDark"))
                        .cornerRadius(50)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color("Gray"))
            .cornerRadius(50)
            .padding()
            
        } // VS
        
    }
}


// MARK: - PREVIEW

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsView(messages: messageData, access_token: "ssssss")
    }
}

class HttpGetmessages: ObservableObject {

    @Published var requestMade = false
    @Published var message = ""
    @Published var status = "failed"
    @Published var received_messages: [Message] = []
    @Published var lastMessageId = ""
    @Published var message_sent = ""
    

    func getArticles(user_accesstoken: String) {
        guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/get-my-messages")
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
    print("status 1: \(status)")
        
    DispatchQueue.main.async {
        self.requestMade = true
        self.status = status
        if status == "success" {
            print(status)
            if let items = json["data"].array {
                for item in items {
                    if let message_id_string = item["message_id_string"].string {
                        print(message_id_string)
                        if let message_text = item["message_text"].string {
                            print(message_text)
                                if let message_received = item["message_received"].bool {
                                        print(message_received)
                                        if let timestamp = item["nice_date"].string {
                                            print(timestamp)
                                            self.lastMessageId = message_id_string
                                            self.received_messages.append(Message(
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
            self.message = "Failed to get messages"
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
    
    
    // Add a message in Firestore
    func sendMessage(text: String) {
        
            guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/send-message")
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
            if status == "success" {
                print(status)
                self.message_sent = "success"
                if let items = json["data"].array {
                    for item in items {
                        if let message_id_string = item["message_id_string"].string {
                            print(message_id_string)
                            if let message_text = item["message_text"].string {
                                print(message_text)
                                    if let message_received = item["message_received"].bool {
                                            print(message_received)
                                            if let timestamp = item["nice_date"].string {
                                                print(timestamp)
                                                self.lastMessageId = message_id_string
                                                self.received_messages.append(Message(
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
        } catch  let error as NSError {
                print("Request failed 3")
                print(error)
        }
                
      }.resume()
    }
}



/*
struct ContactUsView: View {
    @StateObject var messagesManager = MessagesManager()
    
    var body: some View {
        VStack {
            VStack {
                TitleRow()
                
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(messagesManager.messages, id: \.id) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight]) // Custom cornerRadius modifier added in Extensions file
                    .onChange(of: messagesManager.lastMessageId) { id in
                        // When the lastMessageId changes, scroll to the bottom of the conversation
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color("Peach"))
            
            MessageField()
                .environmentObject(messagesManager)
        }
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsView()
    }
}
*/
