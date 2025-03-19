//
//  LoginView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/17/24.
//

import SwiftUI
import SwiftyJSON

struct SignupView: View {
    
    @State private var first_name: String = ""
    @State private var last_name: String = ""
    @State private var country: String = ""
    @State private var phone_number: String = ""
    @State private var invite_code: String = ""
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    @State private var networking: Bool = false
    
    
    //@State private var showLoginButton: Bool = true
    @ObservedObject var manager = SignupHttpAuth()
    @Binding var currentStage: String
        
    @State private var lastSelectedIndex: Int?
    
    @State var countries = ["Ghana","United Kingdom","USA","Afghanistan","Albania","Algeria","American Samoa","Andorra","Angola","Anguilla","Antarctica","Antigua and Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Bouvet Island","Brazil","British Indian Ocean Territory","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Cape Verde","Cayman Islands","Central African Republic","Chad","Chile","China","Christmas Island","Cocos (Keeling) Islands","Colombia","Comoros","Congo","Cook Islands","Costa Rica","Cote d\'Ivoire","Croatia","Cuba","Cyprus","Czech Republic","Democratic Republic of the Congo","Denmark","Djibouti","Dominica","Dominican Republic","East Timor","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Faeroe Islands","Falkland Islands","Fiji","Finland","Former Yugoslav Republic of Macedonia","France","French Guiana","French Polynesia","French Southern Territories","Gabon","Georgia","Germany","Gibraltar","Greece","Greenland","Grenada","Guadeloupe","Guam","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Heard Island and McDonald Islands","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Martinique","Mauritania","Mauritius","Mayotte","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Myanmar","Namibia","Nauru","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Niue","Norfolk Island","North Korea","Northern Marianas","Norway","Oman","Pakistan","Palau","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Pitcairn Islands","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Sao Tome and Principe","Saint Helena","Saint Kitts and Nevis","Saint Lucia","Saint Pierre and Miquelon","Saint Vincent and the Grenadines","Samoa","San Marino","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Georgia and the South Sandwich Islands","South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Svalbard and Jan Mayen","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","The Bahamas","The Gambia","Togo","Tokelau","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Turks and Caicos Islands","Tuvalu","Virgin Islands","Uganda","Ukraine","United Arab Emirates","United States Minor Outlying Islands","Uruguay","Uzbekistan","Vanuatu","Vatican City","Venezuela","Vietnam","Wallis and Futuna","Western Sahara","Yemen","Yugoslavia","Zambia","Zimbabwe"] //Here Add Your data
    @State var countryIndex = 0
    
        
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
            Image("MeMawwLogoWithName")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .padding()
            /*
            Image("ImageLogoBlue")
                .resizable()
                .scaleEffect(x: 1, y: 1.1, anchor: .top)
            */
            if manager.requestMade {
                if !manager.authenticated {
                    Text(manager.message)
                    .font(.headline)
                    .foregroundColor(.red)
                        .onAppear(perform: {
                            networking = false;
                        })
                } else {
                    
                    
                    Text("Signup Successful")
                    .font(.headline)
                    .foregroundColor(.green)
                    .onAppear(perform: {
                        saveTextInStorage("user_accesstoken", manager.accessToken)
                        saveTextInStorage("user_userid", manager.userId)
                        saveTextInStorage("user_phone", manager.userPhone)
                        saveTextInStorage("user_firstname", manager.userFirstName)
                        saveTextInStorage("user_lastname", manager.userLastName)
                        saveTextInStorage("user_referralcode", manager.userReferralCode)
                        self.currentStage = "LoggedInView"
                        print("currentStage: \(self.currentStage)")
                    })
                }
            }
            
        
        PickerTextField(data: ["Ghana","United Kingdom","USA","Afghanistan","Albania","Algeria","American Samoa","Andorra","Angola","Anguilla","Antarctica","Antigua and Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Bouvet Island","Brazil","British Indian Ocean Territory","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Cape Verde","Cayman Islands","Central African Republic","Chad","Chile","China","Christmas Island","Cocos (Keeling) Islands","Colombia","Comoros","Congo","Cook Islands","Costa Rica","Cote d\'Ivoire","Croatia","Cuba","Cyprus","Czech Republic","Democratic Republic of the Congo","Denmark","Djibouti","Dominica","Dominican Republic","East Timor","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Faeroe Islands","Falkland Islands","Fiji","Finland","Former Yugoslav Republic of Macedonia","France","French Guiana","French Polynesia","French Southern Territories","Gabon","Georgia","Germany","Gibraltar","Greece","Greenland","Grenada","Guadeloupe","Guam","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Heard Island and McDonald Islands","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Martinique","Mauritania","Mauritius","Mayotte","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Myanmar","Namibia","Nauru","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Niue","Norfolk Island","North Korea","Northern Marianas","Norway","Oman","Pakistan","Palau","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Pitcairn Islands","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Sao Tome and Principe","Saint Helena","Saint Kitts and Nevis","Saint Lucia","Saint Pierre and Miquelon","Saint Vincent and the Grenadines","Samoa","San Marino","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Georgia and the South Sandwich Islands","South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Svalbard and Jan Mayen","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","The Bahamas","The Gambia","Togo","Tokelau","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Turks and Caicos Islands","Tuvalu","Virgin Islands","Uganda","Ukraine","United Arab Emirates","United States Minor Outlying Islands","Uruguay","Uzbekistan","Vanuatu","Vatican City","Venezuela","Vietnam","Wallis and Futuna","Western Sahara","Yemen","Yugoslavia","Zambia","Zimbabwe"],placeholder: "Ghana",lastSelectedIndex: self.$lastSelectedIndex)
            .padding()
            .frame(width: 300, height: 50)
            .background(Color.black.opacity(0.05))
            .cornerRadius(10)
            
        
            TextField("Phone Number(0244123456)", text: $phone_number)
                .keyboardType(.numberPad)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .onChange(of: phone_number) { newValue in
                    if newValue.count > 10 {
                        self.phone_number = String(newValue.prefix(10))
                    }
                }
            
