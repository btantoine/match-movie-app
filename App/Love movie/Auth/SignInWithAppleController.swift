//
//  SignInWithAppleController.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/10/21.
//

import SwiftUI
import AuthenticationServices

struct AppleIdButton: UIViewRepresentable {

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton()
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}

final class SignInWithAppleCoordinator: NSObject {
    func getAppleRequest() {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.performRequests()
    }

    private func setUserInfo(for userId: String, firstName: String?, lastName: String?, email: String?) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userId) { credentialState, error in
            var authState: String?
            switch credentialState {
            case .authorized: authState = "authorized"
            case .notFound: authState = "notFound"
            case .revoked: authState = "revoked"
            case .transferred: authState = "transferred"
            @unknown default:
                fatalError()
            }
            let user = AuthUser(userId: userId, firstName: firstName ?? "not provided", lastName: lastName ?? "not provided", email: email ?? "not provided", authState: authState ?? "unknown")
            if let userEncoded = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(userEncoded, forKey: "user")
            }
        }
    }
    
    func check_credential(userId: String, completionHandler:@escaping(String)->()) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userId) { credentialState, error in
            var authState: String?
            switch credentialState {
            case .authorized: authState = "authorized"
            case .notFound: authState = "notFound"
            case .revoked: authState = "revoked"
            case .transferred: authState = "transferred"
            @unknown default:
                fatalError()
            }
            completionHandler(authState ?? "unknown")
        }
    }
}

extension SignInWithAppleCoordinator: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            setUserInfo(for: credential.user, firstName: credential.fullName?.givenName, lastName: credential.fullName?.familyName, email: credential.email)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("SignIn with Apple ID  Error: \(error.localizedDescription)")
    }
}
