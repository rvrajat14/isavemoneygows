//
//  PayerTransactionsViewController.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 01/08/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import FirebaseFirestore
import ISMLBase
import ISMLDataService

class PayerTransactionsViewController: BaseScreenViewController,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let payerCell = tableView.dequeueReusableCell(withIdentifier: "PAYER_DETAILS_CELL", for: indexPath) as! PayerDetailsTableViewCell
            
            payerCell.payerName.text = payer?.name
            payerCell.payerAddress.text = payer?.address
            payerCell.date.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(payer!.insert_date)), format: self.pref.getDateFormat())
            payerCell.amount.text = UtilsIsm.formartCurrency(value: payer?.total_amount ?? 0.0, local: self.pref.getCurrency())
            return payerCell
        }
        
        let transactionsCell = tableView.dequeueReusableCell(withIdentifier: "TRANSACTION_CELL", for: indexPath) as! TransactionsTableViewCell
        let income = self.incomes[indexPath.row-1]
        transactionsCell.transactionName.text = income.title
        transactionsCell.transactionDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(income.transaction_date)), format: self.pref.getDateFormat())
        transactionsCell.transactionAmount.text = UtilsIsm.formartCurrency(value: income.amount, local: self.pref.getCurrency())
        return transactionsCell
    }
    
    var incomes:[Income] = []
    var payer:Payer?
    var tabsViewController:PayerDetailTabsViewController? = nil
    var incomesCollection:IncomesCollection!
    
    lazy var tableView:UITableView = {
        
        let table = UITableView()
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.payer = params["payer"] as? Payer ?? nil
        self.tabsViewController = params["tabController"] as? PayerDetailTabsViewController ?? nil
        
        self.view.addSubview(self.tableView)
        self.tableView.register(UINib(nibName: "TransactionsTableViewCell", bundle: nil), forCellReuseIdentifier: "TRANSACTION_CELL")
        self.tableView.register(UINib(nibName: "PayerDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "PAYER_DETAILS_CELL")
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor(named: "seperatorColor")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        self.tableView.edgesToSuperview(insets: .top(48), usingSafeArea: true)

        
        if self.tabsViewController?.incomes != nil{
            self.incomes =  self.tabsViewController!.incomes!
            self.tableView.reloadData()
            return
        }
        
        incomesCollection = IncomesCollection(reference: Firestore.firestore())
        incomesCollection.getByPayerGid(self.payer?.gid ?? "", onComplete: {(incomes) in
            self.incomes = incomes
            self.payer?.total_amount = self.totalIncomes(incomes: incomes);
            self.tableView.reloadData()
            self.tabsViewController?.incomes = incomes
        }, onError: {(error) in


        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if incomesCollection != nil {
            //incomesCollection.stopListner()
        }
    }
    deinit {
        if incomesCollection != nil {
            //incomesCollection.stopListner()
        }
    }
    
    private func totalIncomes(incomes: [Income]) -> Double{
        var total = 0.0;
        for income in incomes {
            total = total + income.amount
        }
        
        return total
    }
    
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let confirmDetele = ConfirmDelete()
            let income = self.incomes[indexPath.row - 1]
            let alert = confirmDetele.display(itemName: income.title,
                                              feedback: {_ in
                                                
                                                let fbIncome = FbIncome(reference: self.appDelegate.firestoreRef)
                                                fbIncome.get(income_gid: income.gid, listener: { income in
                                                    income.payer_gid = ""
                                                    income.payer_str = ""
                                                    fbIncome.update(income)
                                                }, error_message: {err in
                                                    
                                                })
                                                //fbIncome.deleteWithGid(income.gid)
                                               
                                              })
            self.present(alert, animated: true)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return indexPath.row > 0
    }


}
