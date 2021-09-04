//
//  PayeeViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/5/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Firebase
import ISMLBase
import ISMLDataService


class PayeeViewController: BaseScreenViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    
    lazy var payeeTableView:UITableView = {
        
        let table = UITableView()
        return table
    }()
    
    
    static var viewIdentifier:String = "PayeeViewController"
    
    var mPayeeCollection: PayeesCollection!
    
    var mPayees:[Payee] = []
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPayeeCollection = PayeesCollection()
        mPayees = []
        self.setUpActivity()
        self.layoutComponent()
        
    }
    
    func setUpActivity() {
        
        self.title = NSLocalizedString("PayeeTitle", comment: "Title")

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        let editButton = UIBarButtonItem(image: UIImage(named: "new"), landscapeImagePhone: UIImage(named: "new"), style: .done, target: self, action:  #selector(addPayee(_:)))
        self.navigationItem.rightBarButtonItem  = editButton
        
        
        

    }
    func layoutComponent() {
        self.payeeTableView.delegate = self
        self.payeeTableView.dataSource = self
        self.payeeTableView.separatorColor = UIColor(named: "seperatorColor")
        self.payeeTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.payeeTableView.emptyDataSetSource = self
        self.payeeTableView.emptyDataSetDelegate = self
        self.payeeTableView.tableFooterView = UIView()
        self.payeeTableView.backgroundColor = UIColor.clear
        self.view.addSubview(self.payeeTableView)
        self.payeeTableView.edgesToSuperview()
        let tableViewCellNib = UINib(nibName: "PayeeTableViewCell", bundle: nil)
        self.payeeTableView.register(tableViewCellNib, forCellReuseIdentifier: "PAYEE_CELL")
    }
    override func viewWillDisappear(_ animated: Bool) {
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pullPayee()
    }
    
    func pullPayee() {
        
        
        mPayeeCollection.startSync(notifier: {(payees) in
            
            self.mPayees = payees
            self.payeeTableView.reloadData()
            
        })
        
        
    }

        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        
        return mPayees.count
        
        //return budgetSections.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let payee: Payee = mPayees[indexPath.row]
        
        
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "PAYEE_CELL", for: indexPath) as! PayeeTableViewCell
        
    
        drawerCell.payeeName.text = payee.name
        let namePrefix = String(payee.name.prefix(1))
        drawerCell.circularText.setText(text: namePrefix, col: Const.getColorByCharacter(character: namePrefix))
        drawerCell.circularText.setNeedsDisplay()
        drawerCell.date.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(payee.insert_date)), format: self.pref.getDateFormat())
        drawerCell.amountLabel.text = UtilsIsm.formartCurrency(value: payee.total_expenses, local: self.pref.getCurrency())
        
        return drawerCell
        
    
        
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let fbPayee:FbPayee = FbPayee()
            fbPayee.delete(mPayees[indexPath.row].gid!)
            mPayees.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //Cancel payee
    @objc func cancel(_ sender: UIBarButtonItem) {
        
        //self.appDelegate.navigateTo(instance: ViewController())
//        _ = navigationController?.popViewController(animated: true)
        appDelegate.navigateTo(instance: ViewController())
    }
    
    
    //Add payee
    @objc func addPayee(_ sender: UIBarButtonItem) {
        
        //self.dismissViewControllerNone()
       
        let payeeForm = PayeeFormViewController(nibName: "PayeeFormViewController", bundle: nil)
        self.navigationController?.pushViewController(payeeForm, animated: true)
        
        /*var payeeFormVC = PayeeFormViewController(nibName: "PayeeFormViewController", bundle: nil)
        self.navigationController?.pushViewController(payeeFormVC, animated: true)*/
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let args:NSDictionary = ["payee": mPayees[indexPath.row]]

//        let payeeForm = PayeeFormViewController(nibName: "PayeeFormViewController", bundle: nil)
//        payeeForm.params = args
//        self.navigationController?.pushViewController(payeeForm, animated: true)
        //appDelegate.navigateTo(instance: PayeeFormViewController(nibName: "PayeeFormViewController", bundle: nil), params: args)
        
        let payeeTabsController = PayeeTabsViewController()
        payeeTabsController.params = args
        self.navigationController?.pushViewController(payeeTabsController, animated: true)
        
        
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("PayeeNoPayee", comment: "No payee yet.")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("PayeeDescription", comment: "A payee is an entity to whom...")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "receipt")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let str = NSLocalizedString("PayeeAddFirst", comment: "Add your first payee")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout), NSAttributedString.Key.foregroundColor: UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        
        //self.changeViewController(PayeeFormViewController.viewIdentifier)
        let payeeForm = PayeeFormViewController(nibName: "PayeeFormViewController", bundle: nil)
        self.navigationController?.pushViewController(payeeForm, animated: true)
    }

    
}
