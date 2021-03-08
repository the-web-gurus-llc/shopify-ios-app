//
//  Product.swift
//  ShopifyApplication
//
//  Created by puma on 06/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import Foundation

class Product: NSObject {
    
    var id: Int64
    var title: String
    var images: [MyImage]
    var variant: Variants
    var body_html: String
    
    override init() {
        id = 0
        title = ""
        images = [MyImage]()
        variant = Variants()
        body_html = ""
    }
    
    func getPrice() -> String {
        if variant.price == "" {
            return "free"
        }
        if variant.price == "free" {
            return "free"
        }
        return "$\(variant.price)"
    }
    
    static func parseArray(jsonValue: [Any]) -> [Product] {
        
        print(jsonValue)
        
        var products = [Product]()
        
        for obj in jsonValue {
            if let productOne = obj as? [String:Any] {
                let product = Product()
                product.id = productOne["id"] as? Int64 ?? 0
                product.title = productOne["title"] as? String ?? ""
                if let imgs = productOne["images"] as? [[String:Any]] {
                    for imgObj in imgs {
                        let image = MyImage()
                        image.id = imgObj["id"] as? Int64 ?? 0
                        image.product_id = imgObj["product_id"] as? Int64 ?? 0
                        image.src = imgObj["src"] as? String ?? ""
                        product.images.append(image)
                    }
                }
                product.body_html = productOne["body_html"] as? String ?? ""
                if let variantObj = productOne["variants"] as? [Any]
                {
                    if variantObj.count != 0 {
                        if let variant = variantObj[0] as? [String:Any] {
                            product.variant.price = variant["price"] as? String ?? "free"
                        }
                    }
                }
                products.append(product)
            }
        }
        
        return products
    }
    
}
