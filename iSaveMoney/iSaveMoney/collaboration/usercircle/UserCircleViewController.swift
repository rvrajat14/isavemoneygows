//
//  UserCircleViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/2/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLDataService

public protocol EditorSelectDelegate: class {
    func onEditorSeleted(value: String)
}

class UserCircleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  

    @IBOutlet weak var listUsers: UITableView!
    
    var delegate:EditorSelectDelegate!
    
    var editorList:[BudgetEditor] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listUsers.dataSource = self
        self.listUsers.delegate = self
        self.listUsers.backgroundColor = UIColor.clear
        self.listUsers.rowHeight = UITableView.automaticDimension
        self.listUsers.allowsSelectionDuringEditing = false
        self.listUsers.separatorStyle = .none
        self.listUsers.separatorInset = UIEdgeInsets.zero
        self.listUsers.separatorColor = UIColor.clear
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.editorList = appDelegate?.getUserCircle() ?? []
        
        let tableViewCellNib = UINib(nibName: "UserCircleTableViewCell", bundle: nil)
        self.listUsers.register(tableViewCellNib, forCellReuseIdentifier: "UserCircleTableViewCell")
        
        // Do any additional setup after loading the view.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editorList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let uEditor: BudgetEditor = editorList[indexPath.row]
        
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "UserCircleTableViewCell", for: indexPath) as! UserCircleTableViewCell
        
        drawerCell.emailLabel.text = uEditor.user_email
        
        return drawerCell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let uEditor: BudgetEditor = editorList[indexPath.row]
        
        if delegate != nil {
            delegate.onEditorSeleted(value: uEditor.user_email)
           
        }
        
        self.dismiss(animated: true)
    }
    
    @IBAction func closeBox(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}
