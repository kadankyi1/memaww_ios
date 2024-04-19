//
//  ContactUsView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/19/24.
//

import SwiftUI
import SwiftyJSON

struct ContactUsView: View {
    // MARK: -- PROPERTIES
    
    @State var showsAlert = false
    var textfield_msg: String
    @State private var isAnimatingImage: Bool = false
    @ObservedObject var request_manager_send_request = SendMessageRequestHttpAuth()
    @State var text: String = "Type here."
    var access_token: String = getSavedString("user_accesstoken");
    @ObservedObject var model: MyModel = MyModel()
    @Binding var currentStage: String
    @State private var user_access_token: String = getSavedString("user_accesstoken")
    @State private var user_phone: String = getSavedString("user_phone")
    
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .center, spacing: 20){
                    // HEADER
                    /*
                     ZStack {
                        /*
                         LinearGradient(gradient: Gradient(colors: [Color("ColorPrimaryBlue"), Color("ColorArticleHeraldOfGlory")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                         */
                        
                        Image("supporttopic")
                            .resizable()
                            .shadow(radius: 4)
                            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 250, idealHeight: 300, maxHeight: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                    }
                    .frame(height: 200)
                    .onAppear(){
                        withAnimation(.easeOut(duration: 0.5)){
                            isAnimatingImage = true
                        }
                    }
                     */
                    
                    
                    VStack(alignment: .leading, spacing: 20){
                        
                        // TITLE
                        GroupBox(label: Text("Tell us if you have any issues or ideas.").fontWeight(.heavy)){}
                        Divider().padding(.vertical, 2)
                        // DESCRIPTION
                        ZStack {
                            TextEditor(text: $text)
                            .foregroundColor(.secondary)
                            //.background(.gray)
                            
                            // <- This will solve the issue if it is in the same ZStack
                            Text(text)
                                .opacity(0)
                                .padding(.all, 8)
                        }
                        .frame(width: .infinity, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        if request_manager_send_request.showButton {
                            Button(action: {
                                print("access_token \(access_token)")
                                    request_manager_send_request.sendMessage(user_accesstoken: access_token, message_text: text)
                            }) {
                                HStack (spacing: 8) {
                                    Text("SEND")
                                        .foregroundColor(Color.white)
                                }
                                .padding(.horizontal, 50)
                                .padding(.vertical, 10)
                                .foregroundColor(Color("ColorMeMawwBlueDark"))
                            } //: BUTTON
                            .accentColor(Color("ColorMeMawwBlueDark"))
                            .background(Color("ColorMeMawwBlueDark"))
                            .cornerRadius(20)
                            .padding(.bottom, 50)
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            if request_manager_send_request.requestMade {
                                VStack {}
                                    .alert(isPresented: $model.isValid, content: {
                                    Alert(title: Text("Reply"),
                                          message: Text(request_manager_send_request.message),
                                          dismissButton: .default(
                                            Text("Okay"))
                                            {
                                                //print("do something")
                                                
                                            })
                                })
                            }
                        } else {
                            ProgressView()
                                .padding(.horizontal, 150)
                        }
                        
                        
                               
                    } //: VSTACK
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    .frame(maxWidth: 640, alignment: .center)
                    Text(user_phone)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 200)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("ColorMeMawwBlueDark"))
                } //: VSTACK
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
            } //: SCROLLVIEW
            .edgesIgnoringSafeArea(.top)
        } //: NAVIGATION
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsView(textfield_msg: "Type your testimony here", currentStage: .constant("ContactUsView"))
    }
}


class MyModel: ObservableObject {
    @Published var isValid: Bool = false

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.isValid = true
        }
    }
}

class SendMessageRequestHttpAuth: ObservableObject {

    @Published var requestMade = false
    @Published var showButton = true
    @Published var message = ""
    @Published var showAlert = false
        
    func sendMessage(user_accesstoken: String, message_text: String) {
        self.showButton = false
        guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/send-message") else { return }

        let body: [String: String] = ["message_text": message_text]

        let finalBody = try! JSONSerialization.data(withJSONObject: body)

        let auth_pass = "Bearer " + user_accesstoken
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(auth_pass, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            print("data")
            print(data)
            do {
                let json = try JSON(data: data)
                if let message = json["message"].string {
                    //Now you got your value
                      print(message)
                      DispatchQueue.main.async {
                          self.message = message
                          self.showButton = true
                          self.requestMade = true
                      }
                }
            } catch  let error as NSError {
                DispatchQueue.main.async {
                    self.message = "Failed to send"
                    self.showButton = true
                    self.requestMade = true
                }
            }
            
            
        }.resume()
    }
}
