//
//  DetailViewController.swift
//  ShopifyApplication
//
//  Created by puma on 07/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var product_static: Product!
    var product: Product!
    var productImageArray = [MyImage]()
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var desTV: UITextView!
    
    @IBOutlet weak var myCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        product = DetailViewController.product_static
        
        titleLb.text = product.title
        priceLb.text = product.getPrice()
        desTV.attributedText = product.body_html.htmlToAttributedString
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        loadData()
//        if !product.image.src.isEmpty {
//            Alamofire.request(product.image.src, method: .get, parameters: nil,headers: nil).responseData { response in
//                if let image = response.result.value {
////                    self.productIV.image = UIImage(data: image)
//
//                    let size = CGSize(width: 100, height: 100)
//
//                    let changedImage = UIImage(data: image)?.crop(to: size)
//                    self.productIV.image = changedImage
//
//                }
//            }
//        }
        
    }
    
    func loadData() {
        productImageArray = product.images
        myCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 2
        return self.productImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((120)), height: CGFloat(120))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.productIV.layer.cornerRadius = 10
        cell.productIV.layer.masksToBounds = true
        
        let image = self.productImageArray[indexPath.row]
        cell.productIV.image = nil
        if !image.src.isEmpty {
            Alamofire.request(image.src, method: .get, parameters: nil,headers: nil).responseData { response in
                if let image = response.result.value {
                    let size = CGSize(width: 100, height: 100)

                    let changedImage = UIImage(data: image)?.crop(to: size)
                    cell.productIV.image = changedImage

                }
            }
        }
        
        return cell
    }

}
