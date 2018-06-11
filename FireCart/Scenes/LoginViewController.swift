//
//  LoginViewController.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginPresenterToViewProtocol {
    
    var presenter: LoginPresenter!
    
    // MARK: - Object lifecycle
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Do not ask for presenter before this call
        self.setupVIPER()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Do not ask for presenter before this call
        self.setupVIPER()
    }
    
    // MARK: - Initilization
    func setupVIPER() {
        LoginConfigurator.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
    }
    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        presenter.facebookButtonPressed(from: self)
    }
    @IBAction func googleButtonPressed(_ sender: UIButton) {
        presenter.googleButtonPressed(from: self)
    }
    @IBAction func phoneButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "Phone verification", message: "Please enter the received code to login", defaultActionButtonTitle: "Cancel", tintColor: UIColor.blue)
        alert.addTextField(text: "", placeholder: "Enter code here...", editingChangedTarget: nil, editingChangedSelector: nil)
        alert.addAction(title: "Login", style: .default, isEnabled: true, handler: { (action) in
            guard let textFields = alert.textFields, let phoneNumber = textFields[0].text else { return }
            print(phoneNumber)
            self.presenter.phoneButtonPressed(from: self, phoneNumber: phoneNumber)
        })
        alert.show()
    }
    
    // MARK: - PresenterToViewProtocol
    func displaySomething() {
        
    }
    
}
