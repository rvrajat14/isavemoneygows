//
//  ViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/8/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import MessageUI
import GoogleSignIn
import FirebaseFirestore
import TinyConstraints
import MMDrawerController
import ISMLBase
import ISMLDataService
import CheckoutModule
import CoreData

class ViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UITabBarDelegate, DLDisplayScreen, CategoryCellDelegate {
    
    
    
    static var viewIdentifier:String = "ViewController"
    var isAnonymous:Bool = false
    var listnerForUnread: ListenerRegistration!
    var mapNewBudgets:[String:UserOwnBudget] = [:]
    
    lazy var loadingMessage:NormalTextLabel = {
        let messageLabel = NormalTextLabel()
        messageLabel.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        messageLabel.text =  NSLocalizedString("noDataCurrentlyAvailableText", comment: "No data is currently available.");
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment =  NSTextAlignment.center;
        return messageLabel
    }()
    lazy var tableView: UITableView = {
        var table = UITableView()
        //table.estimatedRowHeight = 132.0
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.clear
        table.rowHeight = UITableView.automaticDimension
        table.allowsSelectionDuringEditing = false
        table.separatorStyle = .none
        table.separatorInset = UIEdgeInsets.zero
        table.separatorColor = UIColor.clear
        //table.tableFooterView = UIView(frame: CGRect.zero)
        table.backgroundView = loadingMessage
        
        return table
    }()
    
    lazy var addExpense:UITabBarItem = {
        let t = UITabBarItem()
        t.title = NSLocalizedString("tabExpense", comment: "Add expense")
        t.image = UIImage(named: "add_expense")
        t.tag = 0
        return t
    }()
    lazy var addIncome:UITabBarItem = {
        let t = UITabBarItem()
        t.title = NSLocalizedString("tabIncome", comment: "Add income")
        t.image = UIImage(named: "add_income")
        t.tag = 1
    return t
    }()
    lazy var addCategory:UITabBarItem = {
        let t = UITabBarItem()
        t.title = NSLocalizedString("tabCategory", comment: "Add category")
        t.image = UIImage(named: "add_category")
        t.tag = 2
        return t
    }()
    lazy var actionMenu:UITabBarItem = {
        let t = UITabBarItem()
        t.title = NSLocalizedString("tabWanto", comment: "I want to...")
        t.image = UIImage(named: "menu")
        t.tag = 3
        return t
    }()
    lazy var budgetTabBarMenu:UITabBar = {
        let tabBar = UITabBar()
        tabBar.height(50)
        tabBar.setItems([addExpense, addIncome, addCategory, actionMenu], animated: false)
        return tabBar
    }()

    
    
