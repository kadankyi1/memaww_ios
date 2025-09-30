//
//  MeMawwApp.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/16/24.
//

import SwiftUI
import Firebase
import SwiftyJSON
import FirebaseCore
import FirebaseMessaging
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })

        application.registerForRemoteNotifications()

        Messaging.messaging().token { token, error in
            if error != nil {
                print("Error fetching FCM registration token: \(error)")
            } else if token != nil {
                print("FCM registration token: \(token)")
                UserDefaults.standard.set(token, forKey:"user_fcm_ios_token")
                
            }
        }

        return true
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Oh no! Failed to register for remote notifications with error \(error)")
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var readableToken = ""
        for index in 0 ..< deviceToken.count {
            readableToken += String(format: "%02.2hhx", deviceToken[index] as CVarArg)
        }
        print("Received an APNs device token: \(readableToken)")
    }
}

extension AppDelegate: MessagingDelegate {
    @objc func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase token: \(String(describing: fcmToken))")
        UserDefaults.standard.set(fcmToken, forKey:"user_fcm_ios_token")
        
        Messaging.messaging().subscribe(toTopic: "IPHONE_USERS"){ error in
                    if error == nil{
                        print("Subscribed to topic")
                    }
                    else{
                        print("Not Subscribed to topic")
                    }
                }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent _: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([[.banner, .list, .sound]])
    }

    func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(
            name: Notification.Name("didReceiveRemoteNotification"),
            object: nil,
            userInfo: userInfo
        )
        completionHandler()
    }
}


@main
struct MeMawwApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    static let app_version : String = "1"
    
    // LIVE OR TEST ENVIRONMENT
    //static let app_domain : String = "http://127.0.0.1/infodefa_00233538815095/memaww_web/public"
    static let app_domain : String = "https://memaww.com"
    
    @State var currentStage = getUserFirstOpenView("user_accesstoken")
    @State var isFromNotif: Bool = false
    @ObservedObject var updateUserInfoObj = HttpUpdateUserInfo()
        
    var body: some Scene {
        
        WindowGroup {
            if(self.currentStage == "OnboardingView" || self.currentStage == ""){
                OnboardingView(currentStage: $currentStage)
            } else if(self.currentStage == "SignupView"){
                SignupView(currentStage: $currentStage)
            } else {
                MainView(currentStage: $currentStage)
            }
            
        }
      }
    }





    func getSavedString(_ index: String) -> String {
        var str = UserDefaults.standard.string(forKey: index) ?? ""
        //print("getSavedString: \(str)")
        return str
        //let str = UserDefaults.standard.object(forKey: index) as? String
        //return str == nil ? "" : str!
    }

    func getUserFirstOpenView(_ index: String) -> String {
        var str = UserDefaults.standard.string(forKey: index) ?? ""
        var user_phone = UserDefaults.standard.string(forKey: "user_phone") ?? ""
        var user_accesstoken = UserDefaults.standard.string(forKey: "user_accesstoken") ?? ""
        var user_fcm_ios_token = UserDefaults.standard.string(forKey: "user_fcm_ios_token") ?? ""
        
        print("getSavedString str: \(str)")
        print("getSavedString user_phone: \(user_phone)")
        print("getSavedString user_accesstoken: \(user_accesstoken)")
        print("getSavedString user_fcm_ios_token: \(user_fcm_ios_token)")
        if(str != "" && user_phone != "" && user_accesstoken != ""){
            str = "MainView"
        } else {
            str = "OnboardingView"
        }
        return str
        //let str = UserDefaults.standard.object(forKey: index) as? String
        //return str == nil ? "" : str!
    }

class HttpUpdateUserInfo: ObservableObject {
    @Published var requestMade = false
    @Published var message = ""
    @Published var status = "failed"
    @Published var min_vc = ""
    
    
    // Add a message in Firestore
    func updateUserInfo(fcm_token: String) {
        
            guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/update-user-info")
            else {
                print("Request failed 1")
                return
            }
            
        let body: [String: String] =
            [
                "fcm_token": fcm_token,
                "fcm_type": "IPHONE",
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
                self.status = "success"
                if let min_vc = json["min_vc"].string {
                    self.min_vc = min_vc
                    print("min_vc: \(self.min_vc)")
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
