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
    @State var now = Date()
    
    let tabBarImageNames = ["orders", "invite", "plus", "question", "user"]
    let tabBarMenuNames = ["MyOrders", "Invite", "Start", "Support", "Profile"]
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(){
                
                    Button(action: {
                        if let url = URL(string: "https://www.memaww.com/service-policy") {
                           UIApplication.shared.open(url)
                        }
                    }, label: {
                        Image("ohg")
                           //.font(.system(size: 25, weight: .bold))
                           .renderingMode(.template)
                           .colorMultiply(.init(white: 0.8))
                           //.foregroundColor(.red)
                           .foregroundColor(.init(white: 0.8))
                           .padding(.leading, 20)
                           .padding(.top, 5)
                        }
                    )
                
                
                Spacer()
                Text(" MeMaww ")
                    .foregroundColor(Color(.black))
                    .font(.custom("SweetSensationsPersonalUse", size: 30))
                    .padding(.top, 5)
                Spacer()
                
                    Button(action: {
                        selectedIndex = 7
                    }, label: {
                        
                        Image("notification")
                           //.font(.system(size: 25, weight: .bold))
                           .renderingMode(.template)
                           .colorMultiply(.init(white: 0.8))
                           //.foregroundColor(.red)
                           .foregroundColor(.init(white: 0.8))
                           .padding(.trailing, 20)
                        }
                    )
                
                    
                
            }
            
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
                    OrdersMenuView(selectedIndex: Binding(projectedValue: $selectedIndex))
                    
                case 3:
                    ContactUsView()
                    
                case 4:
                    ProfileView(currentStage: .constant("MainView"), user_name: getSavedString("user_firstname") + " " + getSavedString("user_lastname"),  user_phone: getSavedString("user_phone"), user_address: "Not Set", user_email:  "Not Set")
                    
                case 5:
                    StartOrderView(selectedIndex: Binding(projectedValue: $selectedIndex))
                    
                case 6:
                    SubscriptionView(selectedIndex: Binding(projectedValue: $selectedIndex))
                    
                case 7:
                    NotificationsView(selectedIndex: Binding(projectedValue: $selectedIndex))
                    
                    
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

