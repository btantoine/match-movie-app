//
//  ViewModel.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/10/21.
//

import Foundation

final class ViewModel: ObservableObject {
    private lazy var signInWithApple = SignInWithAppleCoordinator()
    @Published var user: AuthUser?

    func getRequest() {
        signInWithApple.getAppleRequest()
    }

    func getUserInfo() {
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data,
           let userDecoded = try? JSONDecoder().decode(AuthUser.self, from: userData) {
            signInWithApple.check_credential(userId: userDecoded.userId) { authSate in
                if (authSate == "authorized") {
                    DispatchQueue.main.async {
                        self.user = userDecoded
                    }
                } else {
                    UserDefaults.standard.removeObject(forKey: "user")
                }
            }
        }
    }
    
    func checkLogOut() {
        if let userData = UserDefaults.standard.object(forKey: "user") as? Data,
           let userDecoded = try? JSONDecoder().decode(AuthUser.self, from: userData) {
        } else {
            self.user = nil
        }
    }
}
