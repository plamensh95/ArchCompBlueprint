//
//  MainViewController.swift
//  FireCart
//
//  Created by Plamen Iliev on 13.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var contentContainer: UIView!
    var drawerVC: DrawerViewController?
    
    var currentOption: DrawerOption = .Menu
    var isFirstLoad = true
    var leftEdgePanRecognizer = UIScreenEdgePanGestureRecognizer()
    var rightEdgePanRecognizer = UIScreenEdgePanGestureRecognizer()
    var taprecognizer = UITapGestureRecognizer()
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        setupGestureRecognizers()
    }
    
    override func viewDidLayoutSubviews() {
        // Do not ask for drawer before this call
        if isFirstLoad {
            addViewController(for: currentOption)
//            initDrawer(toggled: true)
            isFirstLoad = false
        }
    }
    
    // MARK: - Actions
    @objc func menuButtonPressed(sender: UIBarButtonItem) {
        if let drawer = drawerVC {
            drawer.handleDrawer(toggled: !drawer.isDrawerToggled)
        } else {
            initDrawer(toggled: true)
        }
    }
    
    func configureNavigationBar() {
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: AssetName.menu.rawValue), style: .plain, target: self, action: #selector(menuButtonPressed))
        navigationItem.setLeftBarButton(testUIBarButtonItem, animated: true)
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    func initDrawer(toggled : Bool) {
        drawerVC = DrawerViewController(nibName: "DrawerViewController", toggled: toggled)
        drawerVC?.drawerDelegate = self
        addViewControllerFillBounds(containedViewController: drawerVC!, in: contentContainer)
    }
    
}

extension MainViewController: UIGestureRecognizerDelegate {
    private func setupGestureRecognizers() {
        leftEdgePanRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(sender:)))
        leftEdgePanRecognizer.edges = .left
        rightEdgePanRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(sender:)))
        rightEdgePanRecognizer.edges = .right
        view.addGestureRecognizer(leftEdgePanRecognizer)
        view.addGestureRecognizer(rightEdgePanRecognizer)
        leftEdgePanRecognizer.delegate = self
        rightEdgePanRecognizer.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: view)
        if gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self) {
            if let _ = drawerVC {
                return gestureRecognizer == rightEdgePanRecognizer && location.x > view.width - 10
            } else if gestureRecognizer == leftEdgePanRecognizer && location.x < 10 {
                initDrawer(toggled: false)
                return true
            }
        }
        return false
    }
    
    @objc func handleEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        drawerVC?.handlePan(sender: sender)
    }
    
}

extension MainViewController: DrawerDelegate {
    func drawerStateChanged(toggled: Bool) {
        if !toggled {
            removeChildViewController(ofType: DrawerViewController.self)
            drawerVC = nil
        }
    }

    func optionPressed(option: DrawerOption) {
        removeAllChildViewControllers()
        drawerVC = nil
        addViewController(for: option)
        navigationItem.title = option.rawValue
    }
    
    func addViewController(for option: DrawerOption) {
        var currentOptionViewController: AnyObject = UIViewController()
        switch option {
        case .Menu:
            currentOptionViewController = (Storyboard.Menu.instanstiateController(MenuViewController.self) as? MenuViewController)!
        case .Orders:
            currentOptionViewController = (Storyboard.Orders.instanstiateController(OrdersViewController.self) as? OrdersViewController)!
        case .Cart:
            currentOptionViewController  = (Storyboard.Cart.instanstiateController(CartViewController.self) as? CartViewController)!
        }
        addViewControllerFillBounds(containedViewController: currentOptionViewController as! UIViewController, in: contentContainer)
    }
}

