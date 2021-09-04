//
//  AppDelegate.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 7/4/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
//import RealmSwift
import Firebase
import FirebaseFirestore
import GoogleSignIn
import UserNotifications
import FirebaseDynamicLinks
import CSVImporter
import MMDrawerController
import HelpCenter
//import ISMLDataService
import ISMLDataService
import FirebaseAuth
import ISMLBase
import StoreKit
import CheckoutModule
import CoreData




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    //var window: UIWindow?
    var centerContainer:MMDrawerController?
    var isAnonymousUser:Bool = true
    var drawerViewController:DrawerViewController?
    var centerViewController:BaseViewController?
    
    //var mBudgetCollection:BudgetCollection?
    var mPayeesCollection:PayeesCollection?
    var mPayersCollection:PayersCollection?
    var mAccountsCollection:AccountsCollection?
    
    var mMessageListner:MessageListner?
    let TAG_NAME = "AppDelegate"
    
    var mCategorySuggestion:[String: CategorySuggestion] = [:]
    var mIncomeSuggestion:[String: CategorySuggestion] = [:]
    
    var mainStoryboard:UIStoryboard?
    
    var orientationLock = UIInterfaceOrientationMask.all
    var lastThreeBudgets:[UserOwnBudget] = []
    var budgetCategories:[BudgetCategory] = []
    
    var selectedBudgetGid:String!
    var budgetObject:BudgetObject!
    var pref:MyPreferences!
 
    var firestoreRef:Firestore!
    
    var budgetEditors: [String: BudgetEditor] = [:]
    
    var mMigratingTheUserData = false
    public var isPinActive = true
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iSaveMomeyCache")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func getDrawerController() -> MMDrawerController {
        return centerContainer!
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        pref = MyPreferences()
        FirebaseApp.configure()
        Utils.Log(tag: TAG_NAME, message: "application::didFinishLaunchingWithOptions")
        
        
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        // Enable offline data persistence
        firestoreRef = Firestore.firestore()
        firestoreRef.settings = settings

        
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        SetupPushNotification(application: application)
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.backgroundColor = UIColor(named: "primaryColor")
        navigationBarAppearace.tintColor = UIColor(named: "pageHeaderColor")
        //navigationBarAppearace
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "pageHeaderColor")]
        
        SKPaymentQueue.default().add(StoreObserver.shared)
        
        validateLicence()
        buildUserCloseCircle()
       
        return true
    }
    
    func validateLicence() {
        let pref = AccessPref()
        
        let userId = pref.getStringVal(forKey: AccessPref.PREF_USER_IDENTIFIER, defVal: "")
        print("Check user order \(userId)")
        ValidatePuchase.validate(callback: {data in
            print("User is Pro Notify drawer")
            
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate
                else {
                  return
                }
                
                sceneDelegate.notifyDrawer()

            }
            
           
           
        })
    }
    
    func buildUserCloseCircle() {
        
        
        self.budgetEditors = [:]
        
        let pref = AccessPref()
        let userId = pref.getStringVal(forKey: AccessPref.PREF_USER_IDENTIFIER, defVal: "")
        if userId == "" {
            return
        }
        
        let fbBudget:FbBudget = FbBudget(reference: self.firestoreRef)
        
        fbBudget.getUserBudgets(user_gid: self.pref.getUserIdentifier(), onBudgetRead: { userOwns in
            for userOwn in userOwns {
                fbBudget.getBudgetEditors(budget_gid: userOwn.budgetGid, completed: { editorList in
                    self.budgetEditors[editorList.userGid] = editorList
                }, not_found: { err in
                    print(err)
                })
            }
        })
    }
    
    func getUserCircle() -> [BudgetEditor] {
        var budgetEditors: [BudgetEditor] = []
        
        for (_, editor) in self.budgetEditors {
            if editor.userGid != self.pref.getUserIdentifier() {
                budgetEditors.append(editor)
            }
            
        }
        
        return budgetEditors
    }
    //@available(iOS 10.0, *)
    func SetupPushNotification(application: UIApplication) -> () {
        
        let notifCenter = UNUserNotificationCenter.current()
       
        notifCenter.requestAuthorization(options: [.alert,.sound,.badge], completionHandler:{(granted, error) in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
            
        })
        
        let content = UNMutableNotificationContent()
        content.title = "First fire"
        content.body = "Hello my notification is here"
        
        let date = Date().addingTimeInterval(15)
        let dateComponent = Calendar.current.dateComponents([.month, .year, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        _ = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        /*notifCenter.add(request, withCompletionHandler: { error in
            
        })*/
    }
    
    func notifyDrawer() {
        drawerViewController?.isAnonymousUser = self.isAnonymousUser
        drawerViewController?.notifyState()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Utils.Log(tag: TAG_NAME, message: "applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Utils.Log(tag: TAG_NAME, message: "applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //self.stopListners();
    }

   
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Utils.Log(tag: TAG_NAME, message: "applicationWillEnterForeground")
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        //startListeners();
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("DidBecomeActive")
         Utils.Log(tag: TAG_NAME, message: "applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        //Utils.Log(tag: TAG_NAME, message: "tryMigrateUser()")
        //tryMigrateUser()
        
        
        if Auth.auth().currentUser != nil {
            
            let oUser = PUser(dataMap: [:])
            oUser.gid = Auth.auth().currentUser?.uid
            self.restorePreferencs(user: oUser, listner: {(prefrences) in
                
                
            })
        }
        

       
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        Utils.Log(tag: TAG_NAME, message: "applicationWillTerminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //stopListners()
        SKPaymentQueue.default().remove(StoreObserver.shared)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Utils.Log(tag: TAG_NAME, message: "Opened dynamic link 3")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            if dynamicLink.url != nil {
                shareBudgetNow(url: dynamicLink.url!)
            }
            
            return true
        }else{
            return false
        }
        
    }

    
    
    func shareBudgetNow(url:URL) {
        
        var budgetGid = ""
        var teamGid = ""
        
        let components = URLComponents(url: url ?? URL(fileURLWithPath: "http://www.digitleaf.com/"), resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            for item in queryItems {
                //dict[item.name] = item.value!
                if item.name == "gid" {
                    budgetGid = item.value!
                }
                if item.name == "team" {
                    teamGid = item.value!
                }
            }
        }
        
        Utils.Log(tag: self.TAG_NAME, message: "Budget gid: \(budgetGid)")
        if budgetGid != "" {
            self.addUserToBudget(budgetGid: budgetGid)
        }
        
        if teamGid != "" {
            self.addUserToTeam(teamId: teamGid)
        }
        
    }
    
    func addUserToBudget(budgetGid:String) {
        
        if budgetGid == "" {
            Utils.Log(tag: self.TAG_NAME, message: "Invalite budget gid: \(budgetGid)")
            return
        }
            
        
        let fbBudget:FbBudget = FbBudget(reference: firestoreRef)
        
        fbBudget.lookUpBudgetForUser(
            bugdet_gid: budgetGid,
            user_gid: self.pref.getUserIdentifier(),
            onBudgetRead: {userOwnBudgets in
                
            if userOwnBudgets.count > 0 {
                Utils.Log(tag: self.TAG_NAME, message: "Budget exists for user just open: \(budgetGid)")
                let userOwnBudget = userOwnBudgets[0]
                self.openLatestBudget(budgetGid: budgetGid)
                var lastThree = self.getLastThreeBudgets()
                if lastThree.count > 0 {
                    lastThree.insert(userOwnBudget, at: 0)
                }else{
                    lastThree.append(userOwnBudget)
                }
                
                if lastThree.count > 3 {
                    lastThree.remove(at: 3)
                }
                
                self.setLastThreeBudgets(lastThree: lastThree)
                self.notifyDrawer()
                self.pref.setSelectedMonthlyBudget(userOwnBudget.budgetGid)
                self.navigateTo(instance: ViewController())
                
            }else{
                Utils.Log(tag: self.TAG_NAME, message: "Record budget for user: \(budgetGid)")
                self.recordBudgetForeUSer(budgetGid: budgetGid)
            }
        })

    }
    
    func addUserToTeam(teamId teamGid: String){
        let fbTeam = FbTeamModel(reference: self.firestoreRef)
        let fbUser = FbUser(reference: self.firestoreRef)
        fbTeam.get(forId: teamGid, listener: { team in
            fbUser.get(userGid: self.pref.getUserIdentifier(), listner: {user in
                let member:TeamMemberModel = TeamMemberModel()
                member.teamID = team.gid
                member.userWithTeamId = "\(String(describing: user.gid))\(String(describing: team.gid))"
                member.fullName = user.email
                member.userEmail = user.email
                member.userId = user.gid
                member.JoiningDate = Int(Date().timeIntervalSince1970)
                member.team = team
                let fbteamMember = FbTeamMember(reference: self.firestoreRef)
                fbteamMember.write(member)
                InviteNotify.teamInviteAccepted(teamName: member.fullName)
            }, error_message: {err in
                
            })
        }, error_message: { err in
            
        })
    }
    
    func recordBudgetForeUSer (budgetGid:String) {
        
        let fbBudget:FbBudget = FbBudget(reference: firestoreRef)
        fbBudget.addEditorToBudget(
            budget_gid: budgetGid,
            user_gid: self.pref.getUserIdentifier(),
            returnSaved: { userOwnBudget in

            self.openLatestBudget(budgetGid: budgetGid)
            var lastThree = self.getLastThreeBudgets()
            if lastThree.count > 0 {
                lastThree.insert(userOwnBudget, at: 0)
            }else{
                lastThree.append(userOwnBudget)
            }

            if lastThree.count > 3 {
                lastThree.remove(at: 3)
            }

            self.setLastThreeBudgets(lastThree: lastThree)
            self.notifyDrawer()
            self.pref.setSelectedMonthlyBudget(userOwnBudget.budgetGid)
            self.navigateTo(instance: ViewController())
        })
    }

    func openLatestBudget(budgetGid:String) {
       
        self.pref.setSelectedMonthlyBudget(budgetGid)
        navigateTo(instance: ViewController())
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        // ...
        if (error) != nil {
            // ...
            return
        }
        
        if Auth.auth().currentUser != nil  && Auth.auth().currentUser?.isAnonymous == false {
        
            return
        
        }
      
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                    
                                                          accessToken: authentication.accessToken)

        
//        if Auth.auth().currentUser != nil {
//
//            Auth.auth().currentUser?.linkAndRetrieveData(with: credential, completion: {(linkedUser, error) in
//                if (error) != nil {
//
//                    Auth.auth().signInAndRetrieveData(with: credential, completion: {(user, error) in
//
//                    })
//                }
//
//            })
//
//
//        } else {
//
//            Auth.auth().signInAndRetrieveData(with: credential, completion: {(user, error) in
//
//            })
//        }
        
    }
    
    

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        Utils.Log(tag: TAG_NAME, message: "sign::didDisconnectWith.user::withError")
        
    }
    
   
    func syncForUser() {
        
        Utils.Log(tag: TAG_NAME, message: "syncForUser")
    
        
        //sync user payer accounts
        mPayersCollection = PayersCollection(reference: firestoreRef)
        mPayersCollection?.startSync()
        //sync user payee accounts
        mPayeesCollection = PayeesCollection(reference: firestoreRef)
        mPayeesCollection?.startSync()
        //Sync user account
        mAccountsCollection = AccountsCollection(reference: firestoreRef)
        mAccountsCollection?.startSync()
        //current budget category
        
        mMessageListner?.startSync(notifier: {(message) in
            self.notifyUser(message: message)
           
        })
        
        self.loadSuggestions()
    }
    
    func restorePreferencs(user:PUser, listner:@escaping ((_ preferences:Preferences)->Void))  {

        
        let fbPreferences = FbPreferences(reference: firestoreRef)
        
        
        fbPreferences.get(user_gid: user.gid, notifier: {(preferences) in
            
            if preferences.gid != nil && preferences.gid! != "" {
                preferences.prefUserIdentifier = user.gid!
                preferences.gid = user.gid!
                
                
                if preferences.dateFormat! == "" {
                    preferences.dateFormat = NSLocalizedString("format_date", comment: "dd/mm/yyyy")
                    fbPreferences.savePref(user_gid: user.gid, key: "dateFormat", value: NSLocalizedString("format_date", comment: "dd/mm/yyyy"))
                }
                
                if preferences.timeFormat! == "" {
                    preferences.timeFormat = NSLocalizedString("format_time", comment: "hh:mm a")
                    fbPreferences.savePref(user_gid: user.gid, key: "timeFormat", value: NSLocalizedString("format_time", comment: "hh:mm a"))
                }
                
                preferences.saveValuesToPreferences(prefs: preferences.toAnyObject())
                listner(preferences)
                self.validateLicence()
                self.buildUserCloseCircle()
            } else {
                
                let preferences = Preferences(value: user.preferences)
                preferences.prefUserIdentifier = user.gid!
                preferences.gid = user.gid!
                preferences.prefUserEmail = user.email
                preferences.dateFormat = NSLocalizedString("format_date", comment: "dd/mm/yyyy")
                preferences.timeFormat = NSLocalizedString("format_time", comment: "hh:mm a")
                
                _ = fbPreferences.write(preferences)
                
                preferences.saveValuesToPreferences(prefs: preferences.toAnyObject())
                listner(preferences)
                self.validateLicence()
                self.buildUserCloseCircle()
            }
        }, errorReturn: {(error) in
            
            let preferences = Preferences(value: user.preferences)
            preferences.prefUserIdentifier = user.gid!
            preferences.gid = user.gid!
            preferences.prefUserEmail = user.email
            preferences.dateFormat = NSLocalizedString("format_date", comment: "dd/mm/yyyy")
            preferences.timeFormat = NSLocalizedString("format_time", comment: "hh:mm a")
            _ = fbPreferences.write(preferences)
            
            preferences.saveValuesToPreferences(prefs: preferences.toAnyObject())
            listner(preferences)
        })
        
       
    }
    
    
    func saveUser(user:PUser) {
        
        let fbUser:FbUser = FbUser(reference: self.firestoreRef)
        
        _ = fbUser.write(user, completion: {(inUser) in
            
            self.restorePreferencs(user: inUser, listner: {(preferences) in
                //self.createAccounts()
                self.logUser(user: user)
                self.navigateToBudgetScreen()
                
                self.notifyDrawer()
                //sync user budget
                self.syncForUser()
                
               
            })
            
        }, error_message: {(message) in
            
            let alert = ConfirmMessage(title: "Error", message: message)
            UIApplication.shared.windows.first?.rootViewController?.present(alert.getAlert(), animated: true, completion: nil)
            
            
        })
    }
    
    func createAccounts() {
        
        let pref:MyPreferences = MyPreferences()
        if pref.getCreatedAccount() {
            return
        }
        
        
        let fbAccount:FbAccount = FbAccount(reference: firestoreRef)
        var account:Account
        
        //credit
        account = Account()
        account.user_gid = pref.getUserIdentifier()
        account.type = 2
        account.name = "Credit"
        account.balance = 0.0
        account.insert_date = Int(Date().timeIntervalSince1970)
        _ = fbAccount.write(account, completion: {(account) in
            
        }, error_message: {(error) in
            print(error)
        })
        
        //credit
        account = Account()
        account.user_gid = pref.getUserIdentifier()
        account.type = 3;
        account.name = "Debit"
        account.balance = 0.0
        account.insert_date = Int(Date().timeIntervalSince1970)
        _ = fbAccount.write(account, completion: {(account) in
            
        }, error_message: {(error) in
            print(error)
        })
        
        //Cash
        account = Account()
        account.user_gid = pref.getUserIdentifier()
        account.type = 4
        account.name = "Cash"
        account.balance = 0.0
        account.insert_date = Int(Date().timeIntervalSince1970)
        _ = fbAccount.write(account, completion: {(account) in
            
        }, error_message: {(error) in
            print(error)
        })
        
        pref.setCreatedAccount(val: true)
        
    }
    func navigateToLogin()  {
        let gPref = GlobalPreferences()
        // Utils.Log(tag: "ShowOnboarding", message: "Onboard \(gPref.hasShowOnboarding())")
        
        if !gPref.hasShowOnboarding() {
            let args:NSDictionary = ["fromscreen": "login"]
            self.navigateTo(instance: HowItWorksViewController(), params: args)
            return
        }
        
        if(pref.getUnlockCode() != "" && pref.getUnlockCode() == Const.SCREEN_LOCK_CODE) {
            
            self.navigateTo(instance: SignInViewController())
            
        } else {
            
            self.navigateTo(instance: SignInViewController())
            
        }
        
    }
    
    func navigateToBudgetScreen()  {
        
        let pref = MyPreferences()
        
        if(pref.getUnlockCode() != "" && pref.getUnlockCode() == Const.SCREEN_LOCK_CODE) {
            Utils.Log(tag: TAG_NAME, message: "navigateToBudgetScreen")
            
            self.navigateTo(instance: ViewController())
        } else {
            
            //self.navigateTo(instance: ScreenLocker())
            self.navigateTo(instance: ViewController())
            
        }
        
      
    }

    
    func navigateTo(instance viewControlerInstance:BaseViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
          return
        }

        viewControlerInstance.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        let viewControllerNavController = UINavigationController(rootViewController: viewControlerInstance)
        sceneDelegate.centerContainer?.centerViewController = viewControllerNavController
        
    }
    
    func toggleDrawerNav() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
          return
        }
        
        sceneDelegate.centerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    
    func navigateTo(instance viewControlerInstance:BaseViewController, params data:NSDictionary) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
          return
        }
        
        viewControlerInstance.params = data
        viewControlerInstance.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        
        let viewControllerNavController = UINavigationController(rootViewController: viewControlerInstance)
        
        sceneDelegate.centerContainer?.centerViewController = viewControllerNavController
    }
    
    func navigateTo(viewcontroller viewControlerInstance: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
          return
        }

        viewControlerInstance.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        let viewControllerNavController = UINavigationController(rootViewController: viewControlerInstance)
        sceneDelegate.centerContainer?.centerViewController = viewControllerNavController
        
    }
    
    func pushViewController(viewcontroller viewControlerInstance: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
          return
        }
        sceneDelegate.centerContainer?.centerViewController.navigationController?.pushViewController(viewControlerInstance, animated: true)
    }
    func navigateTo(navVC navController: UINavigationController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
          return
        }

        sceneDelegate.centerContainer?.centerViewController = navController
        
    }
    
   
    func getPayees() -> [Payee] {
    
        Utils.Log(tag: TAG_NAME, message: "getPayees")
        return (mPayeesCollection?.getPayee())!
    }
    
    func getPayers() -> [Payer] {
        
        Utils.Log(tag: TAG_NAME, message: "getPayers")
        
        return (mPayersCollection?.getPayer())!
    }
    
    func getAccounts() -> [Account] {
        Utils.Log(tag: TAG_NAME, message: "getAccounts")
    
        return (mAccountsCollection?.getAccount())!
    
    }
    
    func notifyUser(message:Message) {
        
        
        if #available(iOS 10.0, *) {
            
            let content = UNMutableNotificationContent()
            
            content.title = message.title
            content.body = message.body
            content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 40, repeats: false)
            
            let request = UNNotificationRequest(identifier: message.gid, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
        
    
    }
    
    func loadSuggestions()  {
        
        mCategorySuggestion = [:]
        mIncomeSuggestion = [:]
        var budgetSections:[BudgetSection] = []
        
        // Load a named file.
        #if ENV_DEV
            var filesList = ["personnal_budget", "family_budget", "household_budget"]
            if(NSLocalizedString("userLang", comment: "lang")=="fr") {
                filesList = ["personnal_budget-fr", "family_budget-fr", "household_budget-fr"]
            }
        #elseif ENV_MM
            let filesList = ["cfp_template"]
        #elseif ENV_PROD
            
            var filesList = ["personnal_budget", "family_budget", "household_budget"]
            if(NSLocalizedString("userLang", comment: "lang")=="fr") {
                filesList = ["personnal_budget-fr", "family_budget-fr", "household_budget-fr"]
            }
        #else
            var filesList = ["personnal_budget", "family_budget", "household_budget"]
            if(NSLocalizedString("userLang", comment: "lang")=="fr") {
                filesList = ["personnal_budget-fr", "family_budget-fr", "household_budget-fr"]
            }
        #endif
        
        for file_name in filesList {
        
        
            budgetSections = BudgetUtil.readTemplateFile(filename: file_name)
            for budgetSection in budgetSections as [BudgetSection] {
                
                if budgetSection.type == RowType.income {
                    
                    let itemSugg = CategorySuggestion()
                    
                    itemSugg.simpleTitle = Utils.CleanText(text: budgetSection.title)
                    itemSugg.title = Utils.trimText(text: budgetSection.title)
                    
                    mIncomeSuggestion[itemSugg.simpleTitle] = itemSugg
                    
                } else {
                    
                    //var cleanKey = Utils.CleanText(text: budgetSection.title)
                    
                    let itemSugg = CategorySuggestion()
                    
                    itemSugg.simpleTitle = Utils.CleanText(text: budgetSection.title)
                    itemSugg.title = Utils.trimText(text: budgetSection.title)
                    
                    for item in budgetSection.items {
                        
                        itemSugg.addItem(name: item)
                    }
                    mCategorySuggestion[itemSugg.simpleTitle] = itemSugg
 
                }
            }
        }
    }
    
    func getCategorieSuggestion() -> [String] {
        
        var suggestion:[String] = []
        
        for (_, value) in self.mCategorySuggestion {
        
        
            suggestion.append(value.title)
        }
        
        suggestion = suggestion.sorted(by: { $0.lowercased() < $1.lowercased() })
        return suggestion
    
    }
    
    func getItemsSuggestion() -> [String] {
        
        var suggestion:[String] = []
        
        for (_, value) in self.mCategorySuggestion {
            
            for (_,item) in value.items {
                suggestion.append(item.title)
            }
            
        }
        
        
        return suggestion
        
    }
    
    func getIncomeSuggestion() -> [String] {
        
        var suggestion:[String] = []
        
        for (_, value) in self.mIncomeSuggestion {
            
            
            suggestion.append(value.title)
        }
        
        
        return suggestion
        
    }
    
    //process the deeplink
    func processInvite(deepLink: String) {
        
        let params:[String:String] = UtilsIsm.getUrlParams(urlLink: deepLink)
      
        
        let fbBudget = FbBudget(reference: firestoreRef)
        
        if params["budget_uid"] != nil && params["budget_uid"]! != "" {
        
            fbBudget.addEditorToBudget(budget_gid: params["budget_uid"]!, user_gid: pref.getUserIdentifier(), returnSaved: { saved in
                
            })
            
        }
    
    }
    
    func notifyLanguageChanged() {
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSLocale.currentLocaleDidChangeNotification,
                       object: nil,
                       queue: OperationQueue.main) {
                        [weak self] notification in
                        guard let `self` = self else { return }
                        
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateInitialViewController()
                        UIApplication.shared.windows.first?.rootViewController = vc
        }
    }
    
    
    func logUser(user:PUser) {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        //Crashlytics.sharedInstance().setUserEmail(user.email)
        //Crashlytics.sharedInstance().setUserIdentifier(user.gid)
        
    }
    
    func setLastThreeBudgets(lastThree:[UserOwnBudget]) {
        
        self.lastThreeBudgets = lastThree
    }
    
    func getLastThreeBudgets() -> [UserOwnBudget] {
        
        return self.lastThreeBudgets
    }
    
    func setCategoriesList(cats:[BudgetCategory]) {
        
        self.budgetCategories = cats
    }
    
    func getCategoriesList() -> [BudgetCategory] {
        
        return self.budgetCategories.sorted(by: { $0.title.lowercased() < $1.title.lowercased() })
    }
    
    
    func startListeners() {
        
        mPayeesCollection?.startSync()
        mPayersCollection?.startSync()
        mAccountsCollection?.startSync()
        
        
        mMessageListner?.startSync(notifier: {(message) in
            self.notifyUser(message: message)
        })
    }

}

