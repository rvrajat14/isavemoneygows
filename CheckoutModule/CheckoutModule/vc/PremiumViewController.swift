//
//  PremiumViewController.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/6/20.
//

import UIKit
import StoreKit

public class PremiumViewController: CoBaseViewController {

    @IBOutlet weak var txtOrderNumber: UILabel!
    @IBOutlet weak var txtOrderDate: UILabel!
    @IBOutlet weak var goBackToUpp: UIButton!
    @IBOutlet weak var subscriptionText: UILabel!
    @IBOutlet weak var backButton: UIButton!
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //StoreObserver.shared.restore()
        self.subscriptionText.isHidden = true
//        if transactionsDetails.count > 0 {
//            print("Tnx displayPurchase \(purchasedata.count)")
//            self.displayPurchase(data: )
//        }else {
//            StoreObserver.shared.restore()
//        }
        self.navigationController?.navigationBar.isHidden = true
        goBackToUpp.addTarget(self, action: #selector(gotoApp), for: .touchUpInside)
        let image = backButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.white
        backButton.addTarget(self, action: #selector(gotoApp), for: .touchUpInside)
        
        ValidatePuchase.validate(callback: { data in
            
            DispatchQueue.main.async {
                self.displayPurchase(data: data)
            }
        })
    }

 
    
    func displayPurchase(data: [Any]) {
        
        let pref = AccessPref()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = pref.getStringVal(forKey: AccessPref.PREF_DATE_FORMAT, defVal: "DD/MM/YYYY")
        print("Format date: \(String(describing: dateFormatter.dateFormat))")
        
        for item in data {
            let order = item as! [String: Any]
            self.txtOrderNumber.text = CoUtilities.fetchString(forKey: "orderNum") + "\(order["orderId"]!)"
           
            let orderDate:Int = Int("\(order["purchaseTime"]!)") ?? 0
            let dateFormated:String = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(orderDate/1000)))
            self.txtOrderDate.text = CoUtilities.fetchString(forKey: "orderDate") + "\(dateFormated)"
        
            let prodID = order["sku"] as! String
            if CoConst.SUB_PROD_IDS.contains(prodID) {
                self.subscriptionText.isHidden = false
            }
        }

    }
    
    override func reloadPurchases(){
        
//        //self.transactionsDetails = [Section]()
//
//        for section in purchasedata {
//            if let purchases = section.elements  as? [SKPaymentTransaction] {
//                convertTransaction(purchases: purchases)
//            }
//        }
//
//        if transactionsDetails.count > 0 {
//            self.displayPurchase()
//        }
        
    }
    
//    func convertTransaction(purchases: [SKPaymentTransaction]) {
//
//        for paymentTransaction in purchases {
//            let paymentTransactionDate = [DateFormatter.short(paymentTransaction.transactionDate!)]
//            self.transactionsDetails = [Section(type: .productIdentifier, elements: [paymentTransaction.payment.productIdentifier]),
//                                              Section(type: .transactionIdentifier, elements: [paymentTransaction.transactionIdentifier!]),
//                                              Section(type: .transactionDate, elements: paymentTransactionDate)]
//        }
//    }
    
    @objc func gotoApp() {
  
        dismiss(animated: true)
    
    }
    

  

}
