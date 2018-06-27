//
//  CartTableViewCell.swift
//  FireCart
//
//  Created by Plamen Iliev on 22.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import UIKit

protocol CartTableViewCellDelegate : class {
    func countPressed(_ sender: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell, ImageCellProtocol {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var countButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productIngredientsLabel: UILabel!
    @IBOutlet weak var productSizeLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    weak var delegate: CartTableViewCellDelegate?

    func setCellImage(imageData: Data?) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            if let data = imageData, let image = UIImage(data: data) {
                self.productImageView.image = image
            } else {
                self.productImageView.image = nil
            }
        }
    }
    
    func configureCell(product: CartProduct) {
        productNameLabel.text = product.name
        productSizeLabel.text = "\(product.size)g"
        productPriceLabel.text = "\(product.price * Double(product.count))$"
        countButton.setTitle("\(product.count)", for: .normal)
        productIngredientsLabel.text = product.ingredients
    }
    
    @IBAction func countButtonPressed(_ sender: UIButton) {
        delegate?.countPressed(self)
    }
}
