//
//  SubscriptionViewController.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/6/20.
//

import UIKit
import StoreKit
import ISMLBase
import TinyConstraints

public class SubscriptionViewController: CoBaseViewController {

    @IBOutlet weak var sub1Month: UIButton!
    @IBOutlet weak var sub6Month: UIButton!
    @IBOutlet weak var sub12Month: UIButton!
    
    @IBOutlet weak var sub1MonthPrice: UILabel!
    @IBOutlet weak var sub6MonthPrice: UILabel!
    @IBOutlet weak var sub12MonthPrice: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var privacyPolicy: UIView!
    
    
    lazy var agreeButton: TransButton = {
        var button = TransButton(title: NSLocalizedString("userGree", comment: "Create account"))
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 11)
        
        button.setTitleColor(UIColor(named: "normalTextColor"), for: .normal)
        button.addTarget(self, action: #selector(userAgree), for: .touchUpInside)
        return button
    }()
    
    lazy var privacyPol: TransButton = {
        var button = TransButton(title: NSLocalizedString("privacyPolicy", comment: "Privacy Policy"))
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 11)
        button.setTitleColor(UIColor(named: "normalTextColor"), for: .normal)
        button.addTarget(self, action: #selector(policyTerm), for: .touchUpInside)
        return button
    }()
    
    lazy var privacyAndAgreement: UIView = {
        var vw = UIView()
        vw.height(40)
        let and:UIView = {
            let sep = UIView()
            sep.backgroundColor = UIColor(named: "normalTextColor")
            sep.height(4)
            sep.width(4)
            return sep
        }()
        
        vw.addSubview(and)
        and.centerXToSuperview()
        and.centerYToSuperview()
        
        vw.addSubview(agreeButton)
        agreeButton.centerYToSuperview()
        agreeButton.rightToLeft(of: and, offset: -10)
        
        vw.addSubview(privacyPol)
        privacyPol.centerYToSuperview()
        privacyPol.leftToRight(of: and, offset: 10)
        return vw
    }()
    var oneMonthProduct: SKProduct!
    var sixMonthProduct: SKProduct!
    var twelveMonthProduct: SKProduct!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        sub1Month.addTarget(self, action: #selector(subOneMonth), for: .touchUpInside)
        sub6Month.addTarget(self, action: #selector(subSixMonth), for: .touchUpInside)
        sub12Month.addTarget(self, action: #selector(subTwelveMonth), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
        self.privacyPolicy.addSubview(privacyAndAgreement)
        self.privacyAndAgreement.edgesToSuperview()
        let image = backButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.white
        backButton.addTarget(self, action: #selector(backToApp), for: .touchUpInside)
    }


    @objc func subOneMonth(){
        if oneMonthProduct != nil {
            StoreObserver.shared.buy(oneMonthProduct)
        }
    }
    
    @objc func subSixMonth(){
        if sixMonthProduct != nil {
            StoreObserver.shared.buy(sixMonthProduct)
        }
    }
    
    @objc func subTwelveMonth(){
        if twelveMonthProduct != nil {
            StoreObserver.shared.buy(twelveMonthProduct)
        }
    }
    
    override func reloadPriceDisplay(){
        print("Print Products \(data.count)")
        for section in data {
            if section.type == .availableProducts, let content = section.elements as? [SKProduct] {
                
                for product in content {
                    
                    if product.productIdentifier == CoConst.ONE_MONTH_SUB {
                        oneMonthProduct = product
                        
                        if let formattedPrice = product.regularPrice {
                           sub1MonthPrice.text = "\(formattedPrice)/\(CoUtilities.fetchString(forKey: "month"))"
                        }
                    }
                    
                    if product.productIdentifier == CoConst.SIX_MONTH_SUB {
                        sixMonthProduct = product
                        if let formattedPrice = product.regularPrice {
                           sub6MonthPrice.text = "\(formattedPrice)/6-\(CoUtilities.fetchString(forKey: "months"))"
                        }
                    }
                    
                    if product.productIdentifier == CoConst.TWELVE_MONTH_SUB {
                        twelveMonthProduct = product
                        if let formattedPrice = product.regularPrice {
                           sub12MonthPrice.text = "\(formattedPrice)/12-\(CoUtilities.fetchString(forKey: "months"))"
                        }
                    }
                    
                }
                // let product = content[0]
                
               
            } else if section.type == .invalidProductIdentifiers, let content = section.elements as? [String] {
                // if there are invalid product identifiers, show them.
                print("Invalid product \(content[0])")
            }
        }
    }
    
    func gotoPremiumPage(){
        let vc = PremiumViewController(nibName: "PremiumViewController", bundle: Bundle(identifier: CoConst.BUNDLE_ID))
        vc.transactionsDetails = self.transactionsDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func purchaceSuccess(){
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
        
        if isUserPremium {
            self.gotoPremiumPage()
        }
        
    }
    
    
    @objc func backToApp() {
        
        //appDelegate.navigateTo(instance: ViewController())
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    @objc func userAgree() {
        let vc = UserAgreeViewController(nibName: "UserAgreeViewController", bundle: nil)
        let viewControllerNavController = UINavigationController(rootViewController: vc)
        self.present(viewControllerNavController, animated: true)
    }
    
    @objc func policyTerm() {
        let vc = PrivacyViewController(nibName: "PrivacyViewController", bundle: nil)
        let viewControllerNavController = UINavigationController(rootViewController: vc)
        self.present(viewControllerNavController, animated: true)
    }
}
