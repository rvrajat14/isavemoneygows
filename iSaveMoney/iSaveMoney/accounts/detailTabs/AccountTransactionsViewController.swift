//
//  AccountTransactionsViewController.swift
//  iSaveMoneyAcc
//
//  Created by Sai Akhil on 15/08/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLDataService
import ISMLBase

class AccountTransactionsViewController: BaseScreenViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, DateDelegate, TranactionCheckedDelegate {
    
    
    func dateSelected(tag: Int, cancel: Bool) {
        if tag == 1{
            self.fromDateTextField.resignFirstResponder()
            if !cancel {
                self.fromDateTextField.text = Utils.formatTimeStamp(Int(self.fromDateSelector.date.timeIntervalSince1970))
                self.isFromDateSelected = true
            }
        }else if tag == 2{
            self.toDateTextField.resignFirstResponder()
            if !cancel {
                self.toDateTextField.text = Utils.formatTimeStamp(Int(self.toDateSelector.date.timeIntervalSince1970))
                self.isToDateSelected = true
            }
        }
        if(!cancel){
            self.resetListBasedOnTag()
        }
    }
    
    
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction: IsmTransaction = mTransactions[indexPath.row]
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "ACC_TRANS_CELL", for: indexPath) as! AccountTransactionsTableViewCell
        
        drawerCell.transactionNameLabel.text = transaction.name
        drawerCell.dateLabel.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(transaction.date)), format: self.pref.getDateFormat())
        //drawerCell.isCheckedLabel.isHidden = (transaction.checked == 1)
        var iw = NiceImageView(image: UIImage(named: "ic_circle"))
        if transaction.checked == 1 {
            iw = NiceImageView(image: UIImage(named: "ic_filled_circle"))
           
        }
        iw.isUserInteractionEnabled = true
        iw.tintColor = Const.BLUE
        drawerCell.isCheckedButton.setImage(iw.image, for: .normal)
        drawerCell.tag = indexPath.row
        drawerCell.delegate =  self
        
        if(transaction.type == TransactionType.INCOMING) {
            drawerCell.amountLabel.text = String(format: "+%@", UtilsIsm.formartCurrency(value: transaction.amount, local: self.pref.getCurrency()))
            drawerCell.amountLabel.textColor = UIColor(red: 0.00, green: 0.69, blue: 0.63, alpha: 1.00)
        } else if transaction.type == TransactionType.OUTGOING {
            drawerCell.amountLabel.text = UtilsIsm.formartCurrency(value: transaction.amount, local: self.pref.getCurrency())
            drawerCell.amountLabel.textColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
        }
        
        return drawerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    @IBOutlet weak var comingInBorderLabel: UILabel!
    @IBOutlet weak var goingOutBorderLabel: UILabel!
    @IBOutlet weak var allBorderLabel: UILabel!
    
    @IBOutlet weak var comingInLabel: UILabel!
    @IBOutlet weak var goingOutLabel: UILabel!
    
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var totalCheckedAmountLabel: UILabel!
    @IBOutlet weak var allLabelButton: UILabel!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var accountNameLabel: UILabel!
    
    var mAccount:Account? = nil
    var mTransactionFull:[IsmTransaction] = []
    var mTransactions:[IsmTransaction] = []
    var amountChecked:Double = 0.0
    var selectedTransactionTag = 1
    
    var fromDateSelector:CalendarPicker!
    var toDateSelector:CalendarPicker!
    
    var isToDateSelected = false
    var isFromDateSelected = false
    
    var tabsViewController:AccountTabsViewController? = nil
    var mAccountObject:AccountCollecttion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mAccountObject = AccountCollecttion(fireRef: firestoreRef)
        mAccount = params["account"] as? Account ?? nil
        self.tabsViewController = params["tabController"] as? AccountTabsViewController ?? nil
        self.setCheckedAmount()
        self.tabelView.delegate = self
        self.tabelView.dataSource = self
        self.tabelView.backgroundColor = UIColor.clear
        self.tabelView.separatorColor = UIColor.clear
        self.accountNameLabel.text = mAccount?.name
        self.availableBalanceLabel.text = UtilsIsm.formartCurrency(value: mAccount?.balance ?? 0.0, local: self.pref.getCurrency())
        
        let tableViewCellNib = UINib(nibName: "AccountTransactionsTableViewCell", bundle: nil)
        self.tabelView.register(tableViewCellNib, forCellReuseIdentifier: "ACC_TRANS_CELL")
