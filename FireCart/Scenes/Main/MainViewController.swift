//
//  MainViewController.swift
//  FireCart
//
//  Created by Plamen Iliev on 13.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MainPresenterToViewProtocol {
    
    var presenter: MainPresenter!
    @IBOutlet weak var contentView: UIView!
    lazy var drawer: DrawerViewController = DrawerViewController(nibName: "DrawerViewController", bundle: nil)

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
        MainConfigurator.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        // Do not ask for drawer before this call
        setupDrawer()
    }
    
    // MARK: - PresenterToViewProtocol
    func displaySomething() {
        
    }
    
    // MARK: - Actions
    @objc func menuButtonPressed(sender: UIBarButtonItem) {
        drawer.isDrawerToggled = !drawer.isDrawerToggled
    }
    
    func configureNavigationBar() {
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: AssetName.menu.rawValue), style: .plain, target: self, action: #selector(menuButtonPressed))
        navigationItem.setLeftBarButton(testUIBarButtonItem, animated: true)
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
}

extension MainViewController: OptionDelegate {
    func setupDrawer() {
        drawer.optionDelegate = self
        addChildViewController(drawer)
        drawer.didMove(toParentViewController: self)
        contentView.addSubview(drawer.view)
        drawer.view.translatesAutoresizingMaskIntoConstraints = false
        drawer.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        drawer.view.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        drawer.view.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        drawer.view.layoutIfNeeded()
    }
    
    func optionPressed(option: String) {
        print(option)
    }
    
}
