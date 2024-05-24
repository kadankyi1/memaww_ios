//
//  MainView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/17/24.
//

import SwiftUI
import SwiftyJSON

struct MainView: View {
    @Binding var currentStage: String
    
    init(currentStage: Binding<String>) {
        self._currentStage = .constant("MainView")
        UITabBar.appearance().barTintColor = .systemBackground
        UINavigationBar.appearance().barTintColor = .systemBackground
    }
    
    //var access_token: String = getSavedString("user_accesstoken");
    @State var selectedIndex = 2
    @State var shouldShowModal = false
    @ObservedObject var updateContent = HttpUpdateContent()
    @State var now = Date()
    
    let tabBarImageNames = ["list", "invite", "plus", "question", "user"]
    let tabBarMenuNames = ["MyOrders", "Invite", "Start", "Support", "Profile"]
    
    var body: some View {
        /*
        var timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
            (_) in
            updateContent.update_content(user_accesstoken: getSavedString("user_accesstoken"));
        }
         */
        VStack(spacing: 0) {
            
            Text(" MeMaww ")
                .foregroundColor(Color(.black))
                .font(.custom("SweetSensationsPersonalUse", size: 30))
                .padding(.top, 5)
                
            
            ZStack {
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldShowModal, content: {
                        Button(action: {shouldShowModal.toggle()}, label: {
                            Text("Fullscreen cover")
                        })
                    
                })
                
                switch selectedIndex {
                case 0:
                    
                    OrdersView()
                case 1:
                    //OrdersView()
                    InviteView(currentStage: .constant("MainView"), referral_code: getSavedString("user_referralcode"))
                case 2:
                    StartOrderView(selectedIndex: Binding(projectedValue: $selectedIndex))
                    
                case 3:
                    ContactUsView()
                    
                case 4:
                    ProfileView(currentStage: .constant("MainView"), user_name: getSavedString("user_firstname") + " " + getSavedString("user_lastname"),  user_phone: getSavedString("user_phone"), user_address: "Not Set", user_email:  "Not Set")
                    
                    
                default:
                    NavigationView {
                        Text("Remaining tabs")
                        
                    }
                }
                
            }
            
//            Spacer()
            
            Divider()
                .padding(.bottom, 8)
            
            HStack {
                ForEach(0..<5) { num in
                    Button(action: {
                        
                        /*
                        if num == 2 {
                            shouldShowModal.toggle()
                            return
                        }
                        */
                        
                        selectedIndex = num
                        
                    }, label: {
                        Spacer()
                        
                        VStack {
                                 Image(tabBarImageNames[num])
                                    //.font(.system(size: 25, weight: .bold))
                                    .renderingMode(.template)
                                    .colorMultiply(.init(white: 0.8))
                                    //.foregroundColor(.red)
                                    .foregroundColor(selectedIndex == num ? Color(.black) : .init(white: 0.8))
                                Text(tabBarMenuNames[num])
                                .foregroundColor(selectedIndex == num ? Color(.black) : .init(white: 0.8))
                                    .font(.system(size: 12))
                            Spacer()
                        } // MARK: - VSTACK
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 55)
                    })
                    
                }
            } // MARK: - HSTACK
            
            
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(currentStage: .constant("MainView"))
    }
}


class HttpUpdateContent: ObservableObject {

    @Published var requestMade = false
    @Published var values_set = false
    @Published var showProgress = true

