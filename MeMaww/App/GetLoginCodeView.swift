//
//  GetLoginCodeView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/17/24.
//

import SwiftUI
import SwiftyJSON

struct GetLoginCodeView: View {
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 3)
    @State private var name = Array<String>.init(repeating: "", count: 3)
    @State private var email_address: String = ""
    //@State private var showLoginButton: Bool = true
    @ObservedObject var manager_HttpGetLoginCode = HttpGetLoginCode()
    @Binding var currentStage: String
        
        
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
            Text(" Tafarri ")
                .foregroundColor(Color("ColorMeMawwBlueDark"))
                .font(.custom("splashfont", size: 100))
                .padding(.bottom, 150)
            
            if (manager_HttpGetLoginCode.requestMade == "0") {
                Text("Enter your email address to receive a login code")
                .padding(.horizontal, 10)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("ColorMeMawwBlueDark"))
                
                TextField("Email", text: $email_address).textFieldStyle(RoundedBorderTextFieldStyle.init())
                    .scaleEffect(x: 1, y: 1, anchor: .center)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 10)
                    .background(GeometryGetter(rect: $kGuardian.rects[0]))
                
                
                    Button(action: {
                        print("\(self.email_address)")
                        manager_HttpGetLoginCode.getLoginCode(user_email: self.email_address)
                    }) {
                        HStack (spacing: 8) {
                            Text("Get Code")
                                .foregroundColor(Color("ColorMeMawwBlueDark"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .foregroundColor(Color("ColorMeMawwBlueDark"))
                    } //: BUTTON
                    .accentColor(Color("ColorMeMawwBlueDark"))
                    .background(Color("ColorMeMawwBlueDark"))
                    .cornerRadius(20)
                    .padding(.bottom, 50)
            } // MARK: - if manager_HttpGetLoginCode.requestMade
            
            else if (manager_HttpGetLoginCode.requestMade == "1") {
                    ProgressView()
            }
            
            else if (manager_HttpGetLoginCode.requestMade == "2") {
                ProgressView()
                    .onAppear(perform: {
                        self.currentStage = "LoginView"
                    })
            }
            
            
        } // MARK - VSTACK
    }
}

struct GetLoginCodeView_Previews: PreviewProvider {
    static var previews: some View {
        GetLoginCodeView(currentStage: .constant("GetLoginCodeView"))
    }
}

class HttpGetLoginCode: ObservableObject {
    @Published var requestMade = "0" // no change
    
    func getLoginCode(user_email: String) {
        requestMade = "1" // started
        guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/send-login-code") else { return }

        let body: [String: String] = ["user_email": user_email, "app_type": "ios", "app_version_code": MeMawwApp.app_version]
        print(body)

        let finalBody = try! JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            print(data)
            do {
                let json = try JSON(data: data)
                if let status = json["status"].string {
                    print(status)// success
                    DispatchQueue.main.async {
                        if status == "success" {
                            self.requestMade = "2" // success
                            //LoginView.currentStage = "MainView"
                            //manager_HttpGetLoginCode.requestMade = "4"
                            
                            saveTextInStorage("user_email", user_email)
                        } else {
                            self.requestMade = "3" // fail
                        }
                    }
                }
            } catch  let error as NSError {
                DispatchQueue.main.async {
                    self.requestMade = "3" // fail
                }
            }
            
        }.resume()
    }
}

