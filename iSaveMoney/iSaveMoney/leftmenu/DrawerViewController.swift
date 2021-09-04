//
//  DrawerViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 6/8/16.
//  Copyright © 2016 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn
import MMDrawerController
import ISMLBase
import ISMLDataService
import FirebaseDatabase
import FirebaseAuth
import CoreData
import CheckoutModule
//import CollabModule

class DrawerViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, OnCreateBudget, OnUpgrade {
   
    var tableView: UITableView!
    var menuItems:[DrawerItem]!
    var mainMenu:[DrawerItem] = []
    var userMenu:[DrawerItem]!
    var isAnonymousUser:Bool = true
    var isUserProfileOpen:Bool = false
    var ref: DatabaseReference!
    var firestoreRef:Firestore!
    var pref: MyPreferences!
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    var container: NSPersistentContainer!
    
    static var viewIdentifier:String = "DrawerViewController"
    
    public override func getTag() -> String {
        
        return "DrawerViewController"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "navDrawerBgColor")
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.container = appDelegate.persistentContainer
        flavor = Flavor()
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
    
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: "headerTableViewCell")
        tableView.register(ItemMenuTableViewCell.self, forCellReuseIdentifier: "itemMenuTableViewCell")
        tableView.register(SeparatorTableViewCell.self, forCellReuseIdentifier: "separatorTableViewCell")
        tableView.register(NewBudgetTableViewCell.self, forCellReuseIdentifier: "newBudgetTableViewCell")
        tableView.register(UpgradeTableViewCell.self, forCellReuseIdentifier: "upgradeTableViewCell")
        
        
        
        self.view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: true)
    
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 22).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        
        self.navigationController!.navigationBar.isTranslucent = false
        
        self.firestoreRef = appDelegate.firestoreRef
        self.pref = MyPreferences()

        self.loadMenu()

        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        // Do any additional setup after loading the view.
        
    }
    
    func loadMenu() {
        
        self.pref = MyPreferences()
        mainMenu = []
        mainMenu.append(DrawerItem(id: 0, type: DrawerNav.type_MAIN, title: NSLocalizedString("drawerMyAccount", comment: "My account"), itemIcon: nil)!)
        
        mainMenu.append(DrawerItem(id: 1, type: DrawerNav.type_NEW_BUDGET, title: NSLocalizedString("drawerCreateBudget", comment: "Create a budget"), itemIcon: UIImage(named: "new"))!)
        let budgetList:[RecentBudgets] = RecentBudgetsHelper.getLastThree(viewContext: self.container.viewContext)
        
        var index = 2
        for budget in budgetList {
            print("Add to drawer \(budget.budgetName!)  \(budget.insertTime)")
            if budget.budgetId! != self.pref.getSelectedMonthlyBudget(){
                let drawerItem = DrawerItem(id: (index), type: DrawerNav.type_MONTH, title: "month", itemIcon: UIImage(named: "date_range"))
                drawerItem?.gid = budget.budgetId!
                drawerItem?.title = budget.budgetName!
                self.mainMenu.insert(drawerItem!, at: index)
                
                index = index + 1
            }
        }
        
        mainMenu.append(DrawerItem(id: 4, type: DrawerNav.type_OTHER_MONTH, title: NSLocalizedString("drawerOtherMonths", comment: "Other Months"), itemIcon: UIImage(named: "apps"),sep: true)!)
        
        
        mainMenu.append(DrawerItem(id: 6, type: DrawerNav.type_SEPARATOR, title: NSLocalizedString("myActivities", comment: "My activities"), itemIcon: nil)!)
        mainMenu.append(DrawerItem(id: 11, type: DrawerNav.type_RECURRING, title: NSLocalizedString("drawerRecurringTransactions", comment: "Recurring transactions"), itemIcon: UIImage(named: "repeat"))!)
        mainMenu.append(DrawerItem(id: 5, type: DrawerNav.type_MY_TRANSACTIONS, title: NSLocalizedString("myTransactions", comment: "My transaction"), itemIcon: UIImage(named: "ic_transactions"),sep: false)!)
        
        mainMenu.append(DrawerItem(id: 5, type: DrawerNav.type_ANALYTICS, title: NSLocalizedString("dataAnalytics", comment: "Analytics"), itemIcon: UIImage(named: "ic_analytics"),sep: false)!)
        
        mainMenu.append(DrawerItem(id: 6, type: DrawerNav.type_SEPARATOR, title: NSLocalizedString("drawerTitleAccounts", comment: "Account"), itemIcon: nil)!)
        mainMenu.append(DrawerItem(id: 7, type: DrawerNav.type_ACCOUNTS, title: NSLocalizedString("drawerAccounts", comment: "Accounts"), itemIcon: UIImage(named: "account"))!)
        mainMenu.append(DrawerItem(id: 8, type: DrawerNav.type_PAYEES, title: NSLocalizedString("drawerPayees", comment: "Payees"), itemIcon: UIImage(named: "receipt"))!)
        mainMenu.append(DrawerItem(id: 9, type: DrawerNav.type_PAYERS, title: NSLocalizedString("drawerPayers", comment: "Payers"), itemIcon: UIImage(named: "monetization"),sep: false)!)
        mainMenu.append(DrawerItem(id: 10, type: DrawerNav.type_SEPARATOR, title: NSLocalizedString("drawerTitleSettings", comment: "Settings"), itemIcon: nil)!)
       
        mainMenu.append(DrawerItem(id: 12, type: DrawerNav.type_SETTINGS, title: NSLocalizedString("drawerToolsSettings", comment: "Tools & Settings"), itemIcon: UIImage(named: "settings"))!)
        mainMenu.append(DrawerItem(id: 13, type: DrawerNav.type_HELP, title: NSLocalizedString("drawerHelpFeedback", comment: "Help & Feedback"), itemIcon: UIImage(named: "help"),sep: false)!)
       // mainMenu.append(DrawerItem(id: 14, type: DrawerNav.type_LABELS, title: "Labels", itemIcon: UIImage(named: "help"))!)
        print("Reload for pro")
        let pref = AccessPref()
        
        if !pref.isProAccount() {
            mainMenu.append(DrawerItem(id: 14, type: DrawerNav.type_UPGRADE, title: NSLocalizedString("drawerUpgrade", comment: "Upgrade to PRO"), itemIcon: UIImage(named: "upgrade"))!)
        }
        
        
        userMenu = [
            DrawerItem(id: 1, type: DrawerNav.type_MAIN, title: NSLocalizedString("drawerYourAccount", comment: "Your account"), itemIcon: nil)!,
            DrawerItem(id: 2, type: DrawerNav.type_USER_ACCOUNT, title: NSLocalizedString("drawerYourAccount", comment: "Your account"), itemIcon: UIImage(named: "ic_account_circle"))!,
            DrawerItem(id: 3, type: DrawerNav.type_LOGOUT, title: NSLocalizedString("drawerLogout", comment: "Logout"), itemIcon: UIImage(named: "ic_exit"),sep: false)!,
            //DrawerItem(id: 4, type: DrawerNav.type_USER_GROUPS, title: NSLocalizedString("groupMangement", comment: "Groups"), itemIcon: UIImage(named: "user_group"),sep: false)!,
        ]
        
        menuItems = mainMenu
        
        tableView.reloadData()
    }
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return menuItems.count
    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        
        if indexPath.row == 0 {
           
            return 140.0
            
        } else{
          
            return 44.0
            
        }
        
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if indexPath.row==0 {
            if isAnonymousUser {
                let drawerCellHeader = tableView.dequeueReusableCell(withIdentifier: "headerTableViewCell", for: indexPath) as! HeaderTableViewCell
                drawerCellHeader.textEmail.text = menuItems[indexPath.row].title
                return drawerCellHeader
               
            } else {
                 let drawerCellHeader = tableView.dequeueReusableCell(withIdentifier: "headerTableViewCell", for: indexPath) as! HeaderTableViewCell
                 let pref:MyPreferences = MyPreferences()
                 drawerCellHeader.textEmail.text = pref.getUserEmail() //"tech.imsgo@gmail.com"//
                 if isUserProfileOpen {
                     
                     drawerCellHeader.imgIndicator.image =  drawerCellHeader.dropUpImage// UIImage(named: "ic_dropup")
                     
                 } else {
                     
                     drawerCellHeader.imgIndicator.image = drawerCellHeader.dropDownImage//UIImage(named: "ic_dropdown")
                 }
                 return drawerCellHeader
            }
           
        } else {
            
            let action = menuItems[indexPath.row].type
            if action == DrawerNav.type_SEPARATOR {
                
                let drawerCell = tableView.dequeueReusableCell(withIdentifier: "separatorTableViewCell", for: indexPath) as! SeparatorTableViewCell
                
                drawerCell.textTitle.text = menuItems[indexPath.row].title
                
                return drawerCell
            } else if action == DrawerNav.type_NEW_BUDGET {
                
                let drawerCell = tableView.dequeueReusableCell(withIdentifier: "newBudgetTableViewCell", for: indexPath) as! NewBudgetTableViewCell
                
                drawerCell.buttonNewButton.setTitle(menuItems[indexPath.row].title, for: .normal)
                drawerCell.delegate = self
                //drawerCell.leftIcon.image = drawerCell.leftIcon.image!.withRenderingMode(.alwaysTemplate)
                
                return drawerCell
                
            } else if action == DrawerNav.type_UPGRADE {
                let drawerCell = tableView.dequeueReusableCell(withIdentifier: "upgradeTableViewCell", for: indexPath) as! UpgradeTableViewCell
                //drawerCell.textTitle.text = menuItems[indexPath.row].title
                drawerCell.delegate = self
                return drawerCell
            } else {
                
                let drawerCell = tableView.dequeueReusableCell(withIdentifier: "itemMenuTableViewCell", for: indexPath) as! ItemMenuTableViewCell
                drawerCell.textTitle.text = menuItems[indexPath.row].title
                if (menuItems[indexPath.row].itemIcon != nil) {
                    
                    drawerCell.leftIcon.image = menuItems[indexPath.row].itemIcon
                    drawerCell.leftIcon.image = drawerCell.leftIcon.image!.withRenderingMode(.alwaysTemplate)
                    drawerCell.leftIcon.tintColor = UIColor(named: "tintIconsColor")
                  
                }
                    
                if(menuItems[indexPath.row].hasSeparator == false){
                    drawerCell.separator_1.isHidden = true
                }else{
                    drawerCell.separator_1.isHidden = false
                }
                return drawerCell
            }
        }
    }
    
    func getMatchBudget(budgetGid:String, lastOpened:[UserOwnBudget]) -> UserOwnBudget {
        
        
        for ownBudget in lastOpened {
            if ownBudget.gid == budgetGid {
                return ownBudget
            }
        }
        
        return UserOwnBudget(dataMap: [:])
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let action = menuItems[indexPath.row].type
        
        switch(action)
        {
            
        case DrawerNav.type_MAIN:
            
            if isAnonymousUser {
                
                
                
                appDelegate.toggleDrawerNav()
            
                self.appDelegate.navigateTo(instance: SignInViewController()) 
            } else {
                
                if self.isUserProfileOpen {
                
                    menuItems = mainMenu
                    self.isUserProfileOpen = false
                } else {
                
                    menuItems = userMenu
                    self.isUserProfileOpen = true
                }
                
                tableView.reloadData()
            
            }
            
            
            break
            
        case DrawerNav.type_NEW_BUDGET:
           
            gotoNewBudget()
            

            break
            
        case DrawerNav.type_LOGOUT:
            
            signOut()
            
        
            
            //appDelegate.stopListners()
            appDelegate.toggleDrawerNav()
            break
            
        case DrawerNav.type_USER_ACCOUNT:
            
            appDelegate.toggleDrawerNav()
            appDelegate.navigateTo(instance: UserProfileViewController(nibName: "UserProfileViewController", bundle: nil))
            break
            
        case DrawerNav.type_SETTINGS:
            //self.changeViewController(SettingsViewController.viewIdentifier)
            
            
            appDelegate.toggleDrawerNav()
            appDelegate.navigateTo(instance: SettingsViewController())
            break
            
        case DrawerNav.type_HELP:
          
            appDelegate.toggleDrawerNav()
            appDelegate.navigateTo(instance: FeedBackViewController(nibName: "FeedBackViewController", bundle: nil))
            break
            
        case DrawerNav.type_OTHER_MONTH:
            
            appDelegate.toggleDrawerNav()
             
            appDelegate.navigateTo(instance: BudgetsTableViewController())
            break
            
        case DrawerNav.type_MONTH:
            
            
            //appDelegate.setLastThreeBudgets(lastThree: [])
            appDelegate.toggleDrawerNav()
            pref.setSelectedMonthlyBudget(menuItems[indexPath.row].gid)
            RecentBudgetsHelper.insertBudget(viewContext: self.container.viewContext, forId: menuItems[indexPath.row].gid, andName: menuItems[indexPath.row].title)
            notifyState()
            appDelegate.navigateTo(instance: ViewController())
            break
            
        case DrawerNav.type_PAYEES:
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.toggleDrawerNav()
            appDelegate.navigateTo(viewcontroller: PayeeViewController())
            
            break
            
        case DrawerNav.type_PAYERS:
            
            appDelegate.toggleDrawerNav()
            appDelegate.navigateTo(instance: PayerViewController())
            break
            
        case DrawerNav.type_ACCOUNTS:
            
            appDelegate.toggleDrawerNav()
            appDelegate.navigateTo(instance: AccountViewController())
            break
            
        case DrawerNav.type_RECURRING:
        
            appDelegate.toggleDrawerNav()
           
            //let vc = GroupsViewController(nibName:"GroupsViewController",bundle: nil)
            let userGroupWc = UINavigationController(rootViewController: RecurringTransactionViewController())
            self.present(userGroupWc, animated: true)
            break
        case DrawerNav.type_UPGRADE:
            
            AppUtility.lockOrientation(.portrait)
            onPressUpgrade()
            //appDelegate.toggleDrawerNav()
            //appDelegate.navigateTo(instance: AppUpgradeViewController())
            
            break
        case DrawerNav.type_LABELS:
           
            appDelegate.toggleDrawerNav()
            appDelegate.navigateTo(instance: LabelsViewController())
            
            break
        case DrawerNav.type_USER_GROUPS:
            appDelegate.toggleDrawerNav()
            let vc = GroupsViewController(nibName:"GroupsViewController",bundle: nil)
            let userGroupWc = UINavigationController(rootViewController: vc)
            self.present(userGroupWc, animated: true)
            break
       
        case DrawerNav.type_MY_TRANSACTIONS:
            appDelegate.toggleDrawerNav()
            let vc = MyTransactionsViewController(nibName:"MyTransactionsViewController",bundle: nil)
            let myTnx = UINavigationController(rootViewController: vc)
            self.present(myTnx, animated: true)
            break
        case DrawerNav.type_ANALYTICS:
            appDelegate.toggleDrawerNav()
            let vc = AnalyticsViewController(nibName:"AnalyticsViewController",bundle: nil)
            let myTnx = UINavigationController(rootViewController: vc)
            self.present(myTnx, animated: true)
            break
        default:
            
            appDelegate.toggleDrawerNav()
            
            
        }
    
    }
    
    
    func signOut() {
        self.pref.setUnlockCode("")
        pref.destroy()
        
        var isGoogleUser = false
        RecentBudgetsHelper.deleteAll(viewContext: self.container.viewContext)
        pref.setSelectedMonthlyBudget("")
        for user in (Auth.auth().currentUser?.providerData)! {
            
            print("\(user.providerID) - \(user.providerID == "google.com")")
            if user.providerID == "google.com" {
                
                isGoogleUser = true
            }
        }
        
        try! Auth.auth().signOut()
        
        if isGoogleUser {
        
            GIDSignIn.sharedInstance()!.signOut()
        }
        
        
    }
    
    func notifyState() {
        
        isUserProfileOpen = false
        loadMenu()
        //menuItems = mainMenu
        //print("Remove Notify")
        //loadRecentsOpened()
        
    }
    
    /*func loadRecentsOpened() {
    
       

        var NewSetmainMenu:[DrawerItem] = []
        for menuItem in self.mainMenu {
            
            if menuItem.type != DrawerNav.type_MONTH {
                NewSetmainMenu.append(menuItem)
               
            }
            
        }
        self.mainMenu = NewSetmainMenu
        
        let budgetList:[RecentBudgets] = RecentBudgetsHelper.getLastThree(viewContext: self.container.viewContext)
        
        var index = 2
        for budget in budgetList {
            print("Add to drawer \(budget.budgetName!)  \(budget.insertTime)")
            if budget.budgetId! != self.pref.getSelectedMonthlyBudget(){
                let drawerItem = DrawerItem(id: (index), type: DrawerNav.type_MONTH, title: "month", itemIcon: UIImage(named: "date_range"))
                drawerItem?.gid = budget.budgetId!
                drawerItem?.title = budget.budgetName!
                self.mainMenu.insert(drawerItem!, at: index)
                
                index = index + 1
            }
        }
        self.reloadDrawerMain()
    
    }*/
    
    
    
    /*func reloadDrawerMain(){
    
    
        self.menuItems = self.mainMenu
        self.tableView.reloadData()
    }*/
    
