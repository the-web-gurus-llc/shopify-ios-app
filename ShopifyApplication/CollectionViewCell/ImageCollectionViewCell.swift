//
//  ImageCollectionViewCell.swift
//  ShopifyApplication
//
//  Created by puma on 10/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import UIKit

protocol OptionDelegate{
    func onDeleteButtonTapped(at index:IndexPath)
}

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productIV: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    var delegate: OptionDelegate!
    var indexPath: IndexPath!
    
    @IBAction func onClickButton(_ sender: Any) {
        self.delegate.onDeleteButtonTapped(at: indexPath)
    }
    
}
