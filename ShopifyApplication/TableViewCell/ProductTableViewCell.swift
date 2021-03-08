//
//  ProductTableViewCell.swift
//  ShopifyApplication
//
//  Created by puma on 06/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import UIKit

protocol OptionRemoveButtonDelegate {
    func onRemoveTrapped(at index:IndexPath)
}

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var productIV: UIImageView!
    @IBOutlet weak var baseView: UIView!
    
    var delegate: OptionRemoveButtonDelegate!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func onClickRemove(_ sender: Any) {
        self.delegate.onRemoveTrapped(at: indexPath)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
