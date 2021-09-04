//
//  AccountTabsViewController.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 15/08/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLDataService

class AccountTabsViewController: BaseScreenViewController,UITabBarControllerDelegate {

    var mAccount:Account?
    public var mTransactions:[IsmTransaction]? = nil
    
    var tabsController = UITabBarController()
    
    let titles = [NSLocalizedString("account_details_title", comment: "Account Details"),NSLocalizedString("AccountFromEdit", comment: "Edit Account")]
    
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
        mAccount = params["account"] as? Account ?? nil
        self.title = self.titles[0]
        self.navigationItem.leftBarButtonItem  = cancelButton
        let args:NSDictionary = ["account": mAccount ?? nil,"navigationItem":self.navigationItem,"navigationController":self.navigationController ?? nil,"tabController":self]
        
        
        let accountTransactionsViewController = AccountTransactionsViewController(nibName: "AccountTransactionsViewController", bundle: nil)
        accountTransactionsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("transactions", comment: "Transactions"), image: UIImage(named: "transactions-icon.png"), tag: 2)
        accountTransactionsViewController.params = args
        
        let chartsViewController = AccountChartsViewController(nibName: "AccountChartsViewController", bundle: nil)
        chartsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("charts", comment: "Charts"), image: UIImage(named: "chart-icon.png"), tag: 2)
        chartsViewController.params = args
        
        let accountFormViewController = AccountFormViewController(nibName: "AccountFormViewController", bundle: nil)
        accountFormViewController.params = args
        accountFormViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("AccountFromEdit", comment: "Edit Account"), image: UIImage(named: "edit-icon.png"), tag: 2)
        
        self.tabsController.viewControllers = [accountTransactionsViewController,chartsViewController,accountFormViewController]
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
