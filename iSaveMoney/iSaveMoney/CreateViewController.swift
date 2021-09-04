//
//  CreateViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/16/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import MMDrawerController
import ISMLBase
import Firebase
import DZNEmptyDataSet
import FirebaseFirestore
import TinyConstraints
import ISMLDataService
import CoreData
import CheckoutModule

class CreateViewController: BaseViewController, UIScrollViewDelegate {

    static var viewIdentifier:String = "CreateViewController"
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView(frame: self.view.frame)
        // sv.backgroundColor = UIColor(red:0.28, green:0.61, blue:1.00, alpha:1.0)
        sv.delegate = self
        sv.isPagingEnabled = true
        sv.bounces = false
        return sv
    }()
    
    lazy var imgMain:UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "get_started")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = image
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return imageView
    }()
    
    let labelTitle:UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("getStartTitle", comment: "Let's get started!")
        label.textAlignment = .center
        label.textColor = UIColor(red:0.08, green:0.31, blue:0.66, alpha:1.0)
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Heavy", size: 18)
        return label
    }()
    
    let labelDescription:UILabel = {
        let label = UILabel()
        label.text =  NSLocalizedString("getStartDescription", comment: "Create your first budget, then start tracking your money and even invite partner or family.")
        label.textAlignment = .center
        label.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 15)
        return label
    }()
    
    lazy var createButton:UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("getStartButton", comment: "CREATE A BUDGET"), for: .normal)
        button.setTitleColor(mmChrome.WHITE, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red:0.08, green:0.31, blue:0.66, alpha:1.0)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.addTarget(self, action: #selector(buttonCreate(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.width(200)
        button.height(30)
        return button
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [Const.drawerColor.cgColor,
                        Const.background1.cgColor,
                        Const.background2.cgColor]
        return layer
    }()
    
    lazy var drawerButton:UIBarButtonItem = {
           let menuItem = UIBarButtonItem(image: UIImage(named: "menu"), landscapeImagePhone: UIImage(named: "menu"), style: .plain, target: self, action: #selector(openDrawerButton(_:)))
           return menuItem
       }()
    
    
    var firestoreRef:Firestore!
    var pref: MyPreferences!
    
    var mBudgets:[UserOwnBudget] = []
    var allBudgets:[String:UserOwnBudget] = [:]
    var listenerBudget:ListenerRegistration!
    var pickerIsDisplay = false
    var mStatus = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.firestoreRef = appDelegate.firestoreRef
        self.pref = MyPreferences()
        self.title = "iSaveMoneyGo"
        
        self.navigationItem.leftBarButtonItem  = drawerButton
        
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
        
        
        self.view.addSubview(scrollView)
        
        var firstFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
        firstFrame.origin.x = 0
        firstFrame.size = self.scrollView.frame.size
        let firstSubView = UIView(frame: firstFrame)
        self.scrollView.addSubview(firstSubView)
        
        firstSubView.addSubview(imgMain)
        firstSubView.addSubview(labelTitle)
        firstSubView.addSubview(labelDescription)
        firstSubView.addSubview(createButton)
        imgMain.bottomToSuperview(offset: -300)
        imgMain.centerXToSuperview()
        labelTitle.topToBottom(of: imgMain, offset: 20)
        labelTitle.width(self.scrollView.frame.size.width * 4/5)
        labelTitle.centerXToSuperview()
        labelDescription.topToBottom(of: labelTitle, offset: 20)
        labelDescription.centerXToSuperview()
        labelDescription.width(self.scrollView.frame.size.width  * 4/5)
        
        createButton.topToBottom(of: labelDescription, offset: 20)
        createButton.centerXToSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadBudgets()
    }
    override func viewWillDisappear(_ animated: Bool) {
       
        if listenerBudget != nil {
            listenerBudget.remove()
        }
    }
    
    func loadBudgets() {
        self.mBudgets.removeAll()
        self.allBudgets.removeAll()
        var pref = MyPreferences()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func renderList() {
        
        
        self.mBudgets.removeAll()
        for (key, budgetOwn) in self.allBudgets {
            if self.mStatus == budgetOwn.active {
                self.mBudgets.append(budgetOwn)
            }
            
        }
        
        if self.mBudgets.count > 0 {
            if !pickerIsDisplay{
                pickerIsDisplay = true
                self.createButton.setTitle(NSLocalizedString("buttonChooseBudget", comment: ""), for: .normal)
                self.labelTitle.text = NSLocalizedString("titleChooseBudget", comment: "")
                self.labelDescription.text = NSLocalizedString("bodyChooseBudget", comment: "")
                var vc = BudgetsTableViewController()
                vc.canDismissThis = true
                self.present(vc, animated: true, completion: nil)
            }
        }
        //
        
    }
    
    
    @objc func buttonCreate(_ sender: UIButton) {
        
        if(pickerIsDisplay) {
            var vc = BudgetsTableViewController()
            vc.canDismissThis = true
            self.present(vc, animated: true, completion: nil)
        }else{
            //appDelegate.navigateTo(instance: NewMonthlyBudgetViewController(nibName: "NewMonthlyBudgetViewController", bundle: nil))
            canUserCreateBudget()
        }
        
    }
    
    @objc func openDrawerButton(_ sender: UIBarButtonItem) {
        
        appDelegate.toggleDrawerNav()
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
