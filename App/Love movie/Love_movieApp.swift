//
//  Love_movieApp.swift
//  Love movie
//
//  Created by Antoine Boudet on 1/15/21.
//

import SwiftUI
import UserNotifications
import Firebase
import GoogleMobileAds

@main
struct Love_movieApp: App {
    @State var posted = false
    @ObservedObject var vm = ViewModel()

    @AppStorage("user_mongo_id") var user_mongo_id: String = "undefined"
    @AppStorage("user", store: UserDefaults(suiteName: "group.match-movie"))
    var userData: Data = Data()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if vm.user == nil {
                    Authentication(vm: vm)
                }
                else {
                    GroupView()
                }
            }
            .onAppear {
                FirebaseApp.configure()
                GADMobileAds.sharedInstance().start(completionHandler: nil)
                self.vm.getUserInfo()
            }
            .onReceive(timer) { time in
                if vm.user == nil {
                    self.vm.getUserInfo()
                } else {
                    self.vm.checkLogOut()
                }
                if vm.user != nil && posted == false {
                    if (vm.user!.email != "not provided") {
                        Auth_Api().post_user_signIn_with_apple(userId: vm.user!.userId, firstName: vm.user!.firstName, lastName: vm.user!.lastName, email: vm.user!.email) { (result, error) in
                            if (result != nil) {
                                posted = true
                                user_mongo_id = result?["_id"] as! String
                                let user_full_data = AuthUserFullData(_id: result?["_id"] as! String, userId: result?["userId"] as! String, firstName: result?["firstName"] as! String , lastName: result?["lastName"] as! String , email: result?["email"] as! String , authState: "authorized")
                                guard let userData = try? JSONEncoder().encode(user_full_data) else { return }
                                self.userData = userData
                            }
                        }
                    }
                    else {
                        Auth_Api().get_full_userInfo(userId: vm.user!.userId) { (userInfo) in
                            posted = true
                            user_mongo_id = userInfo._id
                            let user = AuthUser(userId: userInfo.userId, firstName: userInfo.firstName , lastName: userInfo.lastName , email: userInfo.email , authState: userInfo.authState)
                            if let userEncoded = try? JSONEncoder().encode(user) {
                                UserDefaults.standard.set(userEncoded, forKey: "user")
                            }
                            let user_full_data = AuthUserFullData(_id: userInfo._id, userId: userInfo.userId, firstName: userInfo.firstName , lastName: userInfo.lastName , email: userInfo.email , authState: userInfo.authState)
                            guard let userData = try? JSONEncoder().encode(user_full_data) else { return }
                            self.userData = userData
                        }
                    }
                }
            }
        }
    }
}
