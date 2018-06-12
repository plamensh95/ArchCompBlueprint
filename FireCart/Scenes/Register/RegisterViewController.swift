//
//  RegisterViewController.swift
//  FireCart
//
//  Created by Plamen Iliev on 11.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, RegisterPresenterToViewProtocol {
    
    var presenter: RegisterPresenter!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
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
        RegisterConfigurator.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Actions
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
        presenter.registerButtonPressed(with: username, email: email, password: password)
    }
    
    
    // MARK: - PresenterToViewProtocol
    func displayError(error: String) {
        UIAlertController(title: DialogTittles.error.rawValue, message: error , defaultActionButtonTitle: "OK", tintColor: UIColor.blue).show()
    }
    
    func displaySuccessDialog() {
        let alertController = UIAlertController(title: DialogTittles.congratulations.rawValue, message: SuccessMessages.registration.rawValue, preferredStyle: .alert)
        alertController.addAction(title: ButtonTitles.procceedToLogin.rawValue, style: .default, isEnabled: true) { (action) in
            self.presenter.procceedToLogin()
        }
        alertController.show()
    }
    
}
