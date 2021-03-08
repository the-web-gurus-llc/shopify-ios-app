//
//  AddProductViewController.swift
//  ShopifyApplication
//
//  Created by puma on 07/09/2019.
//  Copyright © 2019 puma. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import Firebase

class AddProductViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, OptionDelegate {
    
    let SCROLLVIEWBASEHEIGHT: CGFloat = 560
    
    @IBOutlet weak var parentView: UIView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var jewelryTypeDD: DropDown!
    @IBOutlet weak var photoIV: UIImageView!
    
    @IBOutlet weak var refEt: UITextField!
    @IBOutlet weak var priceEt: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var baseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var defaultContainer: UIView!
    @IBOutlet weak var braceletContainer: UIView!
    @IBOutlet weak var ringContainer: UIView!
    
    @IBOutlet weak var additionalDesTV: UITextView!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    var defaultVC: DefaultViewController!
    var braceletVC: BraceletViewController!
    var ringVC: RingViewController!
    var selVC: ViewController!
    
    var imageArray = [UIImage]()
    
    var imagePicker: UIImagePickerController!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "braceletvcsegue" {
            if let vc = segue.destination as? BraceletViewController {
                braceletVC = vc
                selVC = braceletVC
                visibleSelectedView(container: braceletContainer)
            }
        }
        
        if segue.identifier == "defaultvcsegue" {
            if let vc = segue.destination as? DefaultViewController {
                defaultVC = vc
            }
        }
        
