//
//  AccountViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/13/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import DZNEmptyDataSet
import TinyConstraints
import ISMLDataService
import ISMLBase

class AccountViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    static var viewIdentifier:String = "AccountViewController"
    
    lazy var accountTableView:UITableView = {
        
        let table = UITableView()
        return table
    }()
    
    var firebaseRef: Firestore!
    var pref:MyPreferences!
    
    var formatter: NumberFormatter!
    
    var mAccounts:[Account]!
    var syncAccounts:SyncAccountsCollection!
    
    var appDelegate:AppDelegate!
    var flavor:Flavor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        self.setUpActivity()
        self.layoutComponent()
    
    }
    
    func setUpActivity() {
        
        self.firebaseRef = appDelegate.firestoreRef
        mAccounts = []
        formatter = NumberFormatter()
        formatter.numberStyle = .currency
        self.pref = MyPreferences()
        syncAccounts = SyncAccountsCollection(reference: self.firebaseRef)
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        let editButton = UIBarButtonItem(image: UIImage(named: "new"), landscapeImagePhone: UIImage(named: "new"), style: .done, target: self, action:  #selector(addAccount))
        let transferButton = UIBarButtonItem(image: UIImage(named: "transfer-icon"), landscapeImagePhone: UIImage(named: "transfer-icon"), style: .done, target: self, action:  #selector(transfer))
        self.navigationItem.rightBarButtonItems  = [editButton,transferButton]
        
        
        
        self.title = NSLocalizedString("accountTitle", comment: "My Accounts")

    }

    func layoutComponent() {
        
        self.accountTableView.tableFooterView = UIView()
        self.accountTableView.delegate = self
        self.accountTableView.dataSource = self
        self.accountTableView.separatorColor = UIColor(named: "seperatorColor")
        self.accountTableView.backgroundColor = UIColor.clear
        self.accountTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.accountTableView.emptyDataSetSource = self
        self.accountTableView.emptyDataSetDelegate = self
        self.accountTableView.tableFooterView = UIView()
        
        self.view.addSubview(self.accountTableView)
        self.accountTableView.edgesToSuperview()
        let tableViewCellNib = UINib(nibName: "AccountsTableViewCell", bundle: nil)
        self.accountTableView.register(tableViewCellNib, forCellReuseIdentifier: "ACCOUNT_CELL")
        
    }
    
    func pullUserAccounts() {
        
        syncAccounts.startSync(accountsListner: {(accounts) in
            
            self.mAccounts = accounts
            
            self.accountTableView.reloadData()
        
        }, error: {(error) in
            print(error.errorMessage)
        })
        
        //mAccounts = appDelegate.getAccounts()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        syncAccounts.stopSync()
        
        appDelegate.mAccountsCollection?.startSync()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        pullUserAccounts()
    }
    //cancel
    @objc func cancel(_ sender: UIBarButtonItem) {
        
//        self.navigationController?.popToRootViewController(animated: true)
        appDelegate.navigateTo(instance: ViewController())
    }
    
    
    //add account
    @objc func addAccount(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(AccountFormViewController(nibName: "AccountFormViewController", bundle: nil), animated: true)
        
    }
    
    
    //transfer
    @objc func transfer(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(AccountTransferViewController(nibName: "TransferViewController", bundle: nil), animated: true)
 
    }
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return mAccounts.count;
        
        //return budgetSections.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let account: Account = mAccounts[indexPath.row]
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "ACCOUNT_CELL", for: indexPath) as! AccountsTableViewCell
        
        drawerCell.nameLabel.text = account.name
        let namePrefix = String(account.name.prefix(1))
        drawerCell.circularTextView.setText(text: namePrefix, col: Const.getColorByCharacter(character: namePrefix))
        drawerCell.circularTextView.setNeedsDisplay()
        
        drawerCell.dateLabel.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(account.insert_date)), format: self.pref.getDateFormat())
        account.deposit = account.incomes + account.transfers_in
        account.withdraw = account.expenses + account.transfers_out
        let balance = account.balance + account.deposit - account.withdraw
        drawerCell.amountLabel.text = UtilsIsm.formartCurrency(value: balance, local: self.pref.getCurrency())
        
        return drawerCell
        
    }
    
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let confirm = ConfirmDelete()
            let alert = confirm.display(itemName: mAccounts[indexPath.row].name, feedback: {_ in
                let fbAccount:FbAccount = FbAccount(reference: self.firebaseRef)
                fbAccount.delete(self.mAccounts[indexPath.row].gid!)
                self.mAccounts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            })
//            let alert = UIAlertController(title: NSLocalizedString("confirm_delete", comment: "Delete"),
//                                          message: String(format: NSLocalizedString("confirm_delete_msg", comment: "Delete message"), arguments: [mAccounts[indexPath.row].name]),
//                                          preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: NSLocalizedString("confirm_delete_continue", comment: "Default action"), style: .destructive, handler: { _ in
//
//                let fbAccount:FbAccount = FbAccount(reference: self.firebaseRef)
//                fbAccount.delete(self.mAccounts[indexPath.row].gid!)
//                self.mAccounts.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
//            }))
//            alert.addAction(UIAlertAction(title: NSLocalizedString("confirm_delete_cancel", comment: "Default action"), style: .cancel, handler: { _ in
//
//            }))
            self.present(alert, animated: true, completion: nil)
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let args:NSDictionary = ["account": self.mAccounts[indexPath.row]]
        
        let accountDetailTabs = AccountTabsViewController()
        accountDetailTabs.params = args
        self.navigationController?.pushViewController(accountDetailTabs, animated: true)
        
        
        
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("AccountNoAccount", comment: "No account yet.")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("AccountNoAccountDescription", comment: "An account can be a saving account, credit account , or represents some amount of cash money you put on the side.")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "account")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let str = NSLocalizedString("AccountNoAddFirt", comment: "Add your first account")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout), NSAttributedString.Key.foregroundColor: UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        
        self.navigationController?.pushViewController(AccountFormViewController(nibName: "AccountFormViewController", bundle: nil), animated: true)
    }
    

}
