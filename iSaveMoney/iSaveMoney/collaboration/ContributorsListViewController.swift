//
//  ContributorViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/28/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet
import FirebaseFirestore
import ISMLDataService
import ISMLBase
import FirebaseAuth
import TinyConstraints

class ContributorsListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, InviteDelegate {
    func completedInvite() {
        //
    }
    

    static var viewIdentifier:String = "ContributorsListViewController"
    
    var contributorsTableView: UITableView!
    var addMember: ButtonWithArrow!
    
    var firestoreRef:Firestore!
    var pref:MyPreferences!
    var mBudget:Budget!
    
    var mBudgetName:String = ""
    //var contributorSync:ContributorsSync!
    
    var mContributors:[BudgetEditor] = []
    var mapOfContributors:[String:BudgetEditor] = [:]
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    var listener: ListenerRegistration!
    
    var viewControllerNavController:UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        self.title = NSLocalizedString("invite_share_title", comment: "Title")
        
        
        self.contributorsTableView = {
            
            let table = UITableView()
            table.translatesAutoresizingMaskIntoConstraints = false
            return table
        }()
        

        addMember = {
            let button = ButtonWithArrow()
            button.setTitle( NSLocalizedString("invite_share_add", comment: "Add members"), for: .normal)
            button.addTarget(self, action: #selector(ContributorsListViewController.buttonInviteAction), for: .touchUpInside)
            return button
        }()
        
       
        self.view.addSubview(self.contributorsTableView)
        self.view.addSubview(addMember)
        contributorsTableView.edgesToSuperview( insets: .bottom(10), usingSafeArea: true)
        addMember.edgesToSuperview(excluding: .top, insets: .left(10) + .right(10) + .bottom(10) ,usingSafeArea: true)
        
        //
        //self.contributorsTableView.register(PayeeTableViewCell.self, forCellReuseIdentifier: "payeeTableViewCell")
    
//        self.contributorsTableView.delegate = self
//        self.contributorsTableView.dataSource = self
//        self.contributorsTableView.separatorColor = UIColor(named: "seperatorColor")
//        self.contributorsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.contributorsTableView.tableFooterView = UIView()
        self.contributorsTableView.delegate = self
        self.contributorsTableView.dataSource = self
        self.contributorsTableView.separatorColor = UIColor(named: "seperatorColor")
        self.contributorsTableView.backgroundColor = UIColor.clear
        self.contributorsTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.contributorsTableView.tableFooterView = UIView()
        
        self.contributorsTableView.register(ContributorTableViewCell.self, forCellReuseIdentifier: "ContributorTableViewCell")
        
        
        mBudgetName = params["mBudgetName"] as? String ?? ""
        mBudget = params["mBudget"] as? Budget ?? nil
  
        
       
        self.firestoreRef = appDelegate.firestoreRef
        self.pref = MyPreferences()
       
        
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(ContributorsListViewController.cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        // Do any additional setup after loading the view.
        
        loadUsers()
        
        let cv:InviteShareModal = InviteShareModal()
        viewControllerNavController = UINavigationController(rootViewController: cv)
    }
    
    @objc func buttonInviteAction() {
        if mBudget.owner! != self.pref.getUserIdentifier() {
            
            self.displayDeny()
            
            return
        }
        
        if (Auth.auth().currentUser?.isAnonymous)! {
           
            self.appDelegate.navigateTo(instance: SignInViewController()) 
            return
        }
        
        let vcon = self.viewControllerNavController.topViewController as! InviteShareModal
     
    
        vcon.budget = mBudget
        vcon.budgetName = mBudgetName
        vcon.delegate = self
        self.present(self.viewControllerNavController, animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        print("viewWillDisappear")
       
        self.listener.remove()
    }
    
    
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        
        //appDelegate.navigateTo(instance: ViewController())
        self.navigationController?.popViewController(animated: true)
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        return mContributors.count
        
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let user: BudgetEditor = mContributors[indexPath.row]
        
        
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "ContributorTableViewCell", for: indexPath) as! ContributorTableViewCell
        
    
        //"budgetsAdmin" "budgetsGuest"
        var userRole = NSLocalizedString("budgetsGuest", comment: "Contributor")
        if user.userGid == mBudget.owner! {
            userRole = NSLocalizedString("budgetsAdmin", comment: "Budget Own")
        }
        drawerCell.labelName.text = getEmailName(emailAddress: user.user_email)
        drawerCell.labelNameTag.text = "@" + getEmailName(emailAddress: user.user_email) + " (" + userRole + ")"
        
        return drawerCell
        
    }
    
    func getEmailName(emailAddress:String) -> String {
        
      
        var emailParts =  emailAddress.split(separator: "@")
        let name: String = emailParts.count > 0 ? String(emailParts[0]) : emailAddress
        
        return name
    }
    
    func getUserName(user:PUser) -> String {
    
        var name = "";
        if user.first_name != nil && user.first_name.count > 0 {
        
            name = user.first_name;
        } else if user.last_name != nil && user.last_name.count > 0 {
        
            name = user.last_name;
        } else if user.last_name != nil && user.last_name.count > 0 {
        
            var emailPart = user.email.split(separator: "@");
        
            if  emailPart.count > 0 {
                name = String(emailPart[0]);
                
            }
        }
        
        return name;
    }
    
    func getUserTagName(user:PUser) -> String {
    
        var name = "";
        var emailPart = user.email.split(separator: "@")
    
        if emailPart.count > 0 {
            name = String(emailPart[0]);
        }
        
    
        return name
    }


    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if (self.mBudget.owner! != self.pref.getUserIdentifier()) {
            
            self.displayDeny()
            return
        }
        let user: BudgetEditor = mContributors[indexPath.row]
        
        if editingStyle == .delete {
            // Delete the row from the data source
            let fbBudget:FbBudget = FbBudget(reference: self.firestoreRef)
            fbBudget.removeEditor(editorGid: user.gid)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        let user: BudgetEditor = mContributors[indexPath.row]
        
        if user.gid == mBudget.owner! {
            return false
        } else if pref.getUserIdentifier() == mBudget.owner! {
            return true
        } else {
            return false
        }
        
    }
    
    
    func displayDeny(){
        
        let alertController = UIAlertController(title: NSLocalizedString("ContributorActionDenied", comment: "Action denied"), message: NSLocalizedString("ContributorActionDeniedDescription", comment: "Only the owner can make this action."), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ContributorActionDeniedOk", comment: "Ok"), style: .default) { action in
            // perhaps use action.title here
        })
        
        self.present(alertController, animated: true) {}
    }
    
    
    func loadUsers()  {
        
        let fbBudget = FbBudget(reference: self.firestoreRef)
        let fbUser = FbUser(reference: self.firestoreRef)

        listener = fbBudget.getBudgetEditors(budget_gid: mBudget.gid!, completed: {editor in
            //self.mContributors = editors
            if editor.status == -1 {
                self.mapOfContributors[editor.gid] = nil
            } else {
                self.mapOfContributors[editor.gid] = editor
                
            }
            self.renderCOntributor()
            //self.contributorsTableView.reloadData()
        }, not_found: { error in
            
        })
        
    }
    
    func renderCOntributor() {
        
        mContributors = []
        
        for (key, value) in self.mapOfContributors {
            
            mContributors.append(value)
        }
        
        self.contributorsTableView.reloadData()
    }

}
