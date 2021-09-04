//
//  BudgetsTableViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/21/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet
import FirebaseFirestore
import TinyConstraints
import ISMLBase
import ISMLDataService
import CoreData

class BudgetsTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    
    static var viewIdentifier:String = "BudgetsTableViewController"
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(cancel(_:)))
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let sv = UISegmentedControl(items: [
            NSLocalizedString("budgetListActive", comment: "Active Only"),
            NSLocalizedString("budgetListArchive", comment: "Archived")
        ])
        sv.height(36)
        sv.selectedSegmentIndex = 0
        sv.addTarget(self, action: #selector(controlChanged(_:)), for: .valueChanged)

        return sv
    }()
    
    lazy var selectBudgetHeader: HeaderLevelFour = {
        var label = HeaderLevelFour()
        label.text = NSLocalizedString("titleChooseBudget", comment: "")
        return label
    }()
    
    lazy var closeButton: IsmBtnBoxClose = {
        var btn = IsmBtnBoxClose()
        btn.addTarget(self, action: #selector(closepage), for: .touchUpInside)
        return btn
    }()
    
    lazy var headerWapper:UIView = {
        let vw = UIView()
        vw.backgroundColor = .clear
        vw.height(50)
        vw.addSubview(selectBudgetHeader)
        selectBudgetHeader.leftToSuperview(offset: 20)
        selectBudgetHeader.centerYToSuperview()
        
        vw.addSubview(closeButton)
        closeButton.rightToSuperview(offset: -10)
        closeButton.centerYToSuperview()
        return vw
    }()
    
    
    lazy var viewWraper:UIView = {
        let vw = UIView()
        return vw
    }()
    
    var mStatus = 1
    
    var listenerBudget:ListenerRegistration!
    

    var firestoreRef:Firestore!
    var pref: MyPreferences!
    
    var mBudgets:[UserOwnBudget] = []
    var allBudgets:[String:UserOwnBudget] = [:]
    
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    var container: NSPersistentContainer!
    
    var canDismissThis = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.pref = MyPreferences()
        
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        self.firestoreRef = appDelegate.firestoreRef
        
        self.setUpActivity()
        self.layoutComponent()
        
        if(canDismissThis) {
            segmentControl.isHidden = true
            headerWapper.isHidden = false
        }else{
            segmentControl.isHidden = false
            headerWapper.isHidden = true
        }

    }
    func setUpActivity() {
        
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.title = NSLocalizedString("budgetListTitle", comment: "My budgets")
        self.firestoreRef = appDelegate.firestoreRef
        self.pref = MyPreferences()
        
        self.navigationItem.leftBarButtonItem  = cancelButton

    }
    
    func layoutComponent() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.separatorColor = UIColor(named: "seperatorColor")
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.clear

        self.tableView.register(BudgetRowTableViewCell.self, forCellReuseIdentifier: "budgetRowTableViewCell")
    
        
        self.view.addSubview(headerWapper)
        headerWapper.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        self.view.addSubview(segmentControl)
        segmentControl.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        
        self.view.addSubview(tableView)
        tableView.edgesToSuperview(insets: .top(36), usingSafeArea: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadBudgets()
    }
    override func viewWillDisappear(_ animated: Bool) {
       
        if listenerBudget != nil {
            listenerBudget.remove()
        }
    }
    
    @objc func controlChanged(_ sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.mStatus = 1
        case 1:
            self.mStatus = 2
        default:
            break
        }
        
        self.renderList()
    }
    
    func loadBudgets() {
        self.mBudgets.removeAll()
        self.allBudgets.removeAll()
        let fbBudget = FbBudget(reference: firestoreRef)
        listenerBudget = fbBudget.getUserBudgetsSync(user_gid: pref.getUserIdentifier(), onBudgetRead: {userOwnBUdget in
            
            if userOwnBUdget.status == -1 {
                
                self.allBudgets[userOwnBUdget.gid] = nil
                
                self.renderList()
                
            }else{
                self.allBudgets[userOwnBUdget.gid] = userOwnBUdget
                self.renderList()
            }
            
        }, error_message: {error in
            print(error)
        })

        
    }
    
    func renderList() {
        
        
        self.mBudgets.removeAll()
        for (key, budgetOwn) in self.allBudgets {
            if self.mStatus == budgetOwn.active {
                self.mBudgets.append(budgetOwn)
            }
            
        }
        
        self.mBudgets = self.mBudgets.sorted(by: { $1.start_date<$0.start_date})
        self.tableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.mBudgets.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let budget:UserOwnBudget = mBudgets[indexPath.row]
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "budgetRowTableViewCell", for: indexPath) as! BudgetRowTableViewCell
        
        if budget.unread {
            drawerCell.textTitle.text = "\(IsmUtils.makeTitleFor(user_own: budget)) (\(NSLocalizedString("text_new", comment: "New")))"
            drawerCell.textTitle.textColor = Const.BLUE
        }else {
            drawerCell.textTitle.text = "\(IsmUtils.makeTitleFor(user_own: budget))"
        }
        
        if budget.active == 1 {
            drawerCell.textStatus.text = NSLocalizedString("budgetsActive", comment: "Active only")
        } else {
            drawerCell.textStatus.text = NSLocalizedString("budgetsArchived", comment: "Archived")
       
        }
        
       
        if budget.owner == self.pref.getUserIdentifier() {
            
            drawerCell.txtOwner.text = NSLocalizedString("budgetsOwnerMe", comment: "Owner: me")
        }else {
         
            drawerCell.txtOwner.text = NSLocalizedString("budgetsOwner", comment: "Owner: ")
            //budget.userGid
        }
       
        
        
        return drawerCell
    }
 
    func displayDeny(){
        
        let alertController = UIAlertController(
            title: NSLocalizedString("budgetDeleteDeny", comment: "Action denied"),
            message: NSLocalizedString("budgetDeleteDenyBody", comment: "Only the owner can make this action."),
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // perhaps use action.title here
        })
        
        self.present(alertController, animated: true) {}
    }
    
    func archive(index: Int) {
        
        if mBudgets[index].owner != self.pref.getUserIdentifier() {
            self.displayDeny()
            
            return
        }
        
        var indexPath = IndexPath(row: index, section: 0)
        let fbBudget = FbBudget(reference: self.firestoreRef)
        fbBudget.updateActive(mBudgets[indexPath.row].gid, value: 2)
        
        mBudgets.remove(at: indexPath.row)
        //tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
        
    }
    
    func unArchive(index: Int) {
        
        if mBudgets[index].owner != self.pref.getUserIdentifier() {
            self.displayDeny()
            
            return
        }
        
        var indexPath = IndexPath(row: index, section: 0)
        let fbBudget = FbBudget(reference: self.firestoreRef)
        fbBudget.updateActive(mBudgets[indexPath.row].gid, value: 1)
        mBudgets.remove(at: indexPath.row)
        //tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
    
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
        let budget:UserOwnBudget = mBudgets[indexPath.row]
        
        let archive = UITableViewRowAction(style: .normal, title: NSLocalizedString("budgetsArchive", comment: "Archive")) { action, index in
           
            
            if budget.active == 1 {
                self.archive(index: indexPath.row)
            } else {
                self.unArchive(index: indexPath.row)
            }
            
            //self.appDelegate.setLastThreeBudgets(lastThree: [])
        }
        
        if budget.active != 1 {
            archive.title = NSLocalizedString("budgetsUnarchive", comment: "Unarchive")
        }
        archive.backgroundColor = .blue
     
        let delete = UITableViewRowAction(style: .normal,
                                          title: NSLocalizedString("budgetsDelete", comment: "Delete")) { action, index in
          
            
        }
        
        delete.backgroundColor = .red
     
        //return [archive, delete]
        return [archive]
     }

    
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            //mBudgets.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            //tableView.reloadRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        let pref = MyPreferences()
        
        let userOwnBudget = mBudgets[(indexPath.row)]

        pref.setSelectedMonthlyBudget(userOwnBudget.budgetGid)
        RecentBudgetsHelper.insertBudget(viewContext: self.container.viewContext, forId: userOwnBudget.budgetGid, andName: IsmUtils.makeTitleFor(user_own: userOwnBudget))
        appDelegate.navigateTo(instance: ViewController())
        
        if canDismissThis{
            self.dismiss(animated: true)
        }
    }
    @objc func cancel(_ sender: UIBarButtonItem) {
        
        appDelegate.navigateTo(instance: ViewController())
    }
  
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        var str = NSLocalizedString("budgetsNoBudgetFound", comment: "No budget found.")
        if mStatus != 1 {
            str = NSLocalizedString("budgetsNoBudgetArchive", comment: "No budget in the archive")
        }
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        var str = NSLocalizedString("budgetsNoActiveBudget", comment: "No active budget has been found...")
        if mStatus != 1 {
            str = NSLocalizedString("budgetsNoArchivedBudget", comment: "No budget has been found in your archive...")
        }
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "empty_screen")
    }
    
    @objc func closepage() {
        dismiss(animated: true)
    }
}