    lazy var clearNotifBtn: ButtonImage = {
        let iw = ButtonImage(image: "ic_clear", color: Const.BLUE)//ic_clear
        iw.width(24)
        iw.height(24)
        iw.addTarget(self, action: #selector(closeNewBudgetNotif), for: .touchUpInside)
        return iw
    }()
    lazy var sharedImage: NiceImageView = {
        let iw = NiceImageView(image: UIImage(named: "ic_shared"))
        iw.width(32)
        iw.height(32)
        iw.tintColor = Const.INFO_GREEN
        return iw
    }()
    lazy var labelMessage:NiceLabel = {
        let label = NiceLabel(title: NSLocalizedString("text_new_budget_there", comment: "New"))
        label.textColor = Const.INFO_GREEN
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    lazy var buttonOpen:TransButton = {
        let button = TransButton(title: NSLocalizedString("text_new_open", comment: "Open"))
        button.setTitleColor(Const.BLUE, for: .normal)
        button.addTarget(self, action: #selector(openListOfBudget), for: .touchUpInside)
        return button
    }()
    lazy var newBudgetAvailableView:UIView = {
        let view = UIView()
        
        view.backgroundColor = Const.INFO_GREEN_BG
        view.addSubview(labelMessage)
        view.height(90)
        view.isHidden = true
        labelMessage.centerXToSuperview()
        labelMessage.topToSuperview(offset: 10)
        labelMessage.widthToSuperview()
        view.addSubview(buttonOpen)
        buttonOpen.centerXToSuperview()
        buttonOpen.topToBottom(of: labelMessage, offset: 10)
        view.addSubview(sharedImage)
        sharedImage.centerYToSuperview()
        sharedImage.leftToSuperview(offset: 12)
        
        view.addSubview(clearNotifBtn)
        clearNotifBtn.topToSuperview(offset: 10)
        clearNotifBtn.rightToSuperview(offset: -10)
        return view
    }()
    
    lazy var drawerButton:UIBarButtonItem = {
        let menuItem = UIBarButtonItem(image: UIImage(named: "menu"), landscapeImagePhone: UIImage(named: "menu"), style: .plain, target: self, action: #selector(ViewController.openDrawerButton(_:)))
        return menuItem
    }()
    lazy var inviteButton:UIBarButtonItem = {
        let menu = UIBarButtonItem(image: UIImage(named: "ic_person_add"),
                                   landscapeImagePhone: UIImage(named: "ic_person_add"),
                                   style: .plain, target: self, action: #selector(ViewController.inviteUser(_:) ))
        return menu
    }()
    var budgetSections: [BudgetSection] = []
    
    var dateformat: Utils!
    var firebaseRef: Firestore!
    var pref: MyPreferences!
    var alReadySearch = false
    var mBudget:Budget!
    var mBudgetObject: BudgetObject!
    var flavor:Flavor!
    var appDelegate:AppDelegate!

    override func getTag() -> String {
        
        return ViewController.viewIdentifier
    }
    
    override func orientationChanged()  {
        
        self.tableView.reloadData()
        
    }
    
    @objc func deviceRotated(){
        self.tableView.reloadData()
    }
    
    override var prefersStatusBarHidden : Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData()
    }
    
    @objc func closeNewBudgetNotif() {
        
        self.newBudgetAvailableView.isHidden = true
    }
    @objc func openListOfBudget() {
        self.navigationController?.pushViewController(BudgetsTableViewController(), animated: true)
        
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpActivity()
        self.layoutComponent()
        self.setupInitialState()
        self.unreadBudget()
        //tryMigrateUser()
        
        self.appDelegate.notifyDrawer()
        
       
    }
    
    func setUpActivity() {
        
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.title = NSLocalizedString("loadingText", comment: "Loading text on main screen")
        self.dateformat = Utils()
        self.firebaseRef = appDelegate.firestoreRef
        self.pref = MyPreferences()
        self.mBudgetObject = BudgetObject(reference: firebaseRef)
        
        self.navigationItem.leftBarButtonItem  = drawerButton
        self.navigationItem.rightBarButtonItems  = [inviteButton]
        self.view.backgroundColor = UIColor(named: "pageBgColor")
    }
    
    func layoutComponent() {
        
        self.view.addSubview(tableView)
        tableView.edgesToSuperview(insets:  .bottom(50), usingSafeArea: true)
        
        self.view.addSubview(budgetTabBarMenu)
               budgetTabBarMenu.edgesToSuperview(excluding: .top, insets:  .left(0) + .right(0) + .bottom(0), usingSafeArea: true)
        
        self.view.addSubview(newBudgetAvailableView)
        newBudgetAvailableView.edgesToSuperview(excluding: .top, insets:  .left(0) + .right(0) + .bottom(0), usingSafeArea: true)
        newBudgetAvailableView.setHugging(.defaultHigh, for: .vertical)
        

        
        self.budgetTabBarMenu.unselectedItemTintColor = UIColor(named: "tabUnselectedColor")
       
        self.tableView.register(SummaryTableViewCell.self, forCellReuseIdentifier: "summaryTableCell")
        self.tableView.register(SectionEndTableViewCell.self, forCellReuseIdentifier: "sectionEndTableViewCell")
        self.tableView.register(TotalTableViewCell.self, forCellReuseIdentifier: "totalTableCell")
        self.tableView.register(IncomeTableViewCell.self, forCellReuseIdentifier: "incomeTableViewCell")
        let tableViewCellNib = UINib(nibName: "CategoryViewCell", bundle: nil)
        self.tableView.register(tableViewCellNib, forCellReuseIdentifier: "categoryViewCell")
        self.tableView.register(EmptyBudgetTableViewCell.self, forCellReuseIdentifier: "emptyBudgetTableViewCell")
        
        self.budgetTabBarMenu.delegate = self
        self.budgetTabBarMenu.barTintColor = UIColor(named: "tabBgColor")
        self.budgetTabBarMenu.tintColor = UIColor(named: "tabTintColor")
    }
    
    func setupInitialState() {
        
        budgetSections = []
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
//        gradientLayer.frame = view.bounds
//        self.view.layer.backgroundColor =  UIColor(white: 1, alpha: 0.5).cgColor

    }
    
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        
        //item.tag
        switch item.tag {
        case 0:
            self.newExpense()
            break
        case 1:
            self.newIncome()
            break
        case 2:
            self.newCategory()
            break
        case 3:
            self.moreActions()
            break
        default:
            break
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        self.loadCurrentBudget(budgetGid: self.pref.getSelectedMonthlyBudget())
//        setRecentBudget(callback: { userOwn in
//
//            self.loadCurrentBudget(oUserOwnBudget: userOwn)
//        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.mBudgetObject?.stopSync()
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        listnerForUnread?.remove()
        
    }
    
    func setRecentBudget(callback: @escaping (UserOwnBudget)->Void) {
        
        let budgets:[UserOwnBudget] = appDelegate.getLastThreeBudgets()
        
        if budgets.count > 0 {
            
            let budget = budgets[0]
            
            self.pref.setSelectedMonthlyBudget(budget.budgetGid)
            callback(budget)
            //appDelegate.notifyDrawer()
            
        } else {
            
            let fbBudget = FbBudget(reference: self.firebaseRef)
            fbBudget.getUserBudgetsActive(user_gid: self.pref.getUserIdentifier(), onBudgetRead: { (userOwnsBudgets) in

                let userOwnsBudgetsSorted = userOwnsBudgets.sorted(by: { $0.last_used > $1.last_used })
                if userOwnsBudgetsSorted.count > 0 {
                    
                    var budgetEntries:[UserOwnBudget] = []
                    var count = 0
                    for userBudget in userOwnsBudgetsSorted {
                        if count<3 {
                            budgetEntries.append(userBudget)
                            
                        } else {
                            break
                        }
                        count = count + 1
                    }
                    self.appDelegate.setLastThreeBudgets(lastThree: budgetEntries)
                    let lastThree = self.appDelegate.getLastThreeBudgets()
                    self.pref.setSelectedMonthlyBudget(lastThree[0].budgetGid)
                    callback(lastThree[0])
                    self.appDelegate.notifyDrawer()
                    
                } else {
                    
                    //Display first screen
                    self.pref.setSelectedMonthlyBudget("")
                    self.newMonthlyBudget()
                    self.appDelegate.notifyDrawer()
                }
                
            })
            
            
        }
    }
    
    func loadCurrentBudget(budgetGid: String) {
        
        
        self.mBudgetObject.startSync(budgetGid: budgetGid, renderBudget: {(budgetSections, budget, deleted) in
        
            if deleted {
                self.alertBudgetDeleted(budgetGid: budget.gid)
            }
            
            self.mBudget = budget
            self.budgetSections = budgetSections
            self.updateTitle(budget)
            
            self.appDelegate.setCategoriesList(cats: self.mBudgetObject.getListCategories())
            self.appDelegate.selectedBudgetGid = budget.gid
            
            self.tableView.reloadData();
            //self.appDelegate.notifyDrawer()
        
        }, error_msg: {(errorMessage) in
            
            let budgets:[UserOwnBudget] = self.appDelegate.getLastThreeBudgets()
            if budgets.count <= 0 {
                
                self.newMonthlyBudget()
            }
            
            self.appDelegate.notifyDrawer()
            
        })
        
    }
    
    func alertBudgetDeleted(budgetGid:String) {
        
        let alert = UIAlertController(title: NSLocalizedString("budget_removed_title", comment: "title"),
                                      message: NSLocalizedString("budget_removed", comment: "body"),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("budget_removed_ok",
            comment: "ok"),
            style: .default, handler: {_ in
                
                                        
                let last3Budgets = self.appDelegate.getLastThreeBudgets()
                var newMerged:[UserOwnBudget] = []
                if last3Budgets.count > 0 {
                    for userOwn in last3Budgets {
                        if userOwn.budgetGid != budgetGid {
                            newMerged.append(userOwn)
                        }
                    }
                }
                self.appDelegate.setLastThreeBudgets(lastThree: newMerged)
                
                self.setRecentBudget(callback: { userOwn in
                                        //self.loadCurrentBudget(oUserOwnBudget: userOwn)
                    self.navigationController?.pushViewController(BudgetsTableViewController(), animated: true)
                })
                
        }))
        
        self.present(alert, animated: true)
    }
    
    func deleteCurrentBudget()  {
        var bdgetId:String = ""
        if self.mBudgetObject != nil && self.mBudgetObject.formBudget() != nil {
            bdgetId = self.mBudgetObject.formBudget().gid
        }
       
        self.mBudgetObject.delete(cleaned: {
            
            let container: NSPersistentContainer = self.appDelegate.persistentContainer
            RecentBudgetsHelper.delete(viewContext: container.viewContext, thisId: bdgetId)
        
         
            self.pref.setSelectedMonthlyBudget("")
            self.appDelegate.notifyDrawer()
            self.newMonthlyBudget()
            
           
            
        })
        
       
    }
    
    
    func newMonthlyBudget()  {
        
       
        self.appDelegate.navigateTo(instance: CreateViewController())
       
    }
    
    
    func updateTitle(_ budget: Budget) {
        
        self.title = IsmUtils.makeTitleFor(budget: budget)
    }
    
   
    @objc func openDrawerButton(_ sender: UIBarButtonItem) {
        
        self.appDelegate.toggleDrawerNav()
    }
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (budgetSections.count>0) {
            
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView?.isHidden = true

            return budgetSections.count;
            
        } else {
            
            
            self.tableView.backgroundView?.isHidden = false
            self.tableView.separatorStyle = .none
            
        }
        
        return 0;
    
        //return budgetSections.count
    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let budgetSection: BudgetSection = budgetSections[indexPath.row]
        var rowHeight:CGFloat = 40.0
        
        
        return rowHeight
        
    }

    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let budgetSection: BudgetSection = budgetSections[indexPath.row]
      
        
        switch budgetSection.type {
            //titleTableCell
            
//        case RowType.incomeVsExpense:
//            
//            
//            let drawerCell = tableView.dequeueReusableCell(withIdentifier: "cfpIncomeVsExpenseTableViewCell", for: indexPath) as! CFPIncomeVsExpenseTableViewCell
//            
//            drawerCell.incomeValueLabel.text = UtilsIsm.formartCurrency(value: budgetSection.value, local: self.pref.getCurrency())
//            
//            drawerCell.expenseValueLabel.text = UtilsIsm.formartCurrency(value: budgetSection.spent, local: self.pref.getCurrency())
//            
//            drawerCell.savingValueLabel.text = UtilsIsm.formartCurrency(value: (budgetSection.value - budgetSection.spent), local: self.pref.getCurrency())
//            //
//         
//            return drawerCell
            
        case RowType.title:
            let drawerCell = tableView.dequeueReusableCell(withIdentifier: "titleTableCell", for: indexPath) as! TitleTableViewCell
            
            drawerCell.labelTitle.text = budgetSection.title
            
            return drawerCell
            
        case RowType.income:
 
            let drawerCell = tableView.dequeueReusableCell(withIdentifier: "incomeTableViewCell", for: indexPath) as! IncomeTableViewCell
            
            drawerCell.incomeTitle.text = budgetSection.title
            drawerCell.incomeValueLabel.text = UtilsIsm.formartCurrency(value: budgetSection.value, local: self.pref.getCurrency())
            
            let namePrefix = String(budgetSection.title.prefix(1))
            drawerCell.leterCircled.setText(text: namePrefix, col: Const.getColorByCharacter(character: namePrefix))
            
            drawerCell.leterCircled.setNeedsDisplay()
            return drawerCell
            
        case RowType.category:
            
            
           // if flavor.getFlavor() == FlavorType.moneymaximixer {
                
            let drawerCell = tableView.dequeueReusableCell(withIdentifier: "categoryViewCell", for: indexPath) as! CategoryViewCell
            
            let remaining = budgetSection.budget - budgetSection.spent
            drawerCell.categoryTitle.text = budgetSection.title
            
            drawerCell.remainingValueLabel.text = UtilsIsm.formartCurrency(value: remaining, local: self.pref.getCurrency())
            
            drawerCell.actualSpendValueLabel.text = UtilsIsm.formartCurrency(value: budgetSection.spent, local: self.pref.getCurrency())
            
            drawerCell.budgetSpendValueLabel.text = UtilsIsm.formartCurrency(value: budgetSection.budget, local: self.pref.getCurrency())
            
            if budgetSection.budget <= 0 {
                
                drawerCell.budgetSpendValueLabel.text = "N/A"
                drawerCell.remainingValueLabel.text = "N/A"
            }
            
            drawerCell.progressGraph.reDraw(budgetSection.budget!,
                                            spent: budgetSection.spent!,
                                            color: UIColor(named: "progressLevelColor")!,
                                            bgColor: UIColor(named: "progressBaseColor")!)
            
            drawerCell.progressGraph.setNeedsDisplay()
            if budgetSection.budget == 0 {
                drawerCell.progressGraph.isHidden = true
            }else {
                drawerCell.progressGraph.isHidden = false
            }
            //drawerCell.addExpenseBtn.setNeedsDisplay()
            drawerCell.delegate = self
            ///////////////
            return drawerCell
            
           
            
        case RowType.totalCategory:
            
            //if flavor.getFlavor() == FlavorType.moneymaximixer {
                
                let drawerCell = tableView.dequeueReusableCell(withIdentifier: "totalTableCell", for: indexPath) as! TotalTableViewCell
                
                drawerCell.totalLabel.text = budgetSection.title
                drawerCell.totalValueLabel.text = UtilsIsm.formartCurrency(value: budgetSection.value, local: self.pref.getCurrency())
                
                return drawerCell
            
            
        case RowType.totalIncome:
            
            //if flavor.getFlavor() == FlavorType.moneymaximixer {
                
                let drawerCell = tableView.dequeueReusableCell(withIdentifier: "totalTableCell", for: indexPath) as! TotalTableViewCell
                
                drawerCell.totalLabel.text = budgetSection.title
                drawerCell.totalValueLabel.text = UtilsIsm.formartCurrency(value: budgetSection.value, local: self.pref.getCurrency())
                
                return drawerCell
//        case RowType.endSection:
//
//            let drawerCell = tableView.dequeueReusableCell(withIdentifier: "sectionEndTableViewCell", for: indexPath) as! SectionEndTableViewCell
//
//            return drawerCell
        case RowType.emptyBudget:
            
            let drawerCell = tableView.dequeueReusableCell(withIdentifier: "emptyBudgetTableViewCell", for: indexPath) as! EmptyBudgetTableViewCell
            
            return drawerCell
            
        case RowType.stat:
            
           let drawerCell = tableView.dequeueReusableCell(withIdentifier: "summaryTableCell", for: indexPath) as! SummaryTableViewCell
            
            drawerCell.incomeValueLabel.text = UtilsIsm.formartCurrency(value: budgetSection.value, local: self.pref.getCurrency())
            
           
            drawerCell.provisionalBudgetValueLabel.text = UtilsIsm.formartCurrency(value: budgetSection.budget, local: self.pref.getCurrency())
           
            var provisionalBalance = budgetSection.value - budgetSection.budget
            if budgetSection.budget < budgetSection.spent {
                provisionalBalance = budgetSection.value - budgetSection.spent
            }
            drawerCell.provisionalBalanceValueLabel.text = UtilsIsm.formartCurrency(value: provisionalBalance, local: self.pref.getCurrency())
            
            drawerCell.spentToDateValueLabel.text = UtilsIsm.formartCurrency(value: budgetSection.spent, local: self.pref.getCurrency())
            
            drawerCell.remainingToSpentValueLabel.text = UtilsIsm.formartCurrency(value: (budgetSection.budget - budgetSection.spent), local: self.pref.getCurrency())
           
            
            drawerCell.startBar.reDraw(budgetSection.budget!, spent: budgetSection.spent!,
                                       color: Const.graphicsColor)
            drawerCell.startBar.setNeedsDisplay()
            
            drawerCell.statCircle.reDraw(budgetSection.budget!, spent: budgetSection.spent!, income: budgetSection.value + budgetSection.initialBalance, localCd: self.pref.getCurrency())
            drawerCell.statCircle.setNeedsDisplay()
            
            drawerCell.startNote.text = "\(round(budgetSection.spent/budgetSection.value*100))% \(NSLocalizedString("percentSpent", comment: "of income spent"))"
            
            if budgetSection.hasInitialBalance {
                drawerCell.initialBalanceCard.isHidden = false
                drawerCell.initialBalanceValue.text = UtilsIsm.formartCurrency(value: budgetSection.initialBalance, local: self.pref.getCurrency())
            } else {
                drawerCell.initialBalanceCard.isHidden = true
            }
            return drawerCell
        
        }
    }
    
    
    func didTapAdd(_ sender: CategoryViewCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }

        let budgetSection: BudgetSection = budgetSections[tappedIndexPath.row]
        
        
        let args:NSDictionary = [
            "minDate": Date(timeIntervalSince1970: Double(self.mBudget.start_date)),
            "maxDate": Date(timeIntervalSince1970: Double(self.mBudget.end_date)),
            "initialCategory": budgetSection.gid
        ]
        
        let newExp = NewExpenseViewController()
        newExp.params = args
        newExp.allowOutOfRange = mBudget.allowOutRange
        newExp.budgetGid = mBudget.gid
        self.present(UINavigationController(rootViewController: newExp), animated: true)
        //self.navigationController?.pushViewController(newExp, animated: true)
    }
    
    
    
