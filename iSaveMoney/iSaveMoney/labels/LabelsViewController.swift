//
//  LabelsViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/14/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet
import ISMLDataService
import ISMLBase

class LabelsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, LabelDelegate {
    func valueReturn(sender: Label, position: Int) {
        
        if position > 0 {
            mLabels[position].title = sender.title
        }
        
        
    }
    
    
    var labelsTableView:UITableView!
    //var ref: DatabaseReference!
    
    var mLabels:[Label] = []
   
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    
    var viewControllerNavController:UINavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.labelsTableView = {
            
            let table = UITableView()
            table.translatesAutoresizingMaskIntoConstraints = false
            return table
        }()
        
        self.view.addSubview(self.labelsTableView)
        
        self.labelsTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.labelsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.labelsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.labelsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        //
        self.labelsTableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "labelTableViewCell")
        
        
        self.labelsTableView.delegate = self
        self.labelsTableView.dataSource = self
        self.labelsTableView.separatorStyle = .none
        self.labelsTableView.separatorInset = UIEdgeInsets.zero
        self.labelsTableView.separatorColor = UIColor.clear
        self.labelsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //self.payerTableView.contentInset = UIEdgeInsetsMake(10, 5, 10, 5);
        //self.ref = Database.database().reference()
        
       
        mLabels = []
        
        pullLabels()
        
        
        self.labelsTableView.emptyDataSetSource = self
        self.labelsTableView.emptyDataSetDelegate = self
        self.labelsTableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
        //
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:flavor.getNavigationBarColor(), NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 18)!]
        
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(LabelsViewController.cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        let editButton = UIBarButtonItem(image: UIImage(named: "new"), landscapeImagePhone: UIImage(named: "new"), style: .done, target: self, action:  #selector(LabelsViewController.addLabel(_:)))
        self.navigationItem.rightBarButtonItem  = editButton
        
        self.title = "Labels"
        
        let cv:LabelForm = LabelForm()
        viewControllerNavController = UINavigationController(rootViewController: cv)
    }
    
    func pullLabels() {
        
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return mLabels.count
 
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let label: Label = mLabels[indexPath.row]
        
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "labelTableViewCell", for: indexPath) as! LabelTableViewCell
        
        drawerCell.textTitle.text = label.title
        
        
        return drawerCell
        
    }
    
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let fbLabel:FbLabel = FbLabel(reference: self.appDelegate.firestoreRef)
            fbLabel.delete(mLabels[indexPath.row])
            mLabels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //Cancel label
    @objc func cancel(_ sender: UIBarButtonItem) {
        
        appDelegate.navigateTo(instance: ViewController())
    }
    
    
    //Add label
    @objc func addLabel(_ sender: UIBarButtonItem) {
        
        let vcon = self.viewControllerNavController.topViewController as! LabelForm
   
       
        vcon.delegate = self
        self.present(self.viewControllerNavController, animated: true, completion: nil)
        
    }
    
    
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        //let args:NSDictionary = ["payee": mLabels[indexPath.row]]
        
        
        let vcon = self.viewControllerNavController.topViewController as! LabelForm
        vcon.label = mLabels[indexPath.row]
        vcon.delegate = self
        self.present(self.viewControllerNavController, animated: true, completion: nil)
        
        
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("LabelNoPayee", comment: "No label yet.")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("LabelDescription", comment: "A label help you group your expenses or incomes...")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "receipt")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let str = NSLocalizedString("LabelAddFirst", comment: "Add your first label")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout), NSAttributedString.Key.foregroundColor: UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        
        //self.changeViewController(PayeeFormViewController.viewIdentifier)
    }
}
