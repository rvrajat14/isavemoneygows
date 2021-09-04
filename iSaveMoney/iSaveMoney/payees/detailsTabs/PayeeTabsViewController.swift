//
//  PayeeTabsViewController.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 26/07/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLDataService

class PayeeTabsViewController: BaseScreenViewController,UITabBarControllerDelegate {
    
    var mPayee:Payee?
    
    var tabsController = UITabBarController()

    let titles = [NSLocalizedString("payee_details_title", comment: "Payee Details"),NSLocalizedString("PayeeFromEdit", comment: "Edit Payee")]
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(PayeeFormViewController.cancel(_:)))
    }()
    
    var expenses:[Expense]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        mPayee = params["payee"] as? Payee ?? nil
        self.title = self.titles[0]
        self.navigationItem.leftBarButtonItem  = cancelButton
        let args:NSDictionary = ["payee": mPayee ?? nil,"navigationItem":self.navigationItem,"navigationController":self.navigationController ?? nil,"tabController":self]
        
        
        let expensesViewController = PayeeTransactionsViewController()
        expensesViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("transactions", comment: "Transactions"), image: UIImage(named: "transactions-icon.png"), tag: 2)
        expensesViewController.params = args
        let chartsViewController = ChartsViewController(nibName: "ChartsViewController", bundle: nil)
        chartsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("charts", comment: "Charts"), image: UIImage(named: "chart-icon.png"), tag: 2)
        chartsViewController.params = args
        let payeeFormViewController = PayeeFormViewController(nibName: "PayeeFormViewController", bundle: nil)
        payeeFormViewController.params = args
        payeeFormViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("edit-payee", comment: "Edit Payee"), image: UIImage(named: "edit-icon.png"), tag: 2)
        
        self.tabsController.viewControllers = [expensesViewController,chartsViewController,payeeFormViewController]
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
