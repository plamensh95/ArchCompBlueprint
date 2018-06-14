//
//  DrawerViewController.swift
//  FireCart
//
//  Created by Plamen Iliev on 14.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import UIKit

protocol OptionDelegate : class {
    func optionPressed(option: String)
}

class DrawerViewController: UIViewController {
    
    @IBOutlet weak var drawerTableView: UITableView!
    @IBOutlet weak var overlayView: UIView!
    weak var optionDelegate: OptionDelegate?
    
    let velocityLimit: CGFloat = 100.0
    let maxAlpha: CGFloat = 0.4
    let elasticity: CGFloat = 0.3
    let options = ["Option", "Option", "Option", "Option", "Option", "Option", "Option", "Option"]
    
    lazy var alphaUnitStep = view.width / maxAlpha
    private lazy var dynamicAnimator = UIDynamicAnimator.init(referenceView: view)
    private lazy var collisionBehaviour: UICollisionBehavior = {
        let behaviour = UICollisionBehavior.init(items: [drawerTableView])
        behaviour.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 0, left: -drawerTableView.width, bottom: 0, right: view.width - drawerTableView.width))
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
    
    private var panRecognizer = UIPanGestureRecognizer()
    private var panAttachmentBehaviour: UIAttachmentBehavior?
    var isDrawerToggled: Bool = true {
        didSet { handleToggle() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewDatasourceAndDelegate()
        setupGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupAnimatorProperties()
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
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        optionDelegate?.optionPressed(option: String(indexPath.row))
    }
    
    
}

extension DrawerViewController {
    private func setupGestureRecognizer() {
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        view.addGestureRecognizer(panRecognizer)
    }
    
    private func setupAnimatorProperties() {
        dynamicAnimator.addBehavior(collisionBehaviour)
        dynamicAnimator.addBehavior(gravityBehaviour)
        dynamicAnimator.addBehavior(pushBehaviour)
        dynamicAnimator.addBehavior(elasticBehaviour)
    }
    
    private func handleToggle() {
        if isDrawerToggled {
            UIView.animate(withDuration: 0.4) { self.overlayView.alpha = self.maxAlpha }
            gravityBehaviour.gravityDirection = CGVector(dx: 1, dy: 0)
            pushBehaviour.pushDirection = CGVector(dx: velocityLimit, dy: 0)
        } else {
            UIView.animate(withDuration: 0.4) { self.overlayView.alpha = 0.0 }
            gravityBehaviour.gravityDirection = CGVector(dx: -1, dy: 0)
            pushBehaviour.pushDirection = CGVector(dx: -velocityLimit, dy: 0)
        }
        dynamicAnimator.addBehavior(gravityBehaviour)
        pushBehaviour.active = true
    }
    
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        
        var location = sender.location(in: view)
        location.y = view.bounds.midY
        
        switch sender.state {
        case .began:
            dynamicAnimator.removeBehavior(gravityBehaviour)
            panAttachmentBehaviour = UIAttachmentBehavior.init(item: drawerTableView, attachedToAnchor: location)
            dynamicAnimator.addBehavior(panAttachmentBehaviour!)
        case .changed:
            panAttachmentBehaviour?.anchorPoint = location
            overlayView.alpha = location.x / alphaUnitStep
        case .ended:
            dynamicAnimator.removeBehavior(panAttachmentBehaviour!)
            let velocity = sender.velocity(in: view)
            isDrawerToggled = velocity.x > 0
        default:
            break
        }
    }
}
