//
//  PayerDetailTabsViewController.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 31/07/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLDataService

class PayerDetailTabsViewController: BaseScreenViewController,UITabBarControllerDelegate {
    
    
    var mPayer:Payer?
    
    var tabsController = UITabBarController()
    
    let titles = [NSLocalizedString("payer_details_title", comment: "Payer Details"),NSLocalizedString("PayerFormEdit", comment: "Edit Payer")]
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(PayeeFormViewController.cancel(_:)))
    }()
    
    var incomes:[Income]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPayer = params["payer"] as? Payer ?? nil
        self.title = self.titles[0]
        self.navigationItem.leftBarButtonItem  = cancelButton
        let args:NSDictionary = ["payer": mPayer ?? nil,"navigationItem":self.navigationItem,"navigationController":self.navigationController ?? nil,"tabController":self]
        
        
        let payerTransactionsViewController = PayerTransactionsViewController()
        payerTransactionsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("transactions", comment: "Transactions"), image: UIImage(named: "transactions-icon.png"), tag: 2)
        payerTransactionsViewController.params = args
        let chartsViewController = PayerChartsViewController(nibName: "PayerChartsViewController", bundle: nil)
        chartsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("charts", comment: "Charts"), image: UIImage(named: "chart-icon.png"), tag: 2)
        chartsViewController.params = args
        let payerFormViewController = PayerFormViewController(nibName: "PayerFormViewController", bundle: nil)
        payerFormViewController.params = args
        payerFormViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("edit-payee", comment: "Edit Payee"), image: UIImage(named: "edit-icon.png"), tag: 2)
        
        self.tabsController.viewControllers = [payerTransactionsViewController,chartsViewController,payerFormViewController]
        self.view.addSubview(tabsController.view)
        self.tabsController.delegate = self
    }
    
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch self.tabsController.selectedIndex {
        case 2:
            self.title = self.titles[1]
            break
        default:
            self.title = self.titles[0]
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem  = cancelButton
        }
    }
    
    
    //cancel
    @objc func cancel(_ sender: UIBarButtonItem) {
        //appDelegate.navigateTo(instance: PayeeViewController())
        _ = navigationController?.popViewController(animated: true)
        
    }
    
}
