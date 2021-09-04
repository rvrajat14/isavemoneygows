//
//  CoBaseViewController.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/6/20.
//

import UIKit

public class CoBaseViewController: UIViewController{
    fileprivate enum Segment: Int {
        case products, purchases
    }
    
    fileprivate var utility = Utilities()
    var data = [Section]()
    var purchasedata = [Section]()
    var transactionsDetails = [Section]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable or hide the button.
        //restoreButton.disable()
        
        StoreManager.shared.delegate = self
        StoreObserver.shared.delegate = self
        
        // Fetch product information.
        fetchProductInformation()
    }
    
    /// Retrieves product information from the App Store.
    fileprivate func fetchProductInformation() {
        // First, let's check whether the user is allowed to make purchases. Proceed if they are allowed. Display an alert, otherwise.
        if StoreObserver.shared.isAuthorizedForPayments {
            //restoreButton.enable()
            
            let resourceFile = ProductIdentifiers()
            guard let identifiers = resourceFile.identifiers else {
                // Warn the user that the resource file could not be found.
                alert(with: Messages.status, message: resourceFile.wasNotFound)
                return
            }
            
            if !identifiers.isEmpty {
                //switchToViewController(segment: .products)
                // Refresh the UI with identifiers to be queried.
                //products.reload(with: [Section(type: .invalidProductIdentifiers, elements: identifiers)])
                
                // Fetch product information.
                print("Fetch product information.")
                StoreManager.shared.startProductRequest(with: identifiers)
            } else {
                // Warn the user that the resource file does not contain anything.
                alert(with: Messages.status, message: resourceFile.isEmpty)
            }
        } else {
            // Warn the user that they are not allowed to make purchases.
            alert(with: Messages.status, message: Messages.cannotMakePayments)
        }
    }
    
    /// Creates and displays an alert.
    fileprivate func alert(with title: String, message: String) {
        let alertController = utility.alert(title, message: message)
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    /// Handles successful restored transactions. Switches to the Purchases view.
    fileprivate func handleRestoredSucceededTransaction() {
        utility.restoreWasCalled = true
        reloadPurchase(with: utility.dataSourceForPurchasesUI)
        //reloadPurchases()
        // Refresh the Purchases view with the restored purchases.
//        switchToViewController(segment: .purchases)
//        purchases.reload(with: utility.dataSourceForPurchasesUI)
//        segmentedControl.selectedSegmentIndex = 1
    }
    
    fileprivate func handlePurchaceSuccess(){
        print("handlePurchaceSuccess")
        purchaceSuccess()
    }
//    func handleProductDisplayTransaction() {
//        print("reloadPriceDisplay")
//        reloadPriceDisplay()
//    }

    
    func reloadPriceDisplay(){
        
    }

    func reloadPurchases(){
        
    }
    
    func purchaceSuccess() {
        
    }
    
//    fileprivate lazy var products: Products = {
//        let identifier = ViewControllerIdentifiers.products
//        guard let controller = storyboard?.instantiateViewController(withIdentifier: identifier) as? Products
//            else { fatalError("\(Messages.unableToInstantiateProducts)") }
//        return controller
//    }()
//
//    fileprivate lazy var purchases: Purchases = {
//        let identifier = ViewControllerIdentifiers.purchases
//        guard let controller = storyboard?.instantiateViewController(withIdentifier: identifier) as? Purchases
    //            else { fatal@objc Error("\(Messages.unableToInstantiatePurchases)") }
//        return controller
//    }()

}
extension CoBaseViewController {
    func reload(with data: [Section]) {
        self.data = data
        //tableView.reloadData()
        reloadPriceDisplay()
    }
    
    func reloadPurchase(with data: [Section]) {
        self.purchasedata = data
        //tableView.reloadData()
        reloadPurchases()
    }
    
    
}


extension CoBaseViewController: StoreManagerDelegate {
    func storeManagerDidReceiveResponse(_ response: [Section]) {
//        switchToViewController(segment: .products)
//        // Switch to the Products view controller.
        reload(with: response)
//        segmentedControl.selectedSegmentIndex = 0
        print("Fetch product information storeManagerDidReceiveResponse.")
        
        //handleProductDisplayTransaction()
    }
    
    func storeManagerDidReceiveMessage(_ message: String) {
        alert(with: Messages.productRequestStatus, message: message)
    }
}

// MARK: - StoreObserverDelegate

/// Extends ParentViewController to conform to StoreObserverDelegate.
extension CoBaseViewController: StoreObserverDelegate {
    func storeObserverPurcahseDidSucceed() {
        handlePurchaceSuccess()
    }
    
    func storeObserverPurcahseDidFail() {
        
    }
    
    func storeObserverDidReceiveMessage(_ message: String) {
        alert(with: Messages.purchaseStatus, message: message)
        print("storeObserverDidReceiveMessage \(message)")
        
    }
    
    func storeObserverRestoreDidSucceed() {
        print("storeObserverRestoreDidSucceed done")
        
        handleRestoredSucceededTransaction()
    }
    
    
}


