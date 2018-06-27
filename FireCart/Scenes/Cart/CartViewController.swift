//
//  CartViewController.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, CartPresenterToViewProtocol {

    var presenter: CartPresenter!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    private var indexPathOfProductBeingEdited: IndexPath?
    
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
        CartConfigurator.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViewDelegate()
        presenter.loadCart()
    }
    
    deinit {
        print("Cart deinit")
    }

    // MARK: - PresenterToViewProtocol
    func displayCart() {
        cartTableView.reloadData()
    }
    
    func displayCartUpdate(at indexPath: IndexPath, action: TableViewRowAction) {
        switch action {
        case .reload:
            cartTableView.reloadRows(at: [indexPath], with: .fade)
            break
        case .insert:
            cartTableView.insertRows(at: [indexPath], with: .fade)
            break
        case .delete:
            cartTableView.deleteRows(at: [indexPath], with: .fade)
            break
        }
    }
    
    func displayTotals(totalCount: Int, totalPrice: Double) {
        totalCountLabel.text = "Items count : \(totalCount)"
        totalPriceLabel.text = "Total cost : \(totalPrice.format(f: ".2"))"
    }
    
    func displayError(error: String) {
        UIAlertController(title: DialogTittles.error.rawValue, message: error , defaultActionButtonTitle: "OK", tintColor: UIColor.blue).show()
    }
    
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate, CartTableViewCellDelegate {

    private func setupTableViewDelegate() {
        cartTableView.dataSource = self
        cartTableView.delegate = self
        cartTableView.allowsSelectionDuringEditing = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.cartProductsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        let product = presenter.cartProduct(at: indexPath.row)
        cell.delegate = self
        cell.configureCell(product: product)
        cell.activityIndicator.startAnimating()
        cell.productImageView.image = nil
        presenter.loadImage(from: product, for: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        presenter.cartProductDeleteButtonPressed(at: indexPath.row)
    }
    
    func countPressed(_ sender: CartTableViewCell) {
        if let indexpath = cartTableView.indexPath(for: sender) {
            indexPathOfProductBeingEdited = indexpath
            let product = presenter.cartProduct(at: indexpath.row)
            displayPicker(initialValue: Int(product.count))
        }
    }
    
}

extension CartViewController: PickerViewControllerDelegate {
    private func displayPicker(initialValue: Int) {
        let picker = PickerViewController(nibName: "PickerViewController", initialValue: initialValue, pickerValues: Array(1...20))
        addViewControllerFillBounds(containedViewController: picker, in: view)
        picker.pickerViewControllerDelegate = self
    }
    
    func numberPicked(number: Int) {
        guard let indexPath = indexPathOfProductBeingEdited else { return }
        presenter.cartCountEditedForProduct(at: indexPath.row, newCount: number)
        removeChildViewController(ofType: PickerViewController.self)
        indexPathOfProductBeingEdited = nil
    }
    
}
