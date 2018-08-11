/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The detail view controller navigated to from our main and results table.
*/

import UIKit

class DetailViewController: UIViewController {
    // MARK: Types

    // Constants for Storyboard/ViewControllers.
    static let storyboardName = "MainStoryboard"
    static let viewControllerIdentifier = "DetailViewController"
    
    // Constants for state restoration.
    static let restoreProduct = "restoreProductKey"
    
    // MARK: Properties
    
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var couponView: UIView!
    
    
    
    
    var product: Product!
    
    // MARK: Initialization
    
    class func detailViewControllerForProduct(_ product: Product) -> DetailViewController {
        let storyboard = UIStoryboard(name: DetailViewController.storyboardName, bundle: nil)

        let viewController = storyboard.instantiateViewController(withIdentifier: DetailViewController.viewControllerIdentifier) as! DetailViewController
        
        viewController.product = product
        
        return viewController
    }
    
    // MARK: View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = product.title
        
        yearLabel.text = "\(product.yearIntroduced)"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.formatterBehavior = .default
        let priceString = numberFormatter.string(from: NSNumber(value: product.introPrice))
        priceLabel.text = priceString
        
        stockOrPricePending(product)
        
        
    }
    
    // MARK: UIStateRestoration

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        // Encode the product.
        coder.encode(product, forKey: DetailViewController.restoreProduct)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        // Restore the product.
        if let decodedProduct = coder.decodeObject(forKey: DetailViewController.restoreProduct) as? Product {
            product = decodedProduct
        }
        else {
            fatalError("A product did not exist. In your app, handle this gracefully.")
        }
    }
    
    //Check for product with low stock or variable pricing
    func stockOrPricePending (_ product : Product) {
        
        //Plug for version 1.0 release, for 2.0, ping the inventory API
        
        //Below products have low inventory
        
        if product.title == Product.Hardware.iMac.rawValue {
            //priceLabel.hidden = true
            priceLabel.text = "Please call for pricing"
            
            
        }
        
        if product.title == Product.Hardware.iPod.rawValue {
            //priceLabel.hidden = true
            priceLabel.text = "Please call for pricing"
        }
        
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            checkAllProductsForCoupons()
            
        }
    }
    
    func checkAllProductsForCoupons(){
        
        for i in (0..<products.count).reversed() {
            let product = products[i]
            checkCurrentCoupon(product)
        }
    }
    
    func checkCurrentCoupon(_ product : Product){
        
        switch product.title{
        case "iPad":
            showCouponView()
            break
        default:
            //No coupon, do Nothing
            break
        }
    }
    
    func showCouponView(){

        self.couponView.isHidden = false
        self.view.bringSubview(toFront: self.couponView)
    }
    
    @IBAction func actionSheetButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Ooops", message: "You better try redeeming from a REAL iPhone :)", preferredStyle: .alert) // 1
        
        present(alert, animated: true, completion:nil) // 6
        
        DispatchQueue.main.async { () -> Void in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                alert.dismiss(animated: true, completion: nil)
            })
    }
    }
}
