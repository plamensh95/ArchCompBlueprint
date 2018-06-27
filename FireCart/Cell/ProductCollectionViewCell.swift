//
//  ProductCollectionViewCell.swift
//  FireCart
//
//  Created by Plamen Iliev on 20.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import UIKit

protocol ImageCellProtocol {
    func setCellImage(imageData: Data?)
}

protocol ProductCellDelegate: class {
    func longPressed(sender: UIScreenEdgePanGestureRecognizer, cell: ProductCollectionViewCell)
}

class ProductCollectionViewCell: UICollectionViewCell, ImageCellProtocol {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var longPressRecognizer = UILongPressGestureRecognizer()
    
    weak var delegate: ProductCellDelegate?
    
    override func awakeFromNib() {
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        longPressRecognizer.delegate = self
        addGestureRecognizer(longPressRecognizer)
    }
    
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
    

}

extension ProductCollectionViewCell: UIGestureRecognizerDelegate {
    
    @objc func handleLongPress(sender: UIScreenEdgePanGestureRecognizer) {
        delegate?.longPressed(sender: sender, cell: self)
    }
    
}