    func moreActions() {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: NSLocalizedString("actionSheeetWantTo", comment: "I want to ..."), preferredStyle: .actionSheet)

        
        let duplicateAction = UIAlertAction(title: NSLocalizedString("actionSheetDuplicate", comment: "Duplicate"), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.canUserCreateBudget()
           
        })
        
        let configureAction = UIAlertAction(title: NSLocalizedString("actionSheetConfigure", comment: "Configure"), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if self.mBudget.owner! != self.pref.getUserIdentifier() {
                
                self.displayDeny()
                
                return
            }
            
            
            let args:NSDictionary = ["minDate": self.mBudget.minRegionDate,
                                     "maxDate": self.mBudget.maxRegionDate,
                                     "mBudget": self.mBudget,
                                     "dates": self.mBudgetObject.getTransactionsDates()]
            //self.appDelegate.navigateTo(instance: , params: args)
            
            let viewc = ConfigBudgetViewController(nibName: "ConfigureBudgetViewController", bundle: nil)
            viewc.params = args
            
            self.navigationController?.pushViewController(viewc, animated: true)
           
        })
        
   
        let exportCSVAction = UIAlertAction(title: NSLocalizedString("actionSheetExportCSV", comment: "Export CSV, MS Excel, PDF"), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            let mViewController = ExportBudgetToFile()
            
            //let args:NSDictionary = ["mBudgetObject": self.mBudgetObject]
            mViewController.mBudgetObject = self.mBudgetObject
            self.navigationController?.pushViewController(mViewController, animated: true)
            //self.appDelegate.navigateTo(instance: mViewController)
            

        })
        
        let importCSVAction = UIAlertAction(title: NSLocalizedString("impcsv_vc_title", comment: "Import a CSV File"), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
          
           
            self.navigationController?.pushViewController(ImportCSVController(), animated: true)
            
            
        })

        let dayBookAction = UIAlertAction(title: NSLocalizedString("actionSheetViewDayBook", comment: "View Day Book"), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.navigationController?.pushViewController(DayBookViewController(nibName: "DayBookViewController", bundle: nil), animated: true)
           
        })
        
        let graphicAction = UIAlertAction(title: NSLocalizedString("actionSheetVisualizeOnCharts", comment: "Visualize on Charts"), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            self.appDelegate.budgetObject = self.mBudgetObject
            //self.navigationController?.pushViewController(ReportsTabsViewController(), animated: true)
            self.navigationController?.pushViewController(BudgetReportViewController(), animated: true)
            //self.appDelegate.navigateTo(instance: ReportsTabsViewController())
            
            

        })

        // 2
        let deleteAction = UIAlertAction(title: NSLocalizedString("actionSheetDelete", comment: "Delete"), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            if self.mBudget.owner! != self.pref.getUserIdentifier() {
                
                self.displayDeny()
                
                return
            }

            
            let alertController = UIAlertController(title: NSLocalizedString("alertConfirmDelete", comment: "Confirm delete..."),
                message: NSLocalizedString("alertConfirmDeleteBody", comment: "Confirm delete body"), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("alertConfirmDeleteContinue", comment: "Continue"), style: .destructive) { action in
                // perhaps use action.title here
                self.deleteCurrentBudget()
            })
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("alertConfirmDeleteCancel", comment: "Cancel"), style: .cancel) { action in
                // perhaps use action.title here
            })
            
            self.present(alertController, animated: true) {}
            
            
        })
    
        
        //
        let cancelAction = UIAlertAction(title: NSLocalizedString("actionSheetCancel", comment: "Cancel"), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // 4
        if flavor.getFlavor() == FlavorType.legacy {
            //optionMenu.addAction(contributorAction)
        }
        optionMenu.addAction(duplicateAction)
        optionMenu.addAction(configureAction)
        optionMenu.addAction(exportCSVAction)
        // optionMenu.addAction(importCSVAction)
        optionMenu.addAction(dayBookAction)
        optionMenu.addAction(graphicAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            let popPresenter: UIPopoverPresentationController =  optionMenu.popoverPresentationController!
            popPresenter.sourceView = self.view
            popPresenter.sourceRect = CGRect(x: self.view.frame.width - 150, y: self.view.frame.height - 40, width: 150, height: 50)
        }
        
        
        self.present(optionMenu, animated: true, completion: nil)
       
    }

    @objc func inviteUser(_ sender: UIBarButtonItem) {
        
        let args:NSDictionary = ["mBudgetName": IsmUtils.makeTitleFor(budget: self.mBudget),
                                 "mBudget": self.mBudget]
        let viewc = ContributorsListViewController()
        viewc.params = args
        
        self.navigationController?.pushViewController(viewc, animated: true)
       
        
    }
    
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let budgetSection: BudgetSection = budgetSections[indexPath.row]
        
       
        if editingStyle == .delete {
            
            self.deleteBudgetSection(budgetSection: budgetSection)
            budgetSections.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            

        } else if editingStyle == .insert {
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func deleteBudgetSection(budgetSection:BudgetSection) {
    
        switch budgetSection.type {
        case RowType.income:
            self.deleteIncome(incomeGid: budgetSection.gid)
            
            break
            
        case RowType.category:
            
            self.deleteCategory(categoryGid: budgetSection.gid)
            
            break
        default:
            break
        }
    }
    
    func deleteIncome(incomeGid: String){
        
        let fbIncome = FbIncome(reference: self.firebaseRef)
        let income = mBudgetObject.getIncome(incomeGid: incomeGid)
        
        if income.gid! != "" {
            
            fbIncome.delete(income)
            
        }

    
    }
    
    func deleteCategory(categoryGid: String) {
        
        let fbCategory:FbCategory = FbCategory(reference: self.firebaseRef)
        let categoryObject = mBudgetObject.getCategory(categoryGid: categoryGid)
        
        fbCategory.delete(categoryObject.getCategory())
        self.deleteExpenses(expenses: categoryObject.getExpenses())

    
    }
    
    func deleteExpenses(expenses: [Expense]){
    
        let fbExpense:FbExpense = FbExpense(reference: self.firebaseRef)
    
            
        for expense in expenses {
        
            fbExpense.delete(expense)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        let budgetSection: BudgetSection = budgetSections[indexPath.row]
        return (budgetSection.type == RowType.category || budgetSection.type == RowType.income)
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let budgetSection: BudgetSection = budgetSections[indexPath.row]
        
        
        if budgetSection.type == RowType.category {
            
            let params:NSDictionary = ["minDate": Date(timeIntervalSince1970: Double(self.mBudget.start_date)),
                                       "maxDate": Date(timeIntervalSince1970: Double(self.mBudget.end_date)),
                                       "categoryGid": budgetSection.gid]
            
            let viewc = CategoryDetailsViewController()
            viewc.params = params
            self.present(UINavigationController(rootViewController: viewc), animated: true)
            //self.navigationController?.pushViewController(viewc, animated: true)
            
           
        }
        
        if budgetSection.type == RowType.income {
            let income = self.mBudgetObject.incomesDict[budgetSection.gid]
            let params:NSDictionary = ["minDate": Date(timeIntervalSince1970: Double(self.mBudget.start_date)),
                                       "maxDate": Date(timeIntervalSince1970: Double(self.mBudget.end_date)),
                                       "income": income?.toAnyObject()]
            
            let viewc = NewIncomeViewController()
            viewc.params = params
            viewc.budgetGid = self.mBudget.gid
            viewc.allowOutOfRange = self.mBudget.allowOutRange
            //self.navigationController?.pushViewController(viewc, animated: true)
            self.present(UINavigationController(rootViewController: viewc), animated: true)
        }
        
        
    }
    
    //new expense
    func newExpense() {
        
        let params:NSDictionary = ["minDate": Date(timeIntervalSince1970: Double(self.mBudget.start_date)),
                                   "maxDate": Date(timeIntervalSince1970: Double(self.mBudget.end_date))]
        //appDelegate.navigateTo(instance: NewExpenseViewController(), params: params)
        let newExpense = NewExpenseViewController()
        newExpense.params = params
        newExpense.allowOutOfRange = mBudget.allowOutRange
        newExpense.budgetGid = mBudget.gid
        self.present(UINavigationController(rootViewController: newExpense), animated: true)
        //self.navigationController?.pushViewController(newExpense, animated: true)
        
    }
    
    // new Income
    func newIncome() {
        let params:NSDictionary = ["minDate": Date(timeIntervalSince1970: Double(self.mBudget.start_date)),
                                   "maxDate": Date(timeIntervalSince1970: Double(self.mBudget.end_date))]
        //appDelegate.navigateTo(instance: NewIncomeViewController(), params: params)
        let newIncome = NewIncomeViewController()
        newIncome.params = params
        newIncome.budgetGid = self.mBudget.gid
        newIncome.allowOutOfRange = self.mBudget.allowOutRange
        //self.navigationController?.pushViewController(newIncome, animated: true)
        self.present(UINavigationController(rootViewController: newIncome), animated: true)
    }

    
    // new category
    func newCategory() {
        
        let params:NSDictionary = ["minDate": Date(timeIntervalSince1970: Double(self.mBudget.start_date)),
                                   "maxDate": Date(timeIntervalSince1970: Double(self.mBudget.end_date))]
        
        let newCat = NewCategoryViewController()
        newCat.params = params
        //self.navigationController?.pushViewController(newCat, animated: true)
        self.present(UINavigationController(rootViewController: newCat), animated: true)
    
    }
    
    
    
    func exportCSVToRmail() {
    // code here
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["armel@digitleaf.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            present(mail, animated: true)
            
        } else {
            // show failure alert
            self.present(ConfirmModal.getModal(title: "Error",
                                               message: "Can't sent email",
                                               okText: "OK"),
                         animated: true,
                         completion: nil)
        }
    
    
    }

    func displayDeny(){
        
        let alertController = UIAlertController(title: NSLocalizedString("shareDenied", comment: "Action denied"), message: NSLocalizedString("shareDeniedText", comment: "Share denied text"), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // perhaps use action.title here
        })
        
        self.present(alertController, animated: true) {}
    }
    
    func displayUpgrade() {
        IsmUtils.promtForPro(navContoller: self, featureName: NSLocalizedString("txtProfeature1", comment: ""))
    }
    

    
    func unreadBudget() {
        
        let fbBudget = FbBudget(reference: self.firebaseRef);
        listnerForUnread = fbBudget.getUnreadBudget(userGid: self.pref.getUserIdentifier(), completed: { (userOwn) in
            
            if userOwn.status == -1 {
                self.mapNewBudgets[userOwn.gid] = nil
            }else {
                self.mapNewBudgets[userOwn.gid] = userOwn
            }
            
            self.renderBudgetNotifications()
            
        }, not_found: { (error) in
            
        })
    }
    
    func renderBudgetNotifications() {
        
        var userOwnBudgets:[UserOwnBudget] = []
        
        for (_, value) in self.mapNewBudgets {
            userOwnBudgets.append(value)
        }
        
        if userOwnBudgets.count > 0 {
            newBudgetAvailableView.isHidden = false
        } else {
            newBudgetAvailableView.isHidden = true
        }
    }
    

    func canUserCreateBudget() {
        
        let pref = AccessPref()
    
        if pref.isProAccount() {
            let args:NSDictionary = ["mBudgetObject": self.mBudgetObject]
            
            let viewc = CloneBudgetViewController(nibName: "CloneBudgetViewController", bundle: nil)
            viewc.params = args
            self.navigationController?.pushViewController(viewc, animated: true)
        } else{
            
            let fbRef = appDelegate.firestoreRef
            let fbBudget = FbBudget(reference: fbRef!)
            fbBudget.getUserBudgets(user_gid: self.pref.getUserIdentifier(), onBudgetRead: { (userOwnsBudgets) in

                if userOwnsBudgets.count > 1 {
                    IsmUtils.promtForPro(navContoller: self, featureName: NSLocalizedString("textGoPro", comment: "Unlimitted budget") )
                }else{
                    let args:NSDictionary = ["mBudgetObject": self.mBudgetObject]
                    
                    let viewc = CloneBudgetViewController(nibName: "CloneBudgetViewController", bundle: nil)
                    viewc.params = args
                    self.navigationController?.pushViewController(viewc, animated: true)
                }
                
            })
        }
        
        
    }

    
}

