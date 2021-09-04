//
//  AccountDetailsViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/13/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import TinyConstraints
import ISMLDataService
import ISMLBase


class AccountDetailsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, AccountTransactionTableViewCellDelegate {
    
    static var viewIdentifier:String = "AccountDetailsViewController"

    var transactionsTableView: UITableView!
    var txtNumberChecked: NormalTextLabel!
    var contentWrapperView: UIStackView!
    var viewsWraper:UIView!
    
    //@IBOutlet weak var detailsView: UIView!
    
    var mTransactions:[IsmTransaction] = []

    var mAccount:Account!
    var firestoreRef: Firestore!
    var pref:MyPreferences!
    var formatter: NumberFormatter!
    var mAccountObject:AccountObject!
    var appDelegate:AppDelegate!
    var flavor:Flavor!
    
    let accountType = [
        NSLocalizedString("Checking", comment: "Checking"),
        NSLocalizedString("Savings", comment: "Savings"),
        NSLocalizedString("Credit", comment: "Credit"),
        NSLocalizedString("Debit", comment: "Debit"),
        NSLocalizedString("Cash", comment: "Cash"),
        NSLocalizedString("Other", comment: "Other")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.setUpActivity()
       self.layoutComponent()
        
    }
    
    func setUpActivity() {
        
        self.pref = MyPreferences()
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef
        mAccount = params["account"] as? Account ?? nil
        
        mAccountObject = AccountObject(fireRef: firestoreRef)
        
        //
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        
        formatter = NumberFormatter()
        formatter.numberStyle = .currency
//        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(AccountDetailsViewController.cancel(_:)))
              
//        self.navigationItem.leftBarButtonItem  = cancelButton
//
//        let editButton = UIBarButtonItem(title: NSLocalizedString("text_edit", comment: "Edit"), style: .done, target: self, action:  #selector(AccountDetailsViewController.edit(_:)))
//
//        self.navigationItem.rightBarButtonItem  = editButton
        
        
    }
    
    func layoutComponent() {
        
        transactionsTableView = UITableView()
        transactionsTableView.dataSource = self
        transactionsTableView.delegate = self
        transactionsTableView.separatorColor = UIColor(named: "seperatorColor")
        transactionsTableView.rowHeight = UITableView.automaticDimension
        transactionsTableView.backgroundColor = UIColor.clear
        transactionsTableView.register(AccountHeaderTableViewCell.self,
                                             forCellReuseIdentifier: "accountHeaderTableViewCell")
        transactionsTableView.register(AccountTransactionTableViewCell.self,
                                             forCellReuseIdentifier: "accountTransactionTableViewCell")
        
        txtNumberChecked = {
          let label = NormalTextLabel()
          label.text = "7 transaction checked($1.000,00)"
          return label
        }()

        viewsWraper = UIView()
        viewsWraper.backgroundColor = UtilsIsm.getBackgroundColor(vc: self.view)
        viewsWraper.layer.borderWidth = 1
        viewsWraper.layer.borderColor = mmChrome.LIGHT_GREY.cgColor
        viewsWraper.clipsToBounds = true
        viewsWraper.layer.cornerRadius = 5
        viewsWraper.height(30)
        viewsWraper.addSubview(txtNumberChecked)
        txtNumberChecked.edgesToSuperview(excluding: .bottom, insets: .top(5) + .left(10))
          
        self.view.addSubview(transactionsTableView)
        transactionsTableView.edgesToSuperview(insets: .bottom(30), usingSafeArea: true)
        self.view.addSubview(viewsWraper)
        viewsWraper.edgesToSuperview(excluding: .top, usingSafeArea: true)
         
          
    }

    @objc func cancel(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        pullAccountTransactions()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
       
    }
    
    func pullAccountTransactions()  {
            
        mAccountObject.loadData(account_gid: mAccount.gid, dataSetChanged: {(transactions, account) in
            
            self.mTransactions = transactions.sorted(by: { $0.date>$1.date })
            
            let deposit =  self.mAccount.incomes + self.mAccount.transfers_in
            let withdraw =  self.mAccount.expenses + self.mAccount.transfers_out
            let balance =  self.mAccount.balance! + deposit - withdraw
            
            self.title = self.mAccount.name!
            
            let transaction = IsmTransaction()
            transaction.initialBalance = balance
            transaction.credit = deposit
            transaction.debit = withdraw
            transaction.type = TransactionType.HEADER
            
            self.mTransactions.insert(transaction, at: 0)
            
            
            self.transactionsTableView.reloadData()
            
            var numberChecked = 0
            var amountChecked = 0.0
            
            for transact in self.mTransactions {
                
                if transact.checked == 1 {
                    
                    numberChecked = numberChecked + 1
                    if(transact.type == TransactionType.INCOMING) {
                        amountChecked = amountChecked + transact.amount
                    } else if transact.type == TransactionType.OUTGOING {
                        amountChecked = amountChecked - transact.amount
                    }
                }
                
            }
            self.txtNumberChecked.text = "\(numberChecked) Transactions checked (\(UtilsIsm.formartCurrency(value: amountChecked, local: self.pref.getCurrency())))"
        })
        
    }
    

    

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if (mTransactions.count>0) {
            
            self.transactionsTableView.separatorStyle = .singleLine
            self.transactionsTableView.backgroundView = nil
            return mTransactions.count;
            
        } else {
            
            let messageLabel = UILabel()
            messageLabel.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            
            messageLabel.text = NSLocalizedString("AccountDetailsNoData", comment: "No data is currently available. Please pull down to refresh.");
            
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment =  NSTextAlignment.center;
            
            messageLabel.sizeToFit()
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            
            self.transactionsTableView.backgroundView = messageLabel
            self.transactionsTableView.separatorStyle = .none
            
        }
        
