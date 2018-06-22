//
//  GroupTableViewCell.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
}

extension GroupTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        productsCollectionView.delegate = dataSourceDelegate
        productsCollectionView.dataSource = dataSourceDelegate
        productsCollectionView.tag = row
        productsCollectionView.setContentOffset(productsCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        productsCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { productsCollectionView.contentOffset.x = newValue }
        get { return productsCollectionView.contentOffset.x }
    }
}
