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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        updateTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            presenter.loginUser(with: email, and: password)
        }
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        presenter.registerButtonPressed()
    }
    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        presenter.facebookButtonPressed()
    }
    @IBAction func googleButtonPressed(_ sender: UIButton) {
        presenter.googleButtonPressed()
    }
    @IBAction func phoneButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "Phone authentication", message: "You will receive an sms containing your verification code", defaultActionButtonTitle: "Cancel", tintColor: UIColor.blue)
        alert.addTextField(text: "", placeholder: "Enter phone number here...", editingChangedTarget: nil, editingChangedSelector: nil)
        alert.addAction(title: "Send code", style: .default, isEnabled: true, handler: { (action) in
            guard let textFields = alert.textFields, let phoneNumber = textFields[0].text else { return }
            print(phoneNumber)
            self.presenter.phoneButtonPressed(phoneNumber: phoneNumber)
        })
        alert.show()
    }
    
    func updateTextFields() {
        if let email = UserDefaults.standard.string(forKey: UserDefaultsKeys.authUserEmail.rawValue),
            let password = UserDefaults.standard.string(forKey: UserDefaultsKeys.authUserPass.rawValue) {
            emailTextField.text = email
            passwordTextField.text = password
        }
    }

    // MARK: - PresenterToViewProtocol
    func displayError(error: String) {
        UIAlertController(title: DialogTittles.error.rawValue, message: error , defaultActionButtonTitle: "OK", tintColor: UIColor.blue).show()
    }
    
}
