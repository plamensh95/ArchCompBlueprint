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

class FRTAuthenticationService: NSObject, GIDSignInDelegate, HudsProtocol {
    
    private override init() {}
    public static let shared = FRTAuthenticationService()
    public static let google = GIDSignIn.sharedInstance()
    public static let facebook = FBSDKApplicationDelegate.sharedInstance()
    lazy var auth = Auth.auth()
    private var authenticationResult: ((Result) -> ())?
    
    func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func configureProviders(for application: UIApplication, with launchOptions: [UIApplicationLaunchOptionsKey : Any]?) {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions ?? [:])
    }
    
    func currentUser() -> User? {
        return auth.currentUser
    }
    
    func signIn(using provider: Provider, phoneNumber: String? = nil, completion: @escaping (Result) -> ()) {
        authenticationResult = completion
        switch provider {
        case .facebook:
            if let currentAccessToken = FBSDKAccessToken.current() {
                guard let accessTokenString = currentAccessToken.tokenString else { return }
                let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                self.authenticateToFirebase(with: credential)
            } else {
                FBSDKLoginManager.init().logIn(withReadPermissions: ["public_profile", "email"], from: nil) { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let result = result, result.isCancelled {
                        print("Facebook sign-in cancelled")
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
                if let error = error {
                    print(error.localizedDescription)
                }
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
        showHuds()
        auth.signInAndRetrieveData(with: credential) { (authResult, error) in
            self.hideHuds()
            
            
            
            if let result = authResult {
                let user = FRTUser(id: result.user.uid, name: result.user.displayName ?? "", email: result.user.email ?? "")
                self.authenticationResult!(.success(result: user))
            }
            else if let error = error {
                self.authenticationResult!(.error(error as NSError))
                print(error.localizedDescription)
            }
        }
    }
    
    func loginUser(with email: String, and password: String, completion: @escaping (Result) -> ()) {
        showHuds()
        auth.signIn(withEmail: email, password: password) { (authResult, error) in
            self.hideHuds()
            if let result = authResult {
                let user = FRTUser(id: result.user.uid, name: result.user.displayName ?? "", email: email)
                completion(.success(result: user))
            }
            else if let error = error {
                completion(.error(error as NSError))
                print(error.localizedDescription)
            }
        }
    }
    
    func logout(completion: @escaping (Result) -> ()) {
        do{
            try auth.signOut()
            completion(.success(result: nil))
        } catch let error{
            completion(.error(error as NSError))
            print(error.localizedDescription)
        }
    }
    
    func registerUser(with name: String, email: String, and password: String, completion: @escaping (Result) -> ()) {
        showHuds()
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
            self.hideHuds()
            if let error = error {
                completion(.error(error as NSError))
            } else {
                if let authUser = authResult?.user {
                    let user = FRTUser(id: authUser.uid, name: name, email: email)
                    FRTFirestoreService.shared.create(object: user, documentPaths: [authUser.uid], collectionReferences: [.users], completion: { (result) in
                        switch result {
                        case .success(result: _):
                            UserDefaults.standard.setValue(email, forKey: UserDefaultsKeys.authUserEmail.rawValue)
                            UserDefaults.standard.setValue(password, forKey: UserDefaultsKeys.authUserPass.rawValue)
                            completion(.success(result: nil))
                        case .error(let error):
                            completion(.error(error))
                        }
                    })
                }
            }
        }
    }
    
    func isUserLogged() -> Bool {
        return auth.currentUser != nil ? true : false
    }
    
    
    // MARK: - GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication, let idToken = authentication.idToken, let accessToken = authentication.accessToken else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        authenticateToFirebase(with: credential)
    }
}
