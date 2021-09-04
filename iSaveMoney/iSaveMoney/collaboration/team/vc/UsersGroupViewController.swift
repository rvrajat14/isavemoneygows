//
//  UsersGroupViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/3/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase
import Firebase
import DZNEmptyDataSet

class UsersGroupViewController: BaseScreenViewController,UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
   

    @IBOutlet weak var teamUserList: UITableView!
    
    var memberList: [TeamMemberModel] = []
    
    var memberMap:[String:TeamMemberModel] = [:]
    var registrationTeam: ListenerRegistration!
    var team: TeamModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("titleUserGroup", comment: "User Group")
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef
        pref = MyPreferences()
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        let editButton = UIBarButtonItem(image: UIImage(named: "ic_person_add"), landscapeImagePhone: UIImage(named: "ic_person_add"), style: .done, target: self, action:  #selector(inviteMember(_:)))
        self.navigationItem.rightBarButtonItem  = editButton
        // Do any additional setup after loading the view.
        
        self.teamUserList.delegate = self
        self.teamUserList.dataSource = self
        self.teamUserList.separatorColor = UIColor(named: "seperatorColor")
        self.teamUserList.tableFooterView = UIView(frame: CGRect.zero)
        self.teamUserList.tableFooterView = UIView()
        self.teamUserList.backgroundColor = UIColor.clear
        self.teamUserList.emptyDataSetSource = self
        self.teamUserList.emptyDataSetDelegate = self
        
        let tableViewCellNib = UINib(nibName: "UserGroupTableViewCell", bundle: nil)
        self.teamUserList.register(tableViewCellNib, forCellReuseIdentifier: "UserGroupTableViewCell")
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let member: TeamMemberModel = memberList[indexPath.row]
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "UserGroupTableViewCell", for: indexPath) as! UserGroupTableViewCell
        drawerCell.txtTitle.text = member.fullName
        if member.fullName.count > 0 {
            let namePrefix = String(member.fullName.prefix(1))
            drawerCell.circledLetter.setText(text: namePrefix, col: Const.getColorByCharacter(character: namePrefix))
            drawerCell.circledLetter.setNeedsDisplay()
        }
        
        drawerCell.txtDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(member.JoiningDate)), format: self.pref.getDateFormat())
        
        return drawerCell
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {

        self.navigationController?.popViewController(animated: true)
    }
    
    
    //addTeam
    @objc func inviteMember(_ sender: UIBarButtonItem) {
    
        let vc = InviteUserInGroupViewController(nibName: "InviteUserInGroupViewController", bundle: nil)
        vc.team = team
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.loadMember()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.registrationTeam != nil {
            self.registrationTeam.remove()
        }
    }
    
    func loadMember(){
        
        let fbmember = FbTeamMember(reference: self.firestoreRef)
        self.memberMap = [:]
        self.registrationTeam = fbmember.listenByGid(teamGid: self.team.gid,
                                                   adding: {team in
                                                    self.memberMap[team.gid] = team
                                                    self.updateDisplay()
                                                   }, remove: { team in
                                                    self.memberMap[team.gid] = nil
                                                    self.updateDisplay()
                                                   }, error_message: { err in
                                                    print("Error \(err)")
                                                   })
        
    }
    
    func updateDisplay() {
        self.memberList = []
        for (_, v) in self.memberMap {
            self.memberList.append(v)
        }
        
        self.memberList = self.memberList.sorted { $0.fullName < $1.fullName }
        self.teamUserList.reloadData()
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("noUserInGroupTitle", comment: "No User")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("noUserInGroupMessage", comment: "Description")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "ic_add_group")?.withTintColor(UIColor(named: "tintIconsColor") ?? UIColor.blue)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let str = NSLocalizedString("addFirstUser", comment: "Add button")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout), NSAttributedString.Key.foregroundColor: UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        let vc = InviteUserInGroupViewController(nibName: "InviteUserInGroupViewController", bundle: nil)
        vc.team = team
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
