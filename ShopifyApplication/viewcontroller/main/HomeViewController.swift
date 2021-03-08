//
//  HomeViewController.swift
//  ShopifyApplication
//
//  Created by puma on 06/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OptionRemoveButtonDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var plusBtn: UIButton!
    
    var productList: [Product] = [Product]()
    
    var uuid = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130.0
        
        plusBtn.layer.cornerRadius = 25
        plusBtn.layer.masksToBounds = true

        loadData()
        
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        
        
        
    }
    
    
    @IBAction func onRefresh(_ sender: Any) {
        loadData()
    }
    
    func loadData() {
        
        uuid = UserDefaultStandard.share.getString(key: PREF_UUID)
        if uuid.isEmpty {
            return
        }
        
//        let parentView = self.parent?.view
        let spinnerView = UIView.init(frame: parentView!.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        spinnerView.addSubview(ai)
        self.view.addSubview(spinnerView)
        
        let productDB = Database.database().reference().child("\(PRODUCTDB)/\(uuid)")
        
        productDB.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let productIds = snapshot.value as? String {
                    self.loadDataWithIds(productsIds: productIds, spinnerView: spinnerView)
                } else {
                    spinnerView.removeFromSuperview()
                }
                
            } else {
                spinnerView.removeFromSuperview()
            }
        })
    }
    
    func loadDataWithIds(productsIds: String, spinnerView: UIView) {
        
        let headers: HTTPHeaders = [
            "Authorization": BASICAUTH,
            "Accept": "application/json"
        ]
        
        self.productList.removeAll()
        
        Alamofire.request(Get_Products + "?ids=\(productsIds)", method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString),headers: headers)
            .responseJSON { response in
                
                spinnerView.removeFromSuperview()
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error productList")
                    
                    return
                }
                
                if let json = response.result.value as? [String:Any] {
                    if let jsonValue = json["products"] as? [Any] {
                        self.productList = Product.parseArray(jsonValue: jsonValue)
                    }
                }
                
                self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:ProductTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "productcell") as! ProductTableViewCell
        
        cell.baseView.layer.cornerRadius = 10
        cell.baseView.layer.masksToBounds = true
        cell.productIV.layer.cornerRadius = 8
        cell.productIV.layer.masksToBounds = true
        
        let product = self.productList[indexPath.row]
        cell.priceLb.text = product.getPrice()
        cell.titleLb.text = product.title
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.productIV.image = nil
        if product.images.count != 0 {
            let image = product.images[0]
            if !image.src.isEmpty {
                Alamofire.request(image.src, method: .get, parameters: nil,headers: nil).responseData { response in
                    if let image = response.result.value {
                        //                    cell.productIV.image = UIImage(data: image)
                        let size = CGSize(width: 100, height: 100)
                        
                        let changedImage = UIImage(data: image)?.crop(to: size)
                        cell.productIV.image = changedImage
                    }
                }
            }
        }
        
        
        
        return cell
    }
    
    func onRemoveTrapped(at index: IndexPath) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.deleteProduct(index: index.row)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            print("cancel")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func deleteProduct(index: Int) {
        
        let product = self.productList[index]
        
        let spinnerView = UIView.init(frame: parentView!.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        spinnerView.addSubview(ai)
        self.view.addSubview(spinnerView)
        
        let headers: HTTPHeaders = [
            "Authorization": BASICAUTH,
            "Accept": "application/json"
        ]
        
        Alamofire.request(Delete_Products + "\(product.id).json", method: .delete, parameters: nil, encoding: URLEncoding(destination: .queryString),headers: headers)
            .responseJSON { response in
                
                spinnerView.removeFromSuperview()
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    MyAlertDialog.share.showAlert(vc: self, title: "Error!", message: "This product doesn't removed.")
                    return
                }
                MyAlertDialog.share.showAlert(vc: self, title: "Removed successfully!", message: "")
                self.productList.remove(at: index)
                self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        DetailViewController.product_static = self.productList[indexPath.row]
        self.performSegue(withIdentifier: "hometodetail", sender: nil)
        
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        
        UserDefaultStandard.share.saveString(value: "false", key: PREF_LOGIN)
        self.performSegue(withIdentifier: "hometosignin", sender: nil)
    }

}