//        if self.tabsViewController?.mTransactions != nil{
//            self.mTransactionFull = self.tabsViewController!.mTransactions!
//            self.initData()
//        }else{
//            self.loadData()
//        }
        self.loadData()
        self.resetListSelectionLabels()
        
        let defaultDate = Date()
        self.fromDateSelector = CalendarPicker()
        self.fromDateSelector.tag = 1
        self.fromDateSelector.delegate = self
        self.fromDateSelector.setUp(widthSize: Int(self.view.frame.width),
                           heightSize: 220,
                           selectedDate: defaultDate,
                           displayToday: false, dformat: pref.getDateFormat())
        //self.fromDateSelector.date = defaultDate
        
        self.toDateSelector = CalendarPicker()
        self.toDateSelector .tag = 2
        self.toDateSelector.delegate = self
        self.toDateSelector.setUp(widthSize: Int(self.view.frame.width),
                           heightSize: 220,
                           selectedDate: defaultDate,
                           displayToday: false, dformat: pref.getDateFormat())
        //self.toDateSelector.date = defaultDate
        
        self.initDateSelectors(self.fromDateTextField, tag: 1, calendarPicker: self.fromDateSelector, defaultDate: defaultDate)
        
        self.initDateSelectors(self.toDateTextField, tag: 2, calendarPicker: self.toDateSelector, defaultDate: defaultDate)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if mAccountObject != nil {
            mAccountObject.stopListner()
        }
    }
    deinit {
        if mAccountObject != nil {
            mAccountObject.stopListner()
        }
    }
    private func initDateSelectors(_ textField:UITextField, tag:Int, calendarPicker:CalendarPicker,defaultDate:Date){
        
        textField.delegate = self
        textField.rightView = self.getTextFieldRightImageView(named: "date_range")
        textField.rightViewMode = UITextField.ViewMode.always
        textField.tag = tag
        
        textField.inputView = calendarPicker
        textField.inputAccessoryView = calendarPicker.toolBar
        //textField.text = UtilsIsm.DateFormat(date: defaultDate, format: self.pref.getDateFormat())
    }
    
    func getTextFieldRightImageView(named:String) -> UIImageView{
        let imageViewCategory = UIImageView()
        let imageArrow = UIImage(named: named)
        imageViewCategory.image = imageArrow
        imageViewCategory.alpha = 0.5
        imageViewCategory.image = imageViewCategory.image!.withRenderingMode(.alwaysTemplate)
        imageViewCategory.tintColor = UIColor.gray
        imageViewCategory.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        return imageViewCategory
    }
    
    private func loadData(){
        mAccountObject.loadData(account_gid: mAccount!.gid, dataSetChanged: {(transactions, account) in
            self.mAccount = account
            self.mTransactionFull = transactions.sorted(by: { $0.date>$1.date })
            if self.mTransactionFull.count > 0 {
                self.tabsViewController?.mTransactions = self.mTransactionFull
            }
            self.initData()
        })
    }
    
    private func initData(){
        let deposit =  self.mAccount!.incomes + self.mAccount!.transfers_in
        let withdraw =  self.mAccount!.expenses + self.mAccount!.transfers_out
        self.availableBalanceLabel.text  = UtilsIsm.formartCurrency(value: self.mAccount!.balance + deposit - withdraw, local: self.pref.getCurrency())
        self.resetListBasedOnTag()
    }
    
    
    private func resetListBasedOnTag(){
        if self.selectedTransactionTag == 1{
            self.mTransactions = self.mTransactionFull
        }else{
            self.mTransactions = self.mTransactionFull.filter{(transaction) in
                if(self.selectedTransactionTag == 2){
                   return transaction.type == TransactionType.OUTGOING
                }else{
                    return transaction.type == TransactionType.INCOMING
                }
            }
        }
        
        if self.isToDateSelected && self.isFromDateSelected{
            self.mTransactions  = self.mTransactions.filter{(transaction) in
                return (transaction.date >= Int(self.fromDateSelector.date.timeIntervalSince1970) && transaction.date <= Int(self.toDateSelector.date.timeIntervalSince1970))
            }
        }
        self.tabelView.reloadData()
        self.calculateCheckedTransactionsAmount()
        self.resetListSelectionLabels()
        
    }
    
    private func getTransactionAmount(transaction:IsmTransaction) ->Double {
        if(transaction.type == TransactionType.INCOMING) {
            return transaction.amount
        } else if transaction.type == TransactionType.OUTGOING {
            return -1 * transaction.amount
        }
        return 0
    }
    
    private func calculateCheckedTransactionsAmount(){
        DispatchQueue.global(qos: .background).async {
            self.amountChecked = 0.0
            for transact in self.mTransactions {
                if transact.checked == 1 {
                    self.amountChecked = self.amountChecked + self.getTransactionAmount(transaction: transact)
                }
            }
            DispatchQueue.main.async {
                self.setCheckedAmount()
            }
        }
    }
    
    private func setCheckedAmount(){
        if amountChecked < 0.0 {
            self.totalCheckedAmountLabel.text = UtilsIsm.formartCurrency(value: -1 * self.amountChecked, local: self.pref.getCurrency())
            self.totalCheckedAmountLabel.textColor = UIColor(red: 0.72, green: 0.00, blue: 0.00, alpha: 1.00)
        }else{
            self.totalCheckedAmountLabel.text = String(format: "+%@", UtilsIsm.formartCurrency(value: self.amountChecked, local: self.pref.getCurrency()))
            self.totalCheckedAmountLabel.textColor = UIColor(red: 0.00, green: 0.62, blue: 0.98, alpha: 1.00)
        }
    }
    
    private func resetListSelectionLabels(){
        self.setBorderAndColorForLabel(self.allLabelButton,self.allBorderLabel, isSelected: self.selectedTransactionTag == 1)
        self.setBorderAndColorForLabel(self.goingOutLabel,self.goingOutBorderLabel, isSelected: self.selectedTransactionTag == 2)
        self.setBorderAndColorForLabel(self.comingInLabel,self.comingInBorderLabel, isSelected: self.selectedTransactionTag == 3)
    }
    
    private func setBorderAndColorForLabel(_ label:UILabel,_ borderLabel:UILabel,isSelected:Bool){
        if isSelected {
            borderLabel.isHidden = false
            label.textColor = #colorLiteral(red: 0, green: 0.6117647059, blue: 0.9803921569, alpha: 1)
            label.font = UIFont.boldSystemFont(ofSize: 14.0)
        }else{
            borderLabel.isHidden = true
            label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 14.0)
        }
    }
    
    func onCheckTransaction(tnxCell: AccountTransactionsTableViewCell) {
        let transact = mTransactions[tnxCell.tag]
        if transact.typeEntry == .EXPENSE {
            let fbExpense = FbExpense(reference: self.appDelegate.firestoreRef)
            fbExpense.ticker(gid: transact.gid, state: (transact.checked+1)%2)
        }else if transact.typeEntry == .INCOME {
            let fbIncome = FbIncome(reference: self.appDelegate.firestoreRef)
            fbIncome.ticker(gid: transact.gid, state: (transact.checked+1)%2)
        }else {
            let fbTransfer = FbTransfer(reference: self.appDelegate.firestoreRef)
            fbTransfer.ticker(gid: transact.gid, state: (transact.checked+1)%2)
        }
        //self.setCheckedAmount()
    }
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            let confirmDetele = ConfirmDelete()
            let alert = confirmDetele.display(itemName: mTransactions[indexPath.row].name,
                                              feedback: {_ in
                                                
                                                if self.mTransactions[indexPath.row].typeEntry == .EXPENSE {
                                                    let fbExpense = FbExpense(reference: self.appDelegate.firestoreRef)
                                                    let expenseId = self.mTransactions[indexPath.row].gid
                                                    fbExpense.get(expenseId, listener: {expense in
                                                        expense.account_gid = ""
                                                        expense.account_str = ""
                                                        fbExpense.update(expense)
                                                    }, error_message: { err in
                                                        
                                                    })
                                                    //fbExpense.deleteWithGid(self.mTransactions[indexPath.row].gid)
                                                }else if self.mTransactions[indexPath.row].typeEntry == .INCOME {
                                                    let fbIncome = FbIncome(reference: self.appDelegate.firestoreRef)
                                                    let incomeId = self.mTransactions[indexPath.row].gid
                                                    fbIncome.get(income_gid: incomeId, listener: { income in
                                                        income.account_gid = ""
                                                        income.account_str = ""
                                                        fbIncome.update(income)
                                                    }, error_message: { err in
                                                        
                                                    })
                                                    //fbIncome.deleteWithGid(self.mTransactions[indexPath.row].gid)
                                                }else {
                                                    let fbTransfer = FbTransfer(reference: self.appDelegate.firestoreRef)
                                                    fbTransfer.deleteWithGid(self.mTransactions[indexPath.row].gid)
                                                }
                                               
                                              })
            self.present(alert, animated: true)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    @IBAction func onAllClicked(_ sender: Any) {
        if self.selectedTransactionTag != 1{
            self.selectedTransactionTag = 1
            self.resetListBasedOnTag()
        }
        
    }
    @IBAction func onGoingOutTapped(_ sender: Any) {
        if self.selectedTransactionTag != 2{
            self.selectedTransactionTag = 2
            self.resetListBasedOnTag()
        }
    }
    @IBAction func onComingInTapped(_ sender: Any) {
        if self.selectedTransactionTag != 3{
            self.selectedTransactionTag = 3
            self.resetListBasedOnTag()
        }
    }
    
}
