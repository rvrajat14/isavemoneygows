//
//  PurchaseViewController.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/5/20.
//

import UIKit
import StoreKit

public class PurchaseViewController: CoBaseViewController {

    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var restorePurchase: UIButton!
    @IBOutlet weak var lowCostSub: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    var selectedProduct: SKProduct!
    
    var isGotoPremium = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    
        self.navigationController?.navigationBar.isHidden = true
        restorePurchase.addTarget(self, action: #selector(restPurchase), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(buyProduct), for: .touchUpInside)
        lowCostSub.addTarget(self, action: #selector(accessSubscription), for: .touchUpInside)
        lowCostSub.isHidden = true
        
    
        let image = backButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.white
        backButton.addTarget(self, action: #selector(backToApp), for: .touchUpInside)
        // Do any additional setup after loading the view.
        //StoreObserver.shared.restore()
    }

    override func reloadPriceDisplay(){
        print("Print Products \(data.count)")
        for section in data {
            if section.type == .availableProducts, let content = section.elements as? [SKProduct] {
                
                for product in content {
                    // Show the localized title of the product.
                    //print("Title product \(product.localizedTitle)")
                    //print("Product \(product.productIdentifier)")
                    
                    // Show the product's price in the locale and currency returned by the App Store.
                    if let formattedPrice = product.regularPrice {
                        //print("Formatted Price \(formattedPrice)")
                        print("Product \(product.productIdentifier) \(formattedPrice) \(product.localizedTitle) Subid \(product.subscriptionGroupIdentifier)")
                        var buyLabel = CoUtilities.fetchString(forKey: "txtBuyFor").replacingOccurrences(of: "%buyprice%", with: formattedPrice)
                        buyButton.setTitle(buyLabel, for: .normal)
                    }
                    
                    if product.productIdentifier == CoConst.PREMIUN_PRO {
                        selectedProduct = product
                    }
                    
                    if product.subscriptionGroupIdentifier != nil {
                        lowCostSub.isHidden = false
                    }
                    
                    
                }
                // let product = content[0]
                
               
            } else if section.type == .invalidProductIdentifiers, let content = section.elements as? [String] {
                // if there are invalid product identifiers, show them.
                print("Invalid product \(content[0])")
            }
        }
    }
    
    @objc func buyProduct() {
        if selectedProduct != nil {
            StoreObserver.shared.buy(selectedProduct)
        }
        
    }
    
    @objc func restPurchase() {
        StoreObserver.shared.restore()
      
    }
    
    @objc func accessSubscription(){
        let vc = SubscriptionViewController(nibName: "SubscriptionViewController", bundle: Bundle(identifier: CoConst.BUNDLE_ID))
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
        
    @objc func backToApp() {
        
        //appDelegate.navigateTo(instance: ViewController())
        dismiss(animated: true)
        //self.navigationController?.popViewController(animated: true)
        //self.navigationController?.navigationBar.isHidden = false
        
        
    }
    
    func gotoPremiumPage(){
        let vc = PremiumViewController(nibName: "PremiumViewController", bundle: Bundle(identifier: CoConst.BUNDLE_ID))
        vc.transactionsDetails = self.transactionsDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func purchaceSuccess() {
        print("purchaceSuccess gotoPremiumPage")
        gotoPremiumPage()
    }
    override func reloadPurchases(){
        
        //self.transactionsDetails = [Section]()
        var isUserPremium = false
        for section in purchasedata {
            if let purchases = section.elements  as? [SKPaymentTransaction] {
                self.transactionsDetails = OrderProcess.convertTransaction(purchases: purchases)
                for transaction in purchases {
                    let title = StoreManager.shared.title(matchingIdentifier: transaction.payment.productIdentifier)
                
                    print("Purchase \(title ?? transaction.payment.productIdentifier)")
                    
                    if CoConst.VALID_PROD_IDS.contains(transaction.payment.productIdentifier) {
                        print("You Are Premium")
                        isUserPremium = true
                    }
                }
               
                
            }
        }
        
        if isUserPremium && !isGotoPremium {
            self.isGotoPremium = true
            self.gotoPremiumPage()
        }
        
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