            TextField("First Name", text: $first_name)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .onChange(of: first_name) { newValue in
                    if newValue.count > 20 {
                        self.first_name = String(newValue.prefix(20))
                    }
                }
            
            TextField("Last Name", text: $last_name)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .onChange(of: last_name) { newValue in
                    if newValue.count > 20 {
                        self.last_name = String(newValue.prefix(20))
                    }
                }
            
            TextField("Invite Code (Optional)", text: $invite_code)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .onChange(of: invite_code) { newValue in
                    if newValue.count > 10 {
                        self.invite_code = String(newValue.prefix(10))
                    }
                }
            
            
            if manager.showLoginButton {
                Button(action: {
                    country = countries[lastSelectedIndex ?? 0]
                    print("first_name: \(self.first_name)")
                    print("last_name: \(self.last_name)")
                    //print("$lastSelectedIndex country: \(countries[lastSelectedIndex ?? 0])")
                    print("country: \(self.country)")
                    print("phone_number: \(self.phone_number)")
                    print("invite_code: \(self.invite_code)")
                    print("app_version_code: " + MeMawwApp.app_version)
                    print("url: " + MeMawwApp.app_domain + "/api/v1/user/sign-in")
                    //print("repeat_password: \(self.repeat_password)")
                    if networking == false {
                        manager.checkDetails(
                            first_name: self.first_name,
                            last_name: self.last_name,
                            country: self.country,
                            phone_number: self.phone_number,
                            invite_code: self.invite_code
                        )
                    }
                }) {
                    HStack (spacing: 8) {
                        Text("SIGN-IN")
                            .foregroundColor(Color.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .foregroundColor(Color("ColorMeMawwBlueDark"))
                } //: BUTTON
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.bottom, 50)
                /*
                .accentColor(Color.accentColor)
                .background(Color("ColorMeMawwBlueDark"))
                .cornerRadius(20)
                .padding(.bottom, 50)
                 */
                
            } else {
                ProgressView()
            }
            
            //SignupActionTextsViews(currentStage: $currentStage)
            //.padding(.vertical, 35)
            
        }
        .offset(y: kGuardian.slide).animation(.easeInOut(duration: 1.0))
    }
}

