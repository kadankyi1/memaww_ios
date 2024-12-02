//
//  MeMawwApp.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/16/24.
//

import SwiftUI
import Firebase
//import FirebaseInstanceID



//new class to store notification text and to tell the NavigationView to go to a new page
class NotificationManager : ObservableObject {
    @Published var currentNotificationText : String?
    @Published var deviceToken : String?
    
    var navigationBindingActive : Binding<Bool> {
        .init { () -> Bool in
            self.currentNotificationText != nil
        } set: { (newValue) in
            if !newValue { self.currentNotificationText = nil }
        }
        
    }
}

@main
struct MeMawwApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    static let app_version : String = "1"
    
    // LIVE OR TEST ENVIRONMENT
    //static let app_domain : String = "http://127.0.0.1"
    static let app_domain : String = "https://memaww.com"
    
    @State var currentStage = getUserFirstOpenView("user_accesstoken")
    @State var isFromNotif: Bool = false
        
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
        
        print("getSavedString str: \(str)")
        print("getSavedString user_phone: \(user_phone)")
        print("getSavedString user_accesstoken: \(user_accesstoken)")
        if(str != "" && user_phone != "" && user_accesstoken != ""){
            str = "MainView"
        } else {
            str = "OnboardingView"
        }
        return str
        //let str = UserDefaults.standard.object(forKey: index) as? String
        //return str == nil ? "" : str!
    }

/*
class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    var notificationManager = NotificationManager() //here's where notificationManager is stored

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

        print("userInfo 1")
        print(userInfo)
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            //completionHandler(.failed)
            return
        }
        print("new notification received")
        handleNotification(aps: aps)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
        setDeviceToken(token: deviceToken["token"] ?? "")
        Messaging.messaging().subscribe(toTopic: "ALL_USERS") { error in
          print("Subscribed to ALL_USERS topic 1")
        }
        Messaging.messaging().subscribe(toTopic: "IOS_USERS") { error in
          print("Subscribed to IOS_USERS topic 1")
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }

      print("userInfo 2")
      print(userInfo)
      guard let aps = userInfo["aps"] as? [String: AnyObject] else {
          //completionHandler(.failed)
          return
      }
      print("new notification received")
      handleNotification(aps: aps)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let refreshedToken = InstanceID.instanceID().token() {
                print("didRegisterForRemoteNotificationsWithDeviceToken InstanceID token: \(refreshedToken)")
                saveTextInStorage("devicetoken", refreshedToken)
        }
        

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

    print(userInfo)
      guard let aps = userInfo["aps"] as? [String: AnyObject] else {
          //completionHandler(.failed)
          return
      }
      print("new notification received")
      handleNotification(aps: aps)

    completionHandler()
  }
  @discardableResult func handleNotification(aps: [String:Any]) -> Bool {

        guard let alert = aps["alert"] as? String else { //get the "alert" field
            return false
        }
        guard let alert = aps["alert"] as? String else { //get the "alert" field
            return false
        }
        print("self.notificationManager.currentNotificationText")
        self.notificationManager.currentNotificationText = alert
        
        print(self.notificationManager.currentNotificationText)
        return true
  }
    
  @discardableResult func setDeviceToken(token: String) -> Bool {
        self.notificationManager.deviceToken = token
        
        saveTextInStorage("devicetoken", self.notificationManager.deviceToken ?? "")
        print("SNMDT self.notificationManager.deviceToken: \(self.notificationManager.deviceToken)")
        return true
  }
}
 */