    func update_content(user_accesstoken: String) {
        guard let url = URL(string: "https://thegloryhub.fishpott.com//api/v1/admin/today/dasboard") else { return }

        let auth_pass = "Bearer " + user_accesstoken
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(auth_pass, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            print(data)
            do {
                let json = try JSON(data: data)
                if let status = json["status"].string {
                  //Now you got your value
                    print("UPDATED CONTENT")
                    print(status)
                    
                    DispatchQueue.main.async {
                        self.requestMade = true
                        if status == "success" {
                            print(status)
                            
                            if let notice_image_one = json["data"]["data"][0]["notice_image"].string {
                                //Now you got your value
                                saveTextInStorage("notice_image_one", notice_image_one)
                                print("note_image_one: \(notice_image_one)")
                              }
                            
                            if let notice_image_two = json["data"]["data"][1]["notice_image"].string {
                                //Now you got your value
                                saveTextInStorage("notice_image_two", notice_image_two)
                                print("notice_image_two: \(notice_image_two)")
                              }
                            
                            if let audio_id = json["audios"]["data"][0]["audio_id"].int {
                                //Now you got your value
                                saveTextInStorage("latest_audio_id", String(audio_id))
                                print("audio_id: \(audio_id)")
                                
                                if let audio_name = json["audios"]["data"][0]["audio_name"].string {
                                    //Now you got your value
                                    saveTextInStorage("latest_audio_name", audio_name)
                                    print("latest_audio_name: \(audio_name)")
                                    if let audio_description = json["audios"]["data"][0]["audio_description"].string {
                                        //Now you got your value
                                        saveTextInStorage("latest_audio_description", audio_description)
                                        print("latest_audio_description: \(audio_description)")
                                        
                                        if let audio_image = json["audios"]["data"][0]["audio_image"].string {
                                            //Now you got your value
                                            saveTextInStorage("latest_audio_image", audio_image)
                                            print("latest_audio_image: \(audio_image)")
                                            if let audio_mp3 = json["audios"]["data"][0]["audio_mp3"].string {
                                                //Now you got your value
                                                saveTextInStorage("latest_audio_mp3", audio_mp3)
                                                print("latest_audio_mp3: \(audio_mp3)")
                                                
                                                if let created_at = json["audios"]["data"][0]["created_at"].string {
                                                    //Now you got your value
                                                    saveTextInStorage("latest_audio_date", created_at)
                                                    print("latest_audio_date: \(created_at)")
                                                  }
                                              }
                                          } //AUDIO IMAGE
                                      }
                                  } // START FOR AUDIO NAME
                              } // END FOR AUDIO ID
                            
                            
                            if let video_id = json["videos"]["data"][0]["video_id"].int {
                                //Now you got your value
                                saveTextInStorage("latest_video1_id", String(video_id))
                                print("latest_video1_id: \(video_id)")
                                
                                if let video_name = json["videos"]["data"][0]["video_name"].string {
                                    //Now you got your value
                                    saveTextInStorage("latest_video1_name", video_name)
                                    print("latest_video1_name: \(video_name)")
                                    
                                    if let video_description = json["videos"]["data"][0]["video_description"].string {
                                        //Now you got your value
                                        saveTextInStorage("latest_video1_description", video_description)
                                        print("latest_video1_description: \(video_description)")
                                        
                                        if let video_image = json["videos"]["data"][0]["video_image"].string {
                                            //Now you got your value
                                            saveTextInStorage("latest_video1_image", video_image)
                                            print("latest_video1_image: \(video_image)")
                                            if let video_mp4 = json["videos"]["data"][0]["video_mp4"].string {
                                                //Now you got your value
                                                saveTextInStorage("latest_video1_mp4", video_mp4)
                                                print("latest_video1_mp4: \(video_mp4)")
                                                
                                                if let created_at = json["videos"]["data"][0]["created_at"].string {
                                                    //Now you got your value
                                                    saveTextInStorage("latest_video1_date", created_at)
                                                    print("latest_video1_date: \(created_at)")
                                                  }
                                              }
                                          } //VIDEO IMAGE
                                      }
                                  } // START FOR VIDEO NAME
                              } // END FOR VIDEO ID
                          
                          if let video_id = json["latest_audios"]["data"][0]["audio_id"].int {
                              //Now you got your value
                              saveTextInStorage("latest_video2_id", String(video_id))
                              print("latest_video2_id: \(video_id)")
                              
                              if let video_name = json["latest_audios"]["data"][0]["audio_name"].string {
                                  //Now you got your value
                                  saveTextInStorage("latest_video2_name", video_name)
                                  print("111 latest_video2_name: \(video_name)")
                                  
                                  if let video_description = json["latest_audios"]["data"][0]["audio_description"].string {
                                      //Now you got your value
                                      saveTextInStorage("latest_video2_description", video_description)
                                      print("latest_video2_description: \(video_description)")
                                      
                                      if let video_image = json["latest_audios"]["data"][0]["audio_image"].string {
                                          //Now you got your value
                                          saveTextInStorage("latest_video2_image", video_image)
                                          print("latest_video2_image: \(video_image)")
                                          if let video_mp4 = json["latest_audios"]["data"][0]["audio_mp3"].string {
                                              //Now you got your value
                                              saveTextInStorage("latest_video2_mp4", video_mp4)
                                              print("latest_video2_mp4: \(video_mp4)")
                                              
                                              if let created_at = json["latest_audios"]["data"][0]["created_at"].string {
                                                  //Now you got your value
                                                  saveTextInStorage("latest_video2_date", created_at)
                                                  print("latest_video2_date: \(created_at)")
                                                }
                                            }
                                        } //VIDEO IMAGE
                                    }
                                } // START FOR VIDEO NAME
                            } // END FOR VIDEO ID
                            
                            self.values_set = true
                            self.showProgress = false
                            
                        }
                    }
                }
            } catch  let error as NSError {
                self.values_set = false
                self.showProgress = false
                //
            }
            
        }.resume()
    }
}
