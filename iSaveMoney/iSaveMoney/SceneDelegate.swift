//
//  SceneDelegate.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 7/4/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import SwiftUI
import MMDrawerController
import Firebase
import FirebaseFirestore
import GoogleSignIn
import UserNotifications
import FirebaseDynamicLinks
import FirebaseAuth
import ISMLDataService
import ISMLBase
import StoreKit
import CheckoutModule

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var centerContainer:MMDrawerController?
    var drawerViewController:DrawerViewController?
    var centerViewController:BaseViewController?
    let TAG_NAME = "SceneDelegate"
    var isAnonymousUser:Bool = true
    var appDelegate:AppDelegate!
    var pref:MyPreferences!


    var whenBackgoundtime = 0
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            centerViewController =  HomeViewController(nibName: "HomeViewController", bundle: nil)
            drawerViewController = DrawerViewController()
            drawerViewController?.isAnonymousUser = false
            
            
            let drawerNav = UINavigationController(rootViewController: drawerViewController!)
            let centerNav = UINavigationController(rootViewController: centerViewController!)
            centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: drawerNav)
            centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
            
            window.rootViewController = centerContainer
            
            self.window = window
            window.makeKeyAndVisible()
            listenUserStatus()
            
    
            pref.setUserIdentifier(val: "TnnvWcLYU0N0hG8FtWubRXy50Mh2")
        }
    }
    
    func listenUserStatus(){
     
        Utils.Log(tag: TAG_NAME, message: "listenUserStatus")
        self.pref = MyPreferences()
        
        Utils.Log(tag: TAG_NAME, message: "attempt to migrate the user")
        
        
        _ = Auth.auth().addStateDidChangeListener() { (auth, user) in
            
            
            if user != nil {//if user not nil
                print("Loading User \(user)")
                self.isAnonymousUser = user!.isAnonymous
                
                self.pref.setUserIdentifier(val: (user?.uid)!)
                
                self.notifyDrawer()
                
                let fbUser:FbUser = FbUser(reference: self.appDelegate.firestoreRef)
                
                fbUser.get(userGid: (user?.uid)!, listner: { (oUser) in
                    
                   
                    if oUser.gid! != "" && oUser.email! != "" {// if user found load user profile
                        
                        self.appDelegate.restorePreferencs(user: oUser, listner: {(prefrences) in
                            self.notifyDrawer()
                            self.appDelegate.syncForUser()
                            
                            
                            self.appDelegate.navigateToBudgetScreen()
                            self.appDelegate.logUser(user: oUser)
                        })
         
                        
                        
                    }else{
                        
                        if user?.isAnonymous != true {
                            
                            //
                            let myUser:PUser = PUser()
                            myUser.gid = (user?.uid)!
                            myUser.email = (user?.email)!
                            myUser.first_name = user?.displayName ?? ""
                            myUser.active = 1
                            self.appDelegate.saveUser(user: myUser)
                            
                            
                        }else {
                            
                        }
                        
                    }
                    
                }, error_message: {(message) in
                    
                    let myUser:PUser = PUser()
                    myUser.gid = (user?.uid)!
                    myUser.email = (user?.email)!
                    myUser.first_name = user?.displayName ?? ""
                    myUser.active = 1
                    self.appDelegate.saveUser(user: myUser)
                    
                })
                
                
            } else {
                
                self.navigateToLogin()
                
                
            }
            
        }
    }
    
    func notifyDrawer() {
        drawerViewController?.isAnonymousUser = self.isAnonymousUser
        drawerViewController?.notifyState()
    }

    func navigateToLogin()  {
        let gPref = GlobalPreferences()
        
        if !gPref.hasShowOnboarding() {
            let args:NSDictionary = ["fromscreen": "login"]
            let howItWorks = HowItWorksViewController()
            howItWorks.params = args
            howItWorks.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
            let howItWorksNavController = UINavigationController(rootViewController: howItWorks)
            
            self.centerContainer!.centerViewController = howItWorksNavController
            return
        }
        
        
        if(self.appDelegate.pref.getUnlockCode() != "" && self.appDelegate.pref.getUnlockCode() == Const.SCREEN_LOCK_CODE) {
            
            self.appDelegate.navigateTo(instance: SignInViewController())
            
        } else {
            
            self.appDelegate.navigateTo(instance: SignInViewController())
            
        }
         
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        let currentTime = Int(NSDate().timeIntervalSince1970)
        
        let howlong = (currentTime - self.whenBackgoundtime)
        print("howlong \(howlong)")
        if self.pref.getUnlockCode() != "" && self.pref.getUnlockCode() != nil  && howlong > 15{
            let vc = PINViewController()
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            window?.rootViewController?.present(vc, animated: false)
        }
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        //print("Presented \(window?.rootViewController?.presentedViewController?.nibName)")
        
        self.whenBackgoundtime = Int(NSDate().timeIntervalSince1970)
        
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        Utils.Log(tag: TAG_NAME, message: "Opened dynamic link 4")
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            Utils.Log(tag: self.TAG_NAME, message: "dynamiclink: \(String(describing: dynamiclink?.url))")

            self.appDelegate.shareBudgetNow(url: dynamiclink?.url ?? URL(fileURLWithPath: "http://www.digitleaf.com/"))
        }
    }
    
 

}


struct SceneDelegate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

