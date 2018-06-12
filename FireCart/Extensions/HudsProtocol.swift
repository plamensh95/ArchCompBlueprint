//
//  HudsProtocol.swift
//  PolicyWallet
//
//  Created by Damyan Todorov on 4/25/17.
//  Copyright © 2017 FlatRockTechnology. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

protocol HudsProtocol {
    
}

extension HudsProtocol where Self: AnyObject {
    
    func showHuds() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        HUD.show(.rotatingImage(UIImage(named: AssetName.loading.rawValue)))
        
    }
    
    func showHunds(onView view: UIView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        HUD.show(.rotatingImage(UIImage(named: AssetName.loading.rawValue)), onView: view)
    }
    
    func hideHuds() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        HUD.hide()
    }
    
    func showSuccessHuds() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        HUD.flash(.success)
    }
    
}