        return 0;
        
        //return budgetSections.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let transaction: IsmTransaction = mTransactions[indexPath.row]
        
        switch transaction.type {
        case TransactionType.HEADER:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "accountHeaderTableViewCell", for: indexPath) as! AccountHeaderTableViewCell
            headerCell.valueInitialBalance.text = UtilsIsm.formartCurrency(value: transaction.initialBalance, local: self.pref.getCurrency())
            headerCell.valueTotalDebit.text = UtilsIsm.formartCurrency(value: transaction.debit, local: self.pref.getCurrency())
            headerCell.valueTotalCredit.text = UtilsIsm.formartCurrency(value: transaction.credit, local: self.pref.getCurrency())
            let finalBalance = transaction.initialBalance - transaction.debit + transaction.credit
            headerCell.valueFinalBalance.text = UtilsIsm.formartCurrency(value: finalBalance, local: self.pref.getCurrency())
            
            return headerCell
            
        case TransactionType.INCOMING:
            let incomeCell = tableView.dequeueReusableCell(withIdentifier: "accountTransactionTableViewCell", for: indexPath) as! AccountTransactionTableViewCell
            incomeCell.textDescription.text = transaction.name
            incomeCell.textAmount.text = UtilsIsm.formartCurrency(value: transaction.amount, local: self.pref.getCurrency())
            incomeCell.textDate.text = UtilsIsm.DateTimeFormat(date: Date(timeIntervalSince1970: Double(transaction.date)))
            incomeCell.ckboxPoited.setOn(transaction.checked==1, animated: true)
            incomeCell.delegate = self
            incomeCell.position = indexPath.row
            
            return incomeCell
            
        case TransactionType.OUTGOING:
            let expenseCell = tableView.dequeueReusableCell(withIdentifier: "accountTransactionTableViewCell", for: indexPath) as! AccountTransactionTableViewCell
            expenseCell.textDescription.text = transaction.name
            expenseCell.textAmount.text = UtilsIsm.formartCurrency(value:
                transaction.amount, local: self.pref.getCurrency())
            expenseCell.textAmount.textColor = Const.RED
            expenseCell.textDate.text = UtilsIsm.DateTimeFormat(date: Date(timeIntervalSince1970: Double(transaction.date)))
            expenseCell.ckboxPoited.setOn(transaction.checked==1, animated: true)
            expenseCell.delegate = self
            expenseCell.position = indexPath.row
            
            return expenseCell
       
        }
        
        
        
    }
    
    func accountTransactionTableViewCellDidTaped(_ sender: AccountTransactionTableViewCell, position: Int) {
        
        let transaction:IsmTransaction = mTransactions[position]
        transaction.checked = (transaction.checked + 1)%2
        
        switch transaction.typeEntry {
        case TypeEntry.INCOME:
            let fbIncome:FbIncome = FbIncome(reference: self.firestoreRef)
            fbIncome.get(income_gid: transaction.gid, listener: { (income) in
                income.checked = transaction.checked
                _ = fbIncome.update(income, completion: {(income) in
                    
                }, error_message: {(error) in
                    
                })
            }, error_message: {(error) in
                print(error)
            })
            break
        case TypeEntry.EXPENSE:
            let fbExpense:FbExpense = FbExpense(reference: self.firestoreRef)
            fbExpense.get(transaction.gid, listener: {(expense) in
                expense.checked = transaction.checked
                _ = fbExpense.update(expense, completion: {(expense) in
                    
                }, error_message: {(error) in
                    
                })
            }, error_message: {(error) in
                print(error)
            })
            break
        case TypeEntry.TRANSFER_IN:
            let fbTransfer:FbTransfer = FbTransfer(reference: self.firestoreRef)
            fbTransfer.get(transaction.gid, listener: {(transfer) in
                transfer.checked = transaction.checked
                _ = fbTransfer.update(transfer, completion: {(transfer) in
                    
                }, error_message: {(error) in
                    print(error)
                })
            }, error_message: {(error) in
                print(error)
            })
            break
        case TypeEntry.TRANSFER_OUT:
            let fbTransfer:FbTransfer = FbTransfer(reference: self.firestoreRef)
            fbTransfer.get(transaction.gid, listener: {(transfer) in
                transfer.checked = transaction.checked
                _ = fbTransfer.update(transfer, completion: {(transfer) in
                    
                }, error_message: {(error) in
                    
                })
            }, error_message: {(error) in
                print(error)
            })
            break
        }
    }

}
