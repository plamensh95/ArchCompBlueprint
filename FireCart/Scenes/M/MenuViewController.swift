//
//  MenuViewController.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, MenuPresenterToViewProtocol {

    var categories = [FRTCategory]()
    var storedOffsets = [Int: CGFloat]()
    var presenter: MenuPresenter!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var cartImageView: UIImageView!
    
    var movingCell: UIImageView!
    var movingProduct: FRTProduct?
    
    let elasticity: CGFloat = 0.1
    let velocityLimit: CGFloat = 50.0
    
    private lazy var dynamicAnimator = UIDynamicAnimator.init(referenceView: view)
    private lazy var collisionBehaviour: UICollisionBehavior = {
        let behaviour = UICollisionBehavior.init(items: [cartImageView])
        behaviour.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets.init(top: view.height - cartImageView.height, left: 0,
                                                                                   bottom: -cartImageView.height - 10, right: 0))
        return behaviour
    }()
    
    private lazy var gravityBehaviour: UIGravityBehavior = {
        let behaviour = UIGravityBehavior.init(items: [cartImageView])
        behaviour.gravityDirection = CGVector(dx: 0, dy: 1)
        return behaviour
    }()
    private lazy var pushBehaviour: UIPushBehavior = {
        let behaviour = UIPushBehavior.init(items: [cartImageView], mode: .instantaneous)
        behaviour.magnitude = 0.0
        behaviour.angle = 0.0
        return behaviour
    }()
    private lazy var elasticBehaviour: UIDynamicItemBehavior = {
        let behaviour = UIDynamicItemBehavior.init(items: [cartImageView])
        behaviour.elasticity = elasticity
        return behaviour
    }()
    
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
        MenuConfigurator.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViewDelegateAndDatasource()
        presenter.loadMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        categoriesTableView.removeTableFooterView()
        setupAnimatorProperties()
    }
    
    deinit {
        print("Menu deinit")
    }
    
    private func setupAnimatorProperties() {
        dynamicAnimator.addBehavior(collisionBehaviour)
        dynamicAnimator.addBehavior(gravityBehaviour)
        dynamicAnimator.addBehavior(pushBehaviour)
        dynamicAnimator.addBehavior(elasticBehaviour)
    }

    // MARK: - PresenterToViewProtocol
    func displayMenu(content: [FRTCategory]) {
        categories = content
        categoriesTableView.reloadData()
    }
    
    func displayAddedToCart(product: FRTProduct) {
        
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableViewDelegateAndDatasource () {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? GroupTableViewCell else { return UITableViewCell() }
        cell.categoryLabel.text = categories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? GroupTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? GroupTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let products = categories[collectionView.tag].products else { return 0 }
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        if let products = categories[collectionView.tag].products {
            cell.activityIndicator.startAnimating()
            cell.productImageView.image = nil
            presenter.loadImage(from: products[indexPath.row], for: cell)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}

extension MenuViewController: ProductCellDelegate {
    func longPressed(sender: UIScreenEdgePanGestureRecognizer, cell: ProductCollectionViewCell) {
        let location = sender.location(in: view)
        
        switch sender.state {
        case .began:
            UIGraphicsBeginImageContext(cell.size)
            cell.layer.render(in: UIGraphicsGetCurrentContext()!)
            let cellImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            movingCell = UIImageView(image: cellImage)
            movingCell.center = location
            movingCell.alpha = 0.75
            view.addSubview(movingCell)
            gravityBehaviour.gravityDirection = CGVector(dx: 0, dy: -1)
            pushBehaviour.pushDirection = CGVector(dx: 0, dy: -velocityLimit)
            pushBehaviour.active = true
            guard let categoryIndexPath = categoriesTableView.indexPathForRow(at: location), let categoryCell = categoriesTableView.cellForRow(at: categoryIndexPath) as? GroupTableViewCell,
                let productIndexPath = categoryCell.productsCollectionView.indexPath(for: cell), let products = categories[categoryIndexPath.row].products else { return }
            movingProduct = products[productIndexPath.row]
        case .changed:
            movingCell.center = location
        case .ended:
            movingCell.removeFromSuperview()
            gravityBehaviour.gravityDirection = CGVector(dx: 0, dy: 1)
            pushBehaviour.pushDirection = CGVector(dx: 0, dy: velocityLimit)
            pushBehaviour.active = true
            if movingCell!.frame.intersects(cartImageView.frame), let addedProduct = movingProduct {
                presenter.addToCart(product: addedProduct)
                movingProduct = nil
            }
        default:
            break
        }
    }
    
}

