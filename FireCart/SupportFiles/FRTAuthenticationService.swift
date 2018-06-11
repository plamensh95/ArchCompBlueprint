//
//  FRTAuthenticationService.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import Foundation
import SwifterSwift
import FirebaseAuth
import FirebaseCore
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

enum Provider {
    case facebook
    case google
    case phone
}

class FRTAuthenticationService: NSObject, GIDSignInDelegate {
    
    private override init() {}
    public static let shared = FRTAuthenticationService()
    public static let google = GIDSignIn.sharedInstance()
    public static let facebook = FBSDKApplicationDelegate.sharedInstance()
    lazy var auth = Auth.auth()
    
    func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func configureProviders(for application: UIApplication, with launchOptions: [UIApplicationLaunchOptionsKey : Any]?) {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions ?? [:])
    }
    
    func signIn(using provider: Provider, from viewController: UIViewController? = nil, phoneNumber: String? = nil) {
        switch provider {
        case .facebook:
            if let currentAccessToken = FBSDKAccessToken.current() {
                guard let accessTokenString = currentAccessToken.tokenString else { return }
                let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                self.authenticateToFirebase(with: credential)
            } else {
                FBSDKLoginManager.init().logIn(withReadPermissions: ["public_profile", "email"], from: viewController) { (result, error) in
                    if let _ = error {
                        //error handling
                    } else if let result = result, result.isCancelled {
                        //canceled handling
                    } else {
                        print("Facebook sign-in success")
                        let accessToken = FBSDKAccessToken.current()
                        guard let accessTokenString = accessToken?.tokenString else { return }
                        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                        self.authenticateToFirebase(with: credential)
                    }
                    
                }
            }
            break
        case .google:
            type(of: self).google?.signIn()
            break
        case .phone:
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber ?? "", uiDelegate: nil) { (verificationID, error) in
                if let _ = error {
                    //error handling
                }
                
                print("Phone sign-in success")
                
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                
                let alert = UIAlertController.init(title: "Phone verification", message: "Please enter the received code to login", defaultActionButtonTitle: "Cancel", tintColor: UIColor.blue)
                alert.addTextField(text: "", placeholder: "Enter code here...", editingChangedTarget: nil, editingChangedSelector: nil)
                alert.addAction(title: "Login", style: .default, isEnabled: true, handler: { (action) in
                    guard let textFields = alert.textFields, let verificationCode = textFields[0].text else { return }
                    let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode)
                    self.authenticateToFirebase(with: credential)
                })
                alert.show()
            }
            break
        }
    }
    
    func authenticateToFirebase(with credential: AuthCredential) {
        if let _ = auth.currentUser {
            auth.currentUser?.linkAndRetrieveData(with: credential, completion: { (authResult, error) in
                if let _ = error {
                    // Error handling
                    return
                }
                
                print("Firebase sign-in success")
            })
        } else {
            auth.signInAndRetrieveData(with: credential) { (authResult, error) in
                if let _ = error {
                    // Error handling
                    return
                }
                
                print("Firebase sign-in success")
            }
        }
    }
    
    func logout() {
        do{
            try auth.signOut()
            print("Successfully logout")
        } catch let error{
            print(print(error.localizedDescription))
        }
    }
    
    func registerUser(with name: String, email: String, and password: String) {
        auth.createUser(withEmail: email, password: password) { (user, error) in
            
        }
    }
    
    // MARK: - GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            // ...
            return
        }
        
        print("Google sign-in success")
        
        guard let authentication = user.authentication, let idToken = authentication.idToken, let accessToken = authentication.accessToken else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        authenticateToFirebase(with: credential)
    }
}
