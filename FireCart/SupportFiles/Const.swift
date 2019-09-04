//
//  Const.swift
//  FireCart
//
//  Created by Plamen Iliev on 11.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
Ytest
//

import Foundation

enum JSONError : Error {
    case encodingError
    case decodingError
}

enum AssetName: String {
    case loading = "loading"
    case menu = "menu"
}

enum DialogTittles: String {
    case congratulations  = "Congratulations"
    case error = "Error"
}

enum SuccessMessages: String {
    case registration = "Registration successful!"
    case updateUserData = "Profile updated successfully!"
}

enum ErrorMessages: String {
    case userAlreadyExists = "Username or email is already in use by another user"
    case incorrectPassword = "Incorrect password"
    case unsuccessfulLogin = "Unsuccessful login"
    case usernameTaken = "This username is already taken"
    case registrationFailed = "Registration failed"
    case cantUpdateUserInfo = "Couldn't update information"
    case passwordNotMatch = "Password doesnt match"
    case ignored
}

enum ButtonTitles: String {
    case procceedToLogin = "Procceed to login"
}

enum UserDefaultsKeys: String {
    case authUserEmail
    case authUserPass
}

enum Result {
    case success(result: Any?)
    case error(NSError)
}

enum EntityName: String {
    case cartProduct = "CartProduct"
}

enum TableViewRowAction {
    case reload
    case insert
    case delete
}