func saveTextInStorage(_ index: String, _ value: String) {
    UserDefaults.standard.set(value, forKey:index)
}

func saveIntegerInStorage(_ index: String, _ value: Int) {
    UserDefaults.standard.set(value, forKey:index)
}

func deleteUserData(){
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(currentStage: .constant("LoginView"))
    }
}


class SignupHttpAuth: ObservableObject {

    @Published var authenticated = false
    @Published var requestMade = false
    @Published var showLoginButton = true
    @Published var message = ""
    @Published var userId = ""
    @Published var userPhone = ""
    @Published var accessToken = ""
    @Published var userFirstName = ""
    @Published var userLastName = ""
    @Published var userReferralCode = ""

    func checkDetails(
        first_name: String,
        last_name: String,
        country: String,
        phone_number: String,
        invite_code: String) {
        showLoginButton = false
            guard let url = URL(string: MeMawwApp.app_domain + "/api/v1/user/sign-in") else { return }
            
        let body: [String: String] =
            [
                "user_country": country,
                "user_phone": phone_number,
                "user_first_name": first_name,
                "user_last_name": last_name,
                "invite_code": invite_code,
                "app_type": "IOS",
                "app_version_code": MeMawwApp.app_version
            ]

        let finalBody = try! JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("text/json", forHTTPHeaderField: "Accept")
        //request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { (data2, response, error) in
            print("starting 1")
            print(response)
            print(data2)
            guard let data2 = data2 else { return }
            print("starting 2")
            //print(response)
            print(data2)
            print("starting 3")
            
            do {
                let json = try JSON(data: data2)
                if let status = json["status"].string {
                  //Now you got your value
                    print(status)
                    
                    DispatchQueue.main.async {
                        self.requestMade = true
                        if status == "success" {
                            self.authenticated = true
                            if let thisaccesstoken = json["access_token"].string {
                                //Now you got your value
                                self.accessToken = thisaccesstoken
                                print("access_token: \(self.accessToken)")
                              }
                            if let user_id = json["user"]["user_id_string"].string{
                                //Now you got your value
                                self.userId = user_id
                                print("user_id: \(self.userId)")
                              }
                            if let user_phone = json["user"]["user_phone"].string{
                                //Now you got your value
                                self.userPhone = user_phone
                                print("user_phone: \(self.userPhone)")
                              }
                            if let firstname = json["user"]["user_first_name"].string {
                                //Now you got your value
                                self.userFirstName = firstname
                                print("user_first_name: \(self.userFirstName)")
                              }
                            if let surname = json["user"]["user_last_name"].string {
                                //Now you got your value
                                self.userLastName = surname
                                print("surname: \(self.userLastName)")
                              }
                            if let referralcode = json["user"]["user_referral_code"].string {
                                //Now you got your value
                                self.userReferralCode = referralcode
                                print("user_referral_code: \(self.userReferralCode)")
                              }
                            
                            
                        } else {
                            self.authenticated = false
                            self.showLoginButton = true
                            if let message = json["message"].string {
                                //Now you got your value
                                  print(message)
                                  self.message = message
                              }
                        }
                    }
                }
            } catch  let error as NSError {
                print((error as NSError).localizedDescription)
                DispatchQueue.main.async {
                    self.requestMade = true
                    self.message = "Sign-In failed"
                    self.authenticated = false
                    self.showLoginButton = true
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
