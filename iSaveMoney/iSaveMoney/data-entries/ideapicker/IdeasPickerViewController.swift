//
//  IdeasPickerViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/12/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

public protocol IdeaSelectDelegate: class {
    func onIdeaSeleted(value: IdeaRow)
}

class IdeasPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var txtTitleBox: UILabel!
    @IBOutlet weak var tableListIdea: UITableView!
    @IBOutlet weak var buttonCloseBox: UIButton!
    
    var ideaList: [IdeaRow]!
    var delegate: IdeaSelectDelegate!
    var displayTitle: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableListIdea.dataSource = self
        self.tableListIdea.delegate = self
        self.tableListIdea.backgroundColor = UIColor.clear
        self.tableListIdea.rowHeight = UITableView.automaticDimension
        self.tableListIdea.allowsSelectionDuringEditing = false
        self.tableListIdea.separatorStyle = .none
        self.tableListIdea.separatorInset = UIEdgeInsets.zero
        self.tableListIdea.separatorColor = UIColor.clear
        
        let tableViewCellNib = UINib(nibName: "IdeaTableViewCell", bundle: nil)
        self.tableListIdea.register(tableViewCellNib, forCellReuseIdentifier: "IdeaTableViewCell")
        
        
        self.txtTitleBox.text =  NSLocalizedString("pickCategoryIdea", comment: "Pick idea")
        self.view.backgroundColor = UIColor(named: "pageBgColor")
        
        self.buttonCloseBox.addTarget(self, action: #selector(closeBox), for: .touchUpInside)
    }


    @objc func closeBox() {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideaList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idea: IdeaRow = ideaList[indexPath.row]
        
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "IdeaTableViewCell", for: indexPath) as! IdeaTableViewCell
        
        drawerCell.textRowDis.text = idea.name
        
        return drawerCell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let idea: IdeaRow = ideaList[indexPath.row]
        
        if delegate != nil {
            delegate.onIdeaSeleted(value: idea)
           
        }
        
        self.dismiss(animated: true)
        
    }
}
