//
//  BaseViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/11/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ISMLBase
import ISMLDataService

class BaseViewController: UIViewController {
    var isFromAnonimous = false
    let indicatorSize = CGSize(width: 30, height: 30)
    let transition = PopAnimator()
    var params:NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor(named: "pageBgColor")
    }
    
    func changeViewController(_ viewIdentifier: String) {
        
        
        let mViewController = self.storyboard?.instantiateViewController(withIdentifier: viewIdentifier) as! BaseViewController
        
        mViewController.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        
        let mNavController = UINavigationController(rootViewController: mViewController)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
        appDelegate.centerContainer!.centerViewController.present(mNavController, animated: true, completion: nil)
    }
    
    
    func changeViewControllerWithNoTransition(_ viewIdentifier: String) {
        
        
        let mViewController = self.storyboard?.instantiateViewController(withIdentifier: viewIdentifier) as! BaseViewController
        
        let mNavController = UINavigationController(rootViewController: mViewController)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.centerContainer!.centerViewController.present(mNavController, animated: false, completion: nil)
        
        
    }
    
    func replaceViewControllerWithNoTransition(_ viewIdentifier: String) {
        
        
        let mViewController = self.storyboard?.instantiateViewController(withIdentifier: viewIdentifier) as! BaseViewController
        
        let mNavController = UINavigationController(rootViewController: mViewController)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.centerContainer!.centerViewController = mNavController
        
    }
    
    func replaceViewControllerWithNoTransition(instence: BaseViewController) {
        
        let mNavController = UINavigationController(rootViewController: instence)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.centerContainer!.centerViewController = mNavController
        
    }

    
    func dismissViewController() {
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.centerContainer!.centerViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func dismissViewControllerNone() {
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.centerContainer!.centerViewController.dismiss(animated: false, completion: nil)
        
    }
    
    
    func changeViewController(baseViewController: BaseViewController) {
        
        
        baseViewController.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        let mNavController = UINavigationController(rootViewController: baseViewController)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        appDelegate.centerContainer!.centerViewController.present(mNavController, animated: true, completion: nil)
        
    }
    
    func changeViewControllerWithParam(baseViewController: BaseViewController) {
        
        
        baseViewController.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        let mNavController = UINavigationController(rootViewController: baseViewController)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        appDelegate.centerContainer!.centerViewController = mNavController
        
    }
    
    public func getTag() -> String {
        return ""
    }
    
    func logThis(message: String){
    
        print("\(getTag()): \(message) \n")
    
    }

    
    
    func indicatorShow() {
        
         /*self.startAnimating(indicatorSize, message: "Please wait", type: NVActivityIndicatorType(rawValue: 1)!)*/
        
        
    }
    
    func indicatorHide() {
        //self.stopAnimating()
    }

    func orientationChanged()  {
        
    }
    

}



extension ViewController: UIViewControllerTransitioningDelegate {
    
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            
            //transition.originFrame =
                //selectedImage!.superview!.convertRect(selectedImage!.frame, toView: nil)
            
            transition.presenting = true
            
            return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }

}
