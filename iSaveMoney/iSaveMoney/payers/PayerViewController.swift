//
//  PayerViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/13/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet
import FirebaseFirestore
import ISMLDataService
import ISMLBase


class PayerViewController: BaseScreenViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {

    static var viewIdentifier:String = "PayerViewController"
    
    
    lazy var payerTableView:UITableView = {
       
       let table = UITableView()
       return table
   }()
   
    
    var mPayers:[Payer] = []
    
    var mPayerCollection:PayersCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mPayerCollection = PayersCollection(reference: self.firestoreRef)
        mPayers = []
        self.setUpActivity()
        self.layoutComponent()
       
    }
    
    func setUpActivity() {
       
       flavor = Flavor()
       appDelegate = UIApplication.shared.delegate as? AppDelegate
       self.title = NSLocalizedString("budgetListTitle", comment: "My budgets")
       self.firestoreRef = appDelegate.firestoreRef
    
       let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(PayerViewController.cancel(_:)))
       self.navigationItem.leftBarButtonItem  = cancelButton
       
       let editButton = UIBarButtonItem(image: UIImage(named: "new"), landscapeImagePhone: UIImage(named: "new"), style: .done, target: self, action:  #selector(PayerViewController.addPayer(_:)))
       self.navigationItem.rightBarButtonItem  = editButton
       
       self.title = NSLocalizedString("PayerTitle", comment: "Title")

   }
    
    func layoutComponent() {
        self.payerTableView.delegate = self
        self.payerTableView.dataSource = self
        self.payerTableView.separatorColor = UIColor(named: "seperatorColor")
        self.payerTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.payerTableView.emptyDataSetSource = self
        self.payerTableView.emptyDataSetDelegate = self
        self.payerTableView.tableFooterView = UIView()
        self.payerTableView.backgroundColor = UIColor.clear
        
        self.view.addSubview(self.payerTableView)
        self.payerTableView.edgesToSuperview()
        let tableViewCellNib = UINib(nibName: "PayerTableViewCell", bundle: nil)
        self.payerTableView.register(tableViewCellNib, forCellReuseIdentifier: "PAYER_CELL")
    }
    
    func pullPayer() {
        mPayerCollection.startSync(notifier: {(payers) in
            self.mPayers = payers
            self.payerTableView.reloadData()
        
        })
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        
    
    }

    override func viewWillAppear(_ animated: Bool) {
        
        pullPayer()
    }
    
    //cancel
    @objc func cancel(_ sender: UIBarButtonItem) {
//        _ = navigationController?.popViewController(animated: true)
        appDelegate.navigateTo(instance: ViewController())
    }
    
    //Add payer
    @objc func addPayer(_ sender: UIBarButtonItem) {
        //self.dismissViewControllerNone()
        let payerForm = PayerFormViewController(nibName: "PayerFormViewController", bundle: nil)
        self.navigationController?.pushViewController(payerForm, animated: true)
    }
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mPayers.count;
        
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let payer: Payer = mPayers[indexPath.row]
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "PAYER_CELL", for: indexPath) as! PayerTableViewCell
        drawerCell.payerName.text = payer.name
        let namePrefix = String(payer.name.prefix(1))
        drawerCell.circularTextView.setText(text: namePrefix, col: Const.getColorByCharacter(character: namePrefix))
        drawerCell.circularTextView.setNeedsDisplay()
        drawerCell.date.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(payer.insert_date)), format: self.pref.getDateFormat())
        drawerCell.amount.text = UtilsIsm.formartCurrency(value: payer.total_amount, local: self.pref.getCurrency())
        
        return drawerCell
        
    }
    
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let fbPayer:FbPayer = FbPayer(reference: self.firestoreRef)
            fbPayer.delete(mPayers[indexPath.row].gid!)
            mPayers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let args:NSDictionary = ["payer": mPayers[indexPath.row]]
        //appDelegate.navigateTo(instance: PayerFormViewController(nibName: "PayerFormViewController", bundle: nil), params: args)
        let payerDetailsController = PayerDetailTabsViewController()
        payerDetailsController.params = args
        self.navigationController?.pushViewController(payerDetailsController, animated: true)
        
    }

    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("PayerNoPayer", comment: "No payer yet.")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("PayerNoPayerDescription", comment: "A payer is a person or organization that gives you money that is due for work done, goods received, or a debt incurred. e.g: Employer...")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "monetization")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let str = NSLocalizedString("PayerAddFirst", comment: "Add your first payer")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout), NSAttributedString.Key.foregroundColor: UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        //self.changeViewController(PayerFormViewController.viewIdentifier)
        let payerForm = PayerFormViewController(nibName: "PayerFormViewController", bundle: nil)
        self.navigationController?.pushViewController(payerForm, animated: true)
        
    }
    

}