        if segue.identifier == "ringvcsegue" {
            if let vc = segue.destination as? RingViewController {
                ringVC = vc
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        initJewelryTypeDD()
        initPhotoIV()
        initEts()
        initButton()
        initAdditionalTV()
    }
    
    func onDeleteButtonTapped(at index: IndexPath) {
        self.imageArray.remove(at: index.row)
        self.myCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 2
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((120)), height: CGFloat(120))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.productIV.layer.cornerRadius = 10
        cell.productIV.layer.masksToBounds = true
        cell.productIV.image = self.imageArray[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func initAdditionalTV() {
        additionalDesTV.layer.cornerRadius = 5
        additionalDesTV.layer.masksToBounds = true
        additionalDesTV.layer.borderColor = UIColor.gray.cgColor
        additionalDesTV.layer.borderWidth = 1
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        submitNewProduct()
    }
    
    func submitNewProduct() {
        
        var price = priceEt.text!
        if !price.isEmpty {
            price = "$\(price)"
        }
        let title = selVC.getTitle(jewelryType: jewelryTypeDD.text!)
        var bodyHtml = selVC.getDescription(ref: refEt.text!)
        
        var addDes = additionalDesTV.text!
        if !addDes.isEmpty {
            addDes = addDes.replacingOccurrences(of: "\n", with: VALUE_ENTER)
            bodyHtml = bodyHtml + addDes + VALUE_ENTER
        }
        
        let headers: HTTPHeaders = [
            "Authorization": BASICAUTH,
            "Accept": "application/json"
        ]
        
        var imagesStringArray = [[String:String]]()
        for item in imageArray {
            imagesStringArray.append(["attachment":convertImageToBase64String(image: item)])
        }
        
        let parameters: Parameters = [
            "product": [
                "title": title,
                "body_html": bodyHtml,
                "images": imagesStringArray,
                "variants": [
                    [
                        "price": price
                    ]
                ]
            ]
        ]
        
        let spinnerView = UIView.init(frame: parentView!.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        spinnerView.addSubview(ai)
        self.view.addSubview(spinnerView)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        manager.request(Post_Products, method: .post, parameters: parameters, encoding: URLEncoding.default,headers: headers)
            .responseJSON { response in

                spinnerView.removeFromSuperview()

                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    self.failed()
                    print("error postProduct")
                    return
                }
                
                var productID: Int64 = 0

                if let json = response.result.value as? [String:Any] {
                    if let jsonValue = json["product"] as? [String:Any] {
                        if let product = jsonValue["id"] as? Int64 {
                            productID = product
                        }
                    }
                }
                
                if productID == 0 {
                    self.failed()
                } else {
                    self.success(productID: productID)
                }
        }
    }
    
    func success(productID: Int64) {
        let currentUUID = UserDefaultStandard.share.getString(key: PREF_UUID)
        if currentUUID.isEmpty {
            MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "Item saved failed")
            return
        }
        
        let productDB = Database.database().reference().child("\(PRODUCTDB)/\(currentUUID)")
        
        productDB.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if let productIds = snapshot.value as? String {
                    productDB.setValue("\(productIds),\(String(productID))")
                    self.showSuccessAlert()
                } else {
                    self.failed()
                }
                
            } else {
                productDB.setValue(String(productID))
                self.showSuccessAlert()
            }
        })
    }
    
    func showSuccessAlert() {
        
        let alert = UIAlertController(title: "Success", message: "Submitted Successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func failed() {
        MyAlertDialog.share.showAlert(vc: self, title: "Failed", message: "")
    }
    
    func didSelectJewelry(index: Int) {
        switch index {
        case 0:
            selVC = braceletVC
            visibleSelectedView(container: braceletContainer)
        case 11:
            selVC = ringVC
            visibleSelectedView(container: ringContainer)
        default:
            selVC = defaultVC
            visibleSelectedView(container: defaultContainer)
        }
    }
    
    func visibleSelectedView(container: UIView) {
        
        defaultContainer.isHidden = true
        braceletContainer.isHidden = true
        ringContainer.isHidden = true
        
        container.isHidden = false
        
        baseViewHeight.constant = selVC.selfSize()
        scrollViewHeight.constant = selVC.selfSize() + SCROLLVIEWBASEHEIGHT
    }
    
    func initJewelryTypeDD() {
        var array = [String]()
        for item in jewelryTypeArray {
            array.append(" \(item)")
        }
        jewelryTypeDD.optionArray = array
        jewelryTypeDD.text = array[0]
        jewelryTypeDD.didSelect{(selectedText , index ,id) in
            self.didSelectJewelry(index: index)
        }
        jewelryTypeDD.layer.cornerRadius = 5
        jewelryTypeDD.layer.borderColor = UIColor.gray.cgColor
        jewelryTypeDD.layer.borderWidth = 1
        jewelryTypeDD.layer.masksToBounds = true
    }
    
    func initButton() {
        submitBtn.layer.cornerRadius = 10
        submitBtn.layer.masksToBounds = true
    }
    
    func initEts() {
        //refEt.delegate = self
        //priceEt.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case refEt:
            priceEt.becomeFirstResponder()
        case priceEt:
            priceEt.resignFirstResponder()
        default:
            print("textFieldShouldReturn Error!")
        }
        return false
    }
    
    @IBAction func onClickBack(_ sender: Any) {
//        self.performSegue(withIdentifier: "addproducttohome", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func initPhotoIV() {
        
        photoIV.layer.cornerRadius = 8
        photoIV.layer.masksToBounds = true
        photoIV.layer.borderColor = UIColor.gray.cgColor
        photoIV.layer.borderWidth = 1
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        photoIV.isUserInteractionEnabled = true
        photoIV.addGestureRecognizer(singleTap)
    }
    
    @objc func tapDetected() {
        
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Select photo from gallery", style: .default , handler:{ (UIAlertAction)in
            self.selectImageFrom(.photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Capture photo from camera", style: .default , handler:{ (UIAlertAction)in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.selectImageFrom(.camera)
            } else {
                MyAlertDialog.share.showAlert(vc: self, title: MyAlertDialog.WARNING, message: "No Camera.")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func convertImageToBase64String(image: UIImage) -> String {
        let imageData = image.pngData()
        let imageString = imageData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters) ?? ""
        return imageString
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        let size = CGSize(width: 400, height: 400)
        let image = selectedImage.crop(to: size)
        
        //let imageData = image.pngData()
        //self.imageString = imageData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters) ?? ""
        //photoIV.image = image
        self.imageArray.append(image)
        myCollectionView.reloadData()
    }
}
