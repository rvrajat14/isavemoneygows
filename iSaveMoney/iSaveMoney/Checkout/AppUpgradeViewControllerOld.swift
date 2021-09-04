////
////  AppUpgradeViewController.swift
////  iSaveMoney
////
////  Created by Armel Koudoum on 11/24/17.
////  Copyright © 2017 UlmatCorpit. All rights reserved.
////
//
//import UIKit
//import Firebase
//import SwiftyStoreKit
//import StoreKit
//import FirebaseFirestore
//import ISMLDataService
//import ISMLBase
//
//var sharedSecret = "3bee5e8da5a94f64a0b1a3cb270746d2"
//
//enum RegisteredPurchaseOld: String {
//    case iSaveMoneyPro = "com.ulmatcorpit.iSaveMoneyGo.UnlockPRO"
//}
//
//class NetworkActivityIndicatorManager: NSObject {
//    public static var loadingCount = 0
//    class func NetworkOperationStarted(baseViewController: BaseViewController) {
//        if loadingCount == 0 {
//            baseViewController.indicatorShow()
//            //UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
//        loadingCount += 1
//    }
//    class func networkOperationFinished(baseViewController: BaseViewController) {
//        if loadingCount > 0 {
//            loadingCount -= 1
//        }
//        if loadingCount == 0 {
//            baseViewController.indicatorHide()
//            //UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }
//    }
//}
//class AppUpgradeViewController: BaseViewController, UIScrollViewDelegate {
//    
//    var ref: Firestore!
//    var pref: MyPreferences!
//    var flavor:Flavor!
//    var appDelegate:AppDelegate!
//    
//    var fbUser:FbUser!
//    
//    
//    let bundleID = "com.ulmatcorpit.iSaveMoneyGo"
//    //var iSaveMoneyPro = RegisteredPurchase.iSaveMoneyPro
//    var appleValidator:AppleReceiptValidator!
//    
//
//    var purchaseButton:UIButton!
//    var verificationButton:UIButton!
//    var cancelButton:UIButton!
//    var stackViewWrapper:UIStackView!
//    
//    static var viewIdentifier:String = "AppUpgradeViewController"
//    
//    
//    var scrollView:UIScrollView!
//    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
//    
//    var pageControl : UIPageControl!
//    
//    
//    //features
//    var labelTitleFeature1:UILabel!
//    var labelDescriptionFeature1:UILabel!
//    var imgFeature1: UIImageView!
//    var featureSctackView1:UIStackView!
//    //
//    var labelTitleFeature2:UILabel!
//    var labelDescriptionFeature2:UILabel!
//    var imgFeature2: UIImageView!
//    var featureSctackView2:UIStackView!
//
//    
//    public override func getTag() -> String {
//        
//        return "AppUpgradeViewController"
//    }
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        appleValidator = AppleReceiptValidator(service: .production)
//        
//        //appleValidator = AppleReceiptValidator(service: .sandbox)
//        /*#if ENV_DEV
//            appleValidator = AppleReceiptValidator(service: .sandbox)
//        #elseif ENV_MM
//            appleValidator = AppleReceiptValidator(service: .production)
//        #elseif ENV_PROD
//            appleValidator = AppleReceiptValidator(service: .production)
//        #endif*/
//        
//        flavor = Flavor()
//        appDelegate = UIApplication.shared.delegate as? AppDelegate
//        self.ref = appDelegate.firestoreRef
//        self.pref = MyPreferences()
//        
//        fbUser = FbUser(reference: self.ref)
//        
//        navigationController?.navigationBar.isHidden = true
//        
//        scrollView = UIScrollView(frame: self.view.frame)
//    
//        pageControl = UIPageControl(frame: CGRect(x:0,y: 0, width:200, height:50))
//        pageControl.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        scrollView.delegate = self
//        scrollView.isPagingEnabled = true
//        
//        self.view.addSubview(scrollView)
//        
//        configurePageControl()
//        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -135).isActive = true
//        
//        scrollView.bounces = false
//        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
//        
//        //Purchase button
//        purchaseButton = {
//            let button = UIButton()
//            button.setTitle(NSLocalizedString("btnUpgradeNow", comment: ""), for: .normal)
//            button.setTitleColor(flavor.getAccentColor(), for: .normal)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.titleLabel?.font = UIFont(name: "Lato-Heavy", size: 24)
//            return button
//        }()
//        purchaseButton.addTarget(self, action: #selector(AppUpgradeViewController.actionPurchaseButton(sender:)), for: .touchUpInside)
//        
//        
//        verificationButton = {
//            let button = UIButton()
//            button.setTitle(NSLocalizedString("btnVerifyNow", comment: ""), for: .normal)
//            button.setTitleColor(flavor.getPrimaryColor(), for: .normal)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.titleLabel?.font = UIFont(name: "Lato-Heavy", size: 19)
//            return button
//        }()
//        verificationButton.addTarget(self, action: #selector(AppUpgradeViewController.actionRestoreButton(sender:)), for: .touchUpInside)
//        //Cancel button
//        
//        cancelButton = {
//            let button = UIButton()
//            button.setTitle(NSLocalizedString("text_cancel", comment: ""), for: .normal)
//            button.setTitleColor(mmChrome.LIGHT_GREY, for: .normal)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 14)
//            return button
//        }()
//        cancelButton.addTarget(self, action: #selector(AppUpgradeViewController.actionCancelButton(sender:)), for: .touchUpInside)
//        
//        
//        self.view.addSubview(purchaseButton)
//        self.view.addSubview(verificationButton)
//        self.view.addSubview(cancelButton)
//        
//        verificationButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        verificationButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -65).isActive = true
//        
//        purchaseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        purchaseButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -105).isActive = true
//        
//        cancelButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
//        
//        var index:Int = 0
//        //
//        var firstFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
//        firstFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
//        firstFrame.size = self.scrollView.frame.size
//        let firstSubView = UIView(frame: firstFrame)
//        self.scrollView.addSubview(firstSubView)
//        let part_1:NSDictionary = [
//            "title": NSLocalizedString("titleUnlimitedNumberBudgets", comment: ""),
//            "description": NSLocalizedString("descriptionUnlimitedNumberBudgets", comment: ""),
//            "image": UIImage(named: "infinite")!]
//        featureDisplay(content: firstSubView, partDisplay: part_1)
//        //
//        index += 1
//        var secondFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
//        secondFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
//        secondFrame.size = self.scrollView.frame.size
//        let secondSubView = UIView(frame: secondFrame)
//        self.scrollView.addSubview(secondSubView)
//        let part_2:NSDictionary = [
//            "title": NSLocalizedString("titleRecurringTransaction", comment: ""),
//            "description": NSLocalizedString("descriptionRecurringTransaction", comment: ""),
//            "image": UIImage(named: "repeat_1")!]
//        featureDisplay(content: secondSubView, partDisplay: part_2)
//        //
//        index += 1
//        var thirdFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
//        thirdFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
//        thirdFrame.size = self.scrollView.frame.size
//        let thirdSubView = UIView(frame: thirdFrame)
//        self.scrollView.addSubview(thirdSubView)
//        let part_3:NSDictionary = [
//            "title": NSLocalizedString("titleExcelPdfCsv", comment: ""),
//            "description": NSLocalizedString("descriptionExcelPdfCsv", comment: ""),
//            "image": UIImage(named: "cloud_computing")!]
//        featureDisplay(content: thirdSubView, partDisplay: part_3)
//        
//        //
//        index += 1
//        var fouthFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
//        fouthFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
//        fouthFrame.size = self.scrollView.frame.size
//        let fouthSubView = UIView(frame: fouthFrame)
//        self.scrollView.addSubview(fouthSubView)
//        let part_4:NSDictionary = [
//            "title": NSLocalizedString("titleKeepSameLicence", comment: ""),
//            "description": NSLocalizedString("descriptionKeepSameLicence", comment: ""),
//            "image": UIImage(named: "smartphone")!]
//        featureDisplay(content: fouthSubView, partDisplay: part_4)
//        
//        /*self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 4,height: self.scrollView.frame.size.height)*/
//        self.scrollView.contentSize.width = self.scrollView.frame.size.width * 4
//        self.scrollView.contentSize.height = self.scrollView.frame.size.height * 0.9
//        self.scrollView.showsVerticalScrollIndicator = false
//        self.scrollView.showsHorizontalScrollIndicator = false
//        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
//
//        view.backgroundColor = UIColor.white
//
//        getInfo(purchase: .iSaveMoneyPro)
//        
//    }
//    //for scroll
//    func configurePageControl() {
//        // The total number of pages that are available is based on how many available colors we have.
//        self.pageControl.numberOfPages = 4
//        self.pageControl.currentPage = 0
//        self.pageControl.tintColor = flavor.getAccentColor()
//        self.pageControl.pageIndicatorTintColor = mmChrome.LIGHT_GREY
//        self.pageControl.currentPageIndicatorTintColor = flavor.getAccentColor()
//        self.view.addSubview(pageControl)
//        
//    }
//    
//    func registerPuchase(receipt: ReceiptItem) {
//        let fbUserPurchases = FbUserPurchases(reference: self.ref)
//        let fbPreferences = FbPreferences(reference: self.ref)
//        
//        pref.setLicence(val: Const.LICENCE_PREMIUM)
//        pref.setIsLicence(val: true)
//        let nextVerification:Date = (Date()+604800) // plus 7 days  604800 seconds
//        let checkTimeStamp = Int(nextVerification.timeIntervalSince1970)
//        pref.setNextCheck(val: checkTimeStamp)
//        
//        
//        let mapPreferences:[String:Any] = ["prefLicence":Const.LICENCE_PREMIUM,
//                                           "prefLicenceChecked": true,
//                                           "prefCheckLicenceTime": checkTimeStamp]
//        
//        fbPreferences.savePreference(preferences: mapPreferences, user_gid: pref.getUserIdentifier())
//        
//        self.appDelegate.notifyDrawer()
//        
//        let userPurchase = UserPurchases()
//        userPurchase.user_gid = pref.getUserIdentifier()
//        userPurchase.active = 1
//        userPurchase.purchased_platform = Const.PLATFORM_NAME
//        userPurchase.order_number = receipt.transactionId
//        userPurchase.insert_date = UtilsIsm.getTimeStamp()
//        userPurchase.description =  "\(Const.ORDER_STATE_PURCHASED) \(receipt.purchaseDate)"
//        userPurchase.sku = receipt.productId
//        userPurchase.insert_date = Int(Date().timeIntervalSince1970)
//        fbUserPurchases.write(userPurchase, listener: { (result) in
//            
//        })
//        
//       
//    }
//    
//    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
//    @objc func changePage(sender: AnyObject) -> () {
//        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
//        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        
//        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
//        pageControl.currentPage = Int(pageNumber)
//    }
//    //for scroll
//    
//    
//    @objc func actionPurchaseButton(sender: UIButton!) {
//        
//        purchase(purchase: .iSaveMoneyPro)
//    }
//    
//    @objc func actionRestoreButton(sender: UIButton!) {
//        // restorePurchases()
//        verifyReceipt(confirm: true)
//        //verifyPurchase(product: .iSaveMoneyPro)
//        
//    }
//    
//    @objc func actionCancelButton(sender: UIButton!) {
//        appDelegate.navigateTo(instance: ViewController())
//    }
//   
//    
//    func getInfo(purchase: RegisteredPurchase) {
//        NetworkActivityIndicatorManager.NetworkOperationStarted(baseViewController: self)
//        SwiftyStoreKit.retrieveProductsInfo([purchase.rawValue], completion: {
//            result in
//            NetworkActivityIndicatorManager.networkOperationFinished(baseViewController: self)
//            let alert = self.alertForProductRetrievalInfo(result: result)
//            if alert != nil {
//                self.showAlert(alert: alert!)
//            }
//            
//    
//        })
//    }
//    
//    func purchase (purchase: RegisteredPurchase) {
//        NetworkActivityIndicatorManager.NetworkOperationStarted(baseViewController: self)
//        SwiftyStoreKit.purchaseProduct(purchase.rawValue, completion: {
//            result in
//            NetworkActivityIndicatorManager.networkOperationFinished(baseViewController: self)
//           
//            if case .success(let product) = result {
//                if product.needsFinishTransaction{
//                    SwiftyStoreKit.finishTransaction(product.transaction)
//                }
//                self.showAlert(alert: self.alertForPurchaseResult(result: result))
//            }
//        })
//        
//        
//    }
//    
//    func restorePurchases() {
//        NetworkActivityIndicatorManager.NetworkOperationStarted(baseViewController: self)
//        SwiftyStoreKit.restorePurchases(atomically: true, completion: {
//            result in
//            NetworkActivityIndicatorManager.networkOperationFinished(baseViewController: self)
//            
//            print(result)
//            for product in result.restoredPurchases {
//                if product.needsFinishTransaction {
//                    SwiftyStoreKit.finishTransaction(product.transaction)
//                }
//            }
//            self.showAlert(alert: self.alertForRestorePurchase(result: result))
//        })
//    }
//    
//    func verifyReceipt(confirm: Bool) {
//        NetworkActivityIndicatorManager.NetworkOperationStarted(baseViewController: self)
//        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: true, completion: {
//            result in
//            NetworkActivityIndicatorManager.networkOperationFinished(baseViewController: self)
//            
//            switch result {
//            case .success(let receipt):
//                print("Verify receipt success: \(receipt)")
//                // self.showAlert(alert: self.alertForVerifyReceipt(result: result))
//                
//                let purchaseResult = SwiftyStoreKit.verifyPurchase(
//                    productId: RegisteredPurchase.iSaveMoneyPro.rawValue,
//                    inReceipt: receipt)
//                    
//                switch purchaseResult {
//                case .purchased(let receiptItem):
//                    print("\(RegisteredPurchase.iSaveMoneyPro.rawValue) is purchased: \(receiptItem)")
//                    self.registerPuchase(receipt: receiptItem)
//                case .notPurchased:
//                    print("The user has never purchased \(RegisteredPurchase.iSaveMoneyPro.rawValue)")
//                }
//                
//                if(confirm){
//                    self.showAlert(alert: self.alertWithTitle(title: NSLocalizedString("txtThankYou", comment: ""),
//                           message: NSLocalizedString("txtPurchaseCompleted", comment: ""), exit: true))
//                }
//            case .error(let error):
//                print("Verify receipt failed: \(error)")
//                if case .noReceiptData = error {
//                    self.refreshReceipt()
//                }
//            }
//            
//            //if case .error(let error) = result {
//                
//            //}
//        })
//    }
//    
//    func verifyPurchase (product: RegisteredPurchase){
//        NetworkActivityIndicatorManager.NetworkOperationStarted(baseViewController: self)
//        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false, completion: {
//            result in
//            NetworkActivityIndicatorManager.networkOperationFinished(baseViewController: self)
//            
//            print(result)
//            switch result {
//                
//            case .success(let receipt):
//                print(result)
//                let productID = product.rawValue
//                if product == .iSaveMoneyPro {
//                    let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productID, inReceipt: receipt, validUntil: Date())
//                    self.showAlert(alert: self.alertForVerifySubscription(result: purchaseResult))
//                }
//                else {
//                    let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productID, inReceipt: receipt)
//                    self.showAlert(alert: self.alertForVerifySubscription(result: purchaseResult))
//                }
//            case .error(let error):
//                self.showAlert(alert: self.alertForVerifyReceipt(result: result))
//                if case .noReceiptData = error {
//                    self.refreshReceipt()
//                }
//            }
//        })
//        
//        
//    }
//    
//    func refreshReceipt() {
//        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: {
//            result in
//            
//            self.showAlert(alert: self.alertForRefreshReceipt(result: result))
//        })
//    }
// 
//}
//
//extension AppUpgradeViewController {
//    func alertWithTitle(title : String, message : String, exit: Bool) -> UIAlertController {
//        let alert = UIAlertController(title: title, message : message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("text_ok", comment: ""), style: .cancel, handler: { action in
//            
//            if(exit) {
//                let appDelegate = UIApplication.shared.delegate as? AppDelegate
//                appDelegate?.navigateTo(instance: ViewController())
//            }
//        }))
//        
//        
//        return alert
//    }
//    
//    func showAlert(alert: UIAlertController) {
//        
//        guard let _ = self.presentedViewController else {
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//    }
//    
//    
//    func alertForProductRetrievalInfo(result : RetrieveResults) -> UIAlertController? {
//       
//        var alertBox:UIAlertController!
//        
//        if let product = result.retrievedProducts.first {
//            let priceString = product.localizedPrice!
//            /*return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")*/
//            purchaseButton.setTitle("\(NSLocalizedString("txtBuyNow", comment: "")) (\(priceString))", for: .normal)
//            
//        }
//        else if let invalidProductID = result.invalidProductIDs.first {
//            alertBox = alertWithTitle(title: NSLocalizedString("txtCouldNotRetreiveProd", comment: ""),
//                                      message: "\(NSLocalizedString("txtInvalidProductId", comment: "")) \(invalidProductID)", exit: false)
//        }
//        else{
//            let errorString = result.error?.localizedDescription ?? NSLocalizedString("txtUnknownError", comment: "")
//            alertBox = alertWithTitle(title: NSLocalizedString("txtCouldNotReteiveProdInfo", comment: ""), message: errorString, exit: false)
//        }
//        
//        return alertBox
//    }
//    
//    
//    func alertForPurchaseResult(result : PurchaseResult) -> UIAlertController {
//        
//        switch result {
//        case .success( _):
//            verifyReceipt(confirm: false)
//            return alertWithTitle(title: NSLocalizedString("txtThankYou", comment: ""),
//            message: NSLocalizedString("txtPurchaseCompleted", comment: ""), exit: true)
//            
//        case .error(let error):
//            
//            if (error as NSError).domain == SKErrorDomain {
//                return alertWithTitle(title: NSLocalizedString("txtPurchaseFailed", comment: ""),
//                                      message: NSLocalizedString("txtDescriptionPurchaseFailed", comment: ""), exit: false)
//            }
//            else {
//                switch error.code {
//                    
//                case .unknown:
//                    return alertWithTitle(title: NSLocalizedString("txtError1", comment: ""),
//                                          message: NSLocalizedString("txtBodyError1", comment: ""), exit: false)
//                case .paymentNotAllowed:
//                    return alertWithTitle(title: NSLocalizedString("txtError2", comment: ""),
//                                          message: NSLocalizedString("txtBodyError2", comment: ""), exit: false)
//                case .paymentInvalid:
//                    return alertWithTitle(title: NSLocalizedString("txtError3", comment: ""),
//                                          message: NSLocalizedString("txtBodyError3", comment: ""), exit: false)
//                case .clientInvalid:
//                    return alertWithTitle(title: NSLocalizedString("txtError4", comment: ""),
//                                          message: NSLocalizedString("txtBodyError4", comment: ""), exit: false)
//                case .paymentCancelled:
//                    return alertWithTitle(title: NSLocalizedString("txtError5", comment: ""),
//                                          message: NSLocalizedString("txtBodyError5", comment: ""), exit: false)
//                case .storeProductNotAvailable:
//                    return alertWithTitle(title: NSLocalizedString("txtError6", comment: ""),
//                                          message: NSLocalizedString("txtBodyError6", comment: ""), exit: false)
//                case .cloudServicePermissionDenied:
//                    return alertWithTitle(title: NSLocalizedString("txtError7", comment: ""),
//                                          message: NSLocalizedString("txtBodyError7", comment: ""), exit: false)
//                case .cloudServiceNetworkConnectionFailed:
//                    return alertWithTitle(title: NSLocalizedString("txtError8", comment: ""),
//                                          message: NSLocalizedString("txtBodyError8", comment: ""), exit: false)
//                case .cloudServiceRevoked:
//                    return alertWithTitle(title: NSLocalizedString("txtError9", comment: ""),
//                                          message: NSLocalizedString("txtBodyError9", comment: ""), exit: false)
//                default:
//                    return alertWithTitle(title: NSLocalizedString("txtError1", comment: ""),
//                                          message: NSLocalizedString("txtBodyError1", comment: ""), exit: false)
//                    
//                }
//            }
//            
//        }
//    }
//    
//    func alertForRestorePurchase(result: RestoreResults) -> UIAlertController {
//        print(result)
//        if result.restoreFailedPurchases.count > 0 {
//            
//            return alertWithTitle(title: NSLocalizedString("txtRestore1", comment: ""),
//                                  message: NSLocalizedString("txtBodyRestore1", comment: ""), exit: false)
//        } else if result.restoredPurchases.count > 0 {
//            
//            let fbUserPurchases = FbUserPurchases(reference: self.ref)
//            let fbPreferences = FbPreferences(reference: self.ref)
//            
//            pref.setLicence(val: Const.LICENCE_PREMIUM)
//            pref.setIsLicence(val: true)
//            let nextVerification:Date = (Date()+604800) // plus 7 days  604800 seconds
//            let checkTimeStamp = Int(nextVerification.timeIntervalSince1970)
//            pref.setNextCheck(val: checkTimeStamp)
//            
//            let mapPreferences:[String:Any] = ["prefLicence":Const.LICENCE_PREMIUM,
//                                               "prefLicenceChecked": true,
//                                               "prefCheckLicenceTime": checkTimeStamp]
//            fbPreferences.savePreference(preferences: mapPreferences, user_gid: pref.getUserIdentifier())
//            
//            self.appDelegate.notifyDrawer()
//            
//            let purchase:Purchase = result.restoredPurchases[0]
//            
//            let userPurchase = UserPurchases()
//            userPurchase.user_gid = pref.getUserIdentifier()
//            userPurchase.active = 1
//            userPurchase.purchased_platform = Const.PLATFORM_NAME
//            //userPurchase.order_number = (purchase.originalTransaction?.transactionIdentifier)!
//            userPurchase.description = Const.ORDER_STATE_RESTORED
//            userPurchase.sku = purchase.productId
//            userPurchase.insert_date = Int(Date().timeIntervalSince1970)
//            fbUserPurchases.write(userPurchase, listener: {(result) in
//                
//            })
//            
//            return alertWithTitle(title: NSLocalizedString("txtRestore2", comment: ""),
//                                  message: NSLocalizedString("txtBodyRestore2", comment: ""), exit: true)
//        } else {
//            return alertWithTitle(title: NSLocalizedString("txtRestore3", comment: ""),
//                                  message: NSLocalizedString("txtBodyRestore3", comment: ""), exit: false)
//        }
//    }
//    
//    func alertForVerifyReceipt(result: VerifyReceiptResult) -> UIAlertController {
//        
//        switch result {
//        case .success( _):
//            return alertWithTitle(title: NSLocalizedString("txtVerify1", comment: ""),
//                                  message: NSLocalizedString("txtBodyVerify1", comment: ""), exit: false)
//        case .error(let receiptError):
//            switch receiptError {
//            case .noReceiptData:
//                return alertWithTitle(title: NSLocalizedString("txtVerify2", comment: ""),
//                                      message: NSLocalizedString("txtBodyVerify2", comment: ""), exit: false)
//            default:
//                return alertWithTitle(title: NSLocalizedString("txtVerify3", comment: ""),
//                                      message: NSLocalizedString("txtBodyVerify3", comment: ""), exit: false)
//            }
//        }
//    }
//    
//    func alertForVerifySubscription(result: VerifySubscriptionResult) -> UIAlertController {
//        
//        switch result {
//        case .purchased(let expiryDate):
//            return alertWithTitle(title: NSLocalizedString("txtVerifySub1", comment: ""), message: "\(NSLocalizedString("txtVerifySubBody1", comment: "")) \(expiryDate)", exit: false)
//        case .notPurchased:
//            return alertWithTitle(title: NSLocalizedString("txtVerifySub2", comment: ""), message: NSLocalizedString("txtVerifySubBody2", comment: ""), exit: false)
//        case .expired(let expiryDate):
//            return alertWithTitle(title: NSLocalizedString("txtVerifySub3", comment: ""), message: "\(NSLocalizedString("txtVerifySubBody3", comment: "")) \(expiryDate)", exit: false)
//        }
//    }
//    
//    func alertForVerifyPurchase(result: VerifyPurchaseResult) -> UIAlertController {
//        
//        switch result {
//        case .purchased:
//            return alertWithTitle(title: NSLocalizedString("txtVerifyPurchase1", comment: ""), message: NSLocalizedString("txtVerifyPurchaseBody1", comment: ""), exit: false)
//        case .notPurchased:
//            return alertWithTitle(title: NSLocalizedString("txtVerifyPurchase2", comment: ""), message: NSLocalizedString("txtVerifyPurchaseBody2", comment: ""), exit: false)
//        
//        }
//    }
//    
//    func alertForRefreshReceipt(result: VerifyReceiptResult) -> UIAlertController {
//        
//        switch result {
//        case .success( _):
//            return alertWithTitle(title: NSLocalizedString("txtReceiptRefreshed1", comment: ""), message: NSLocalizedString("txtReceiptRefreshedBody1", comment: ""), exit: false)
//        case .error( _):
//             return alertWithTitle(title: NSLocalizedString("txtReceiptRefreshed2", comment: ""), message: NSLocalizedString("txtReceiptRefreshedBody2", comment: ""), exit: false)
//        }
//    }
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        AppUtility.lockOrientation(.portrait)
//        // Or to rotate and lock
//        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
//        
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        // Don't forget to reset when view is being removed
//        AppUtility.lockOrientation(.all)
//    }
//    
//
//    
//    func featureDisplay(content uiView: UIView, partDisplay:NSDictionary) {
//        
//        let labelTitleFeature:UILabel = {
//            
//            let label = UILabel()
//            label.text = partDisplay["title"] as? String ?? ""//"Recurring transaction"
//            label.textAlignment = .center
//            label.textColor = mmChrome.DARK
//            label.numberOfLines = 0
//            label.font = UIFont(name: "Lato-Heavy", size: 18)
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
//        
//        let labelDescriptionFeature:UILabel = {
//            let label = UILabel()
//            label.text =  partDisplay["description"] as? String ?? ""//"Get multiple recurring transactions to be executed at the due date"
//            label.textAlignment = .center
//            label.textColor = mmChrome.LIGHT_GREY
//            label.numberOfLines = 0
//            label.font = UIFont(name: "Lato-Regular", size: 14)
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
//        
//        let imgFeature:UIImageView = {
//            
//            let imageView = UIImageView()
//            let image = partDisplay["image"] as? UIImage ?? UIImage(named: "repeat_1")
//            let widthLogo = CGFloat(82)
//            imageView.widthAnchor.constraint(equalToConstant: widthLogo).isActive = true
//            imageView.heightAnchor.constraint(equalToConstant: widthLogo).isActive = true
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            imageView.contentMode = UIView.ContentMode.scaleAspectFit
//            imageView.image = image
//            
//            return imageView
//        }()
//        
//        let featureSctackView:UIStackView = {
//            let s = UIStackView(arrangedSubviews: [ labelTitleFeature, labelDescriptionFeature, imgFeature])
//            s.axis = .vertical
//            s.distribution = .equalSpacing
//            s.spacing = 32
//            s.translatesAutoresizingMaskIntoConstraints = false
//            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            return s
//        }()
//        
//        uiView.addSubview(featureSctackView)
//        featureSctackView.widthAnchor.constraint(equalTo: uiView.widthAnchor).isActive = true
//        featureSctackView.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 50).isActive = true
//        featureSctackView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor).isActive = true
//        
//        
//    }
//}
