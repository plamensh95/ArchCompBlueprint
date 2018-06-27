//
//  DrawerViewController.swift
//  FireCart
//
//  Created by Plamen Iliev on 14.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import UIKit

enum DrawerOption: String {
    case Menu
    case Orders
    case Cart
    case Logout
    
    static let allValues = [Menu, Orders, Cart, Logout]
}

protocol DrawerDelegate : class {
    func drawerStateChanged(toggled: Bool)
    func optionPressed(option: DrawerOption)
}

class DrawerViewController: UIViewController {
    
    @IBOutlet weak var drawerTableView: UITableView!
    @IBOutlet weak var overlayView: UIView!
    weak var drawerDelegate: DrawerDelegate?
    
    let velocityLimit: CGFloat = 100.0
    let maxAlpha: CGFloat = 0.4
    let elasticity: CGFloat = 0.3
    let options = DrawerOption.allValues

    lazy var alphaUnitStep = view.width / maxAlpha
    
    private lazy var dynamicAnimator = UIDynamicAnimator.init(referenceView: view)
    private lazy var collisionBehaviour: UICollisionBehavior = {
        let behaviour = UICollisionBehavior.init(items: [drawerTableView])
        behaviour.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets.init(top: 0, left: -drawerTableView.width - 10,
                                                                                   bottom: 0, right: view.width - drawerTableView.width))
        return behaviour
    }()
    
    private lazy var gravityBehaviour: UIGravityBehavior = {
        let behaviour = UIGravityBehavior.init(items: [drawerTableView])
        behaviour.gravityDirection = CGVector(dx: 1, dy: 0)
        return behaviour
    }()
    private lazy var pushBehaviour: UIPushBehavior = {
        let behaviour = UIPushBehavior.init(items: [drawerTableView], mode: .instantaneous)
        behaviour.magnitude = 0.0
        behaviour.angle = 0.0
        return behaviour
    }()
    private lazy var elasticBehaviour: UIDynamicItemBehavior = {
        let behaviour = UIDynamicItemBehavior.init(items: [drawerTableView])
        behaviour.elasticity = elasticity
        return behaviour
    }()
    
    private var panAttachmentBehaviour: UIAttachmentBehavior?
    
    var isDrawerToggled = true
    var isBeingPanned = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(nibName: String, toggled: Bool){
        self.init(nibName: nibName, bundle: nil)
        isDrawerToggled = toggled
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewDatasourceAndDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupAnimatorProperties()
        if isDrawerToggled {
            handleDrawer(toggled: true)
        }
    }
    
    deinit {
        print("Drawer deinit")
    }
    
}

extension DrawerViewController: UITableViewDelegate, UITableViewDataSource {
    private func setTableViewDatasourceAndDelegate() {
        drawerTableView.delegate = self
        drawerTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell.textLabel?.text = options[indexPath.row].rawValue
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        drawerDelegate?.optionPressed(option: options[indexPath.row])
    }
    
}

extension DrawerViewController: UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate {
    private func setupAnimatorProperties() {
        dynamicAnimator.addBehavior(collisionBehaviour)
        if isDrawerToggled {
          dynamicAnimator.addBehavior(gravityBehaviour)
        }
        dynamicAnimator.addBehavior(pushBehaviour)
        dynamicAnimator.addBehavior(elasticBehaviour)
        dynamicAnimator.delegate = self
    }
    
    func handleDrawer(toggled: Bool) {
        isBeingPanned = false
        isDrawerToggled = toggled
        if toggled {
            UIView.animate(withDuration: 0.4, animations: { self.overlayView.alpha = self.maxAlpha })
            gravityBehaviour.gravityDirection = CGVector(dx: 1, dy: 0)
            pushBehaviour.pushDirection = CGVector(dx: velocityLimit, dy: 0)
        } else {
            UIView.animate(withDuration: 0.4, animations: { self.overlayView.alpha = 0.0 })
            gravityBehaviour.gravityDirection = CGVector(dx: -1, dy: 0)
            pushBehaviour.pushDirection = CGVector(dx: -velocityLimit, dy: 0)
        }
        dynamicAnimator.addBehavior(gravityBehaviour)
        pushBehaviour.active = true
    }
    
    func handlePan(sender: UIScreenEdgePanGestureRecognizer) {
        var location = sender.location(in: view)
        location.y = view.bounds.midY
        
        switch sender.state {
        case .began:
            isBeingPanned = true
            dynamicAnimator.removeBehavior(gravityBehaviour)
            panAttachmentBehaviour = UIAttachmentBehavior.init(item: drawerTableView, attachedToAnchor: location)
            dynamicAnimator.addBehavior(panAttachmentBehaviour!)
        case .changed:
            panAttachmentBehaviour?.anchorPoint = location
            overlayView.alpha = location.x / alphaUnitStep
        case .ended:
            dynamicAnimator.removeBehavior(panAttachmentBehaviour!)
            let velocity = sender.velocity(in: view)
            handleDrawer(toggled: velocity.x > 0)
        default:
            break
        }
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        if !isBeingPanned {
            drawerDelegate?.drawerStateChanged(toggled: isDrawerToggled)
        }
    }
    
}
