//
//  ProfileView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/19/24.
//

import SwiftUI
import SwiftyJSON

struct ProfileView: View {
    // MARK: -- PROPERTIES
    @Binding var currentStage: String
    var user_name: String
    var user_phone: String
    var user_address: String
    var user_email: String
    @State private var isShowingDialog = false
    @ObservedObject var deleteAccountHttpManager = deleteAccountHttp()
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: -- BODY
    var body: some View {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20){
                    // MARK: -- SECTION 2
                    GroupBox(){
                        SettingsRowView(icon: "people", name: user_name)
                        Divider().padding(.vertical, 2)
                        SettingsRowView(icon: "smartphone", name: user_phone)
                        Divider().padding(.vertical, 2)
                        SettingsRowView(icon: "location", name: user_address)
                        Divider().padding(.vertical, 2)
                        SettingsRowView(icon: "email", name: user_email)
                        
                    }label: {}
                    Divider().padding(.vertical, 2)
                    GroupBox(){
                        
                        SettingsRowView(icon: "info", name: "", content: nil, linkLabel: "Service Policy", linkDestination: "https://memaww.com/privacy-policy")
                        Divider().padding(.vertical, 2)
                        Text("Call MeMaww | +233 53 881 5095")
                            .foregroundColor(Color.gray)
                    }
                    
                    Divider().padding(.vertical, 2)
                    
                    if deleteAccountHttpManager.viewStage == "1" {
                            GroupBox(){
                            Button("Delete My Account") {
                                isShowingDialog = true
                            }
                            .confirmationDialog(
                                "Are you sure you want to delete your account?",
                                isPresented: $isShowingDialog,
                                titleVisibility: .visible
                            ) {
                                Button("Confirm Account Deletion", role: .destructive) {
                                    // Handle empty trash action.
                                    deleteAccountHttpManager.deleteAccount()
                                }
                                Button("Cancel", role: .cancel) {
                                    isShowingDialog = false
                                }
                            }
                            //SettingsRowView(icon: "deleteuser", name: "Delete My Account")
                            Divider().padding(.vertical, 2)
                            Text("This action is irreversible")
                                .foregroundColor(Color.gray)
                        }
                } else if deleteAccountHttpManager.viewStage == "2"{
                    ProgressView()
                    
                } else if deleteAccountHttpManager.viewStage == "3"{
                    
                    ProgressView()
                        .onAppear(perform: {
                            saveTextInStorage("user_accesstoken", "")
                            saveTextInStorage("user_userid", "")
                            saveTextInStorage("user_phone", "")
                            saveTextInStorage("user_firstname", "")
                            saveTextInStorage("user_lastname", "")
                            saveTextInStorage("user_referralcode", "")
                            self.currentStage = "SignupView"
                            print("currentStage: \(self.currentStage)")
                        })
                } else {
                    GroupBox(){
                    Text("Deletion failed. Try again later")
                        .foregroundColor(Color.gray)
                    }
                }
                    Divider().padding(.vertical, 2)
                    // MARK: -- SECTION 1
                    GroupBox(){
                        SettingsLogoutView(icon: "We hope you benefit and enjoy this service at least half as much as we love providing the service to you.",  name: "")
                    }
                }
            } // SCROLLVIEW
            .padding(.horizontal, 20)
            .padding(.top, 30)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(currentStage: .constant("MainView"), user_name: "Mark Caw", user_phone: "02333333333", user_address: "Not Set", user_email: "Not Set")
    }
}



class deleteAccountHttp: ObservableObject {
    @Published var requestOngoing = false;
    @Published var requestResponseStatus = "";
    @Published var requestMessage = "";
    @Published var viewStage = "1";
    
    
    func deleteAccount() {
        
        self.viewStage = "2";
        self.requestOngoing = true
        guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/delete-my-account")
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
        
        let auth_pass = "Bearer " + getSavedString("user_accesstoken")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(auth_pass, forHTTPHeaderField: "Authorization")
        

        print("ACCOUNT DELETION ABOUT TO START REQUEST")
        URLSession.shared.dataTask(with: request) { (data, response, error) in guard let data = data else { return }
            print("data: \(data)")
            print("response: \(response)")
            print("error: \(error)")
            
    do {
    let json = try JSON(data: data)
    if let status = json["status"].string {
    //Now you got your value
    
    print("ACCOUNT DELETION  STATUS:  \(status)" )
        
    DispatchQueue.main.async {
        self.requestOngoing = false
        if status == "success" {
            self.requestResponseStatus = status
            self.viewStage = "3"
            deleteUserData()
            print("ACCOUNT DELETION  viewStage:  \(self.viewStage)" )
            
        } else {
            if let message = json["message"].string {
                //Now you got your value
                  print(message)
                    self.viewStage = "4"
                  
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
            self.viewStage = "4"
            self.requestMessage = "Failed to get messages"
                print("Request failed 4")
                print(error)
            }
    }
            
        }.resume()
    }
}