//    func newMenu() {
//        for menuItem in self.mainMenu {
//
//            logThis(message: menuItem.title)
//
//        }
//    }

    func onPress() {
        gotoNewBudget()
    }
    
    func onPressUpgrade(){
        IsmUtils.promtForPurchase(navContoller: self)
        appDelegate.toggleDrawerNav()
    }
    
    func gotoNewBudget() {
        appDelegate.toggleDrawerNav()
        
        let pref = AccessPref()
        let isPro = pref.isProAccount()
        if(appDelegate.getLastThreeBudgets().count >= Const.NUMBER_FREE_BUDGET
            && !isPro
            && flavor.getFlavor() == FlavorType.legacy) {
            
            IsmUtils.promtForPro(navContoller: self, featureName: NSLocalizedString("textGoPro", comment: "Unlimitted budget") )
            return
        }
        
        canUserCreateBudget()
        //appDelegate.navigateTo(instance: NewMonthlyBudgetViewController(nibName: "NewMonthlyBudgetViewController", bundle: nil))
    }
    
    func canUserCreateBudget() {
        
        let pref = AccessPref()
    
        if pref.isProAccount() {
            self.appDelegate.navigateTo(instance: NewMonthlyBudgetViewController(nibName: "NewMonthlyBudgetViewController", bundle: nil))
        } else{
            
            let fbRef = appDelegate.firestoreRef
            let fbBudget = FbBudget(reference: fbRef!)
            fbBudget.getUserBudgets(user_gid: self.pref.getUserIdentifier(), onBudgetRead: { (userOwnsBudgets) in

                if userOwnsBudgets.count > 1 {
                    IsmUtils.promtForPro(navContoller: self, featureName: NSLocalizedString("textGoPro", comment: "Unlimitted budget") )
                }else{
                    self.appDelegate.navigateTo(instance: NewMonthlyBudgetViewController(nibName: "NewMonthlyBudgetViewController", bundle: nil))
                }
                
            })
        }
        
        
    }

}
