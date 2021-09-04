//
//  GroupsViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/3/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase
import Firebase
import DZNEmptyDataSet

class GroupsViewController: BaseScreenViewController, UITableViewDataSource, UITableViewDelegate, TeamInviteDelegate,
                            DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var listGroups: UITableView!
    
    var teamList: [TeamModel] = []
    
    var teamMap:[String:TeamModel] = [:]
    var registrationTeam: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("titleGroup", comment: "Group")
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef
        pref = MyPreferences()
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        let editButton = UIBarButtonItem(image: UIImage(named: "new"), landscapeImagePhone: UIImage(named: "new"), style: .done, target: self, action:  #selector(addTeam(_:)))
        self.navigationItem.rightBarButtonItem  = editButton
        // Do any additional setup after loading the view.
        
        self.listGroups.delegate = self
        self.listGroups.dataSource = self
        self.listGroups.separatorColor = UIColor(named: "seperatorColor")
        self.listGroups.tableFooterView = UIView(frame: CGRect.zero)
        self.listGroups.tableFooterView = UIView()
        self.listGroups.backgroundColor = UIColor.clear
        self.listGroups.emptyDataSetSource = self
        self.listGroups.emptyDataSetDelegate = self
        
        
        let tableViewCellNib = UINib(nibName: "TeamRowTableViewCell", bundle: nil)
        self.listGroups.register(tableViewCellNib, forCellReuseIdentifier: "TeamRowTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadTeams()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.registrationTeam != nil {
            self.registrationTeam.remove()
        }
    }
    
    func loadTeams(){
        
        let fbTeam = FbTeamModel()
        self.teamMap = [:]
        self.registrationTeam = fbTeam.listenByGid(userGid: self.pref.getUserIdentifier(),
                                                   adding: {team in
                                                    self.teamMap[team.gid] = team
                                                    self.updateDisplay()
                                                   }, remove: { team in
                                                    self.teamMap[team.gid] = nil
                                                    self.updateDisplay()
                                                   }, error_message: { err in
                                                    print("Error \(err)")
                                                   })
        
    }
    
    func updateDisplay() {
        self.teamList = []
        for (_, v) in self.teamMap {
            self.teamList.append(v)
        }
        
        self.teamList = self.teamList.sorted { $0.name < $1.name }
        self.listGroups.reloadData()
    }

    @objc func cancel(_ sender: UIBarButtonItem) {

        self.dismiss(animated: true, completion: nil)
    }
    
    
    //addTeam
    @objc func addTeam(_ sender: UIBarButtonItem) {
    
        let vc = AddGroupViewController(nibName: "AddGroupViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.teamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let team: TeamModel = teamList[indexPath.row]
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "TeamRowTableViewCell", for: indexPath) as! TeamRowTableViewCell
        drawerCell.txtTeamTitle.text = team.name
        if team.name.count > 0 {
            let namePrefix = String(team.name.prefix(1))
            drawerCell.circledLetter.setText(text: namePrefix, col: Const.getColorByCharacter(character: namePrefix))
            drawerCell.circledLetter.setNeedsDisplay()
        }
        
        drawerCell.teamId = team.gid
        drawerCell.delegate = self
        drawerCell.txtTeamCreateDate.text = UtilsIsm.DateFormat(date: Date(timeIntervalSince1970: Double(team.createdDate)), format: self.pref.getDateFormat())
        
        return drawerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team: TeamModel = teamList[indexPath.row]
        let inviteVc = UsersGroupViewController(nibName: "UsersGroupViewController", bundle: nil)
        inviteVc.team = team
        self.navigationController?.pushViewController(inviteVc, animated: true)
    }
    
    func onInvite(teamId: String) {
        let inviteVc = InviteUserInGroupViewController(nibName: "InviteUserInGroupViewController", bundle: nil)
        inviteVc.team = self.teamMap[teamId]
        self.navigationController?.pushViewController(inviteVc, animated: true)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("noGroupTitle", comment: "No Group")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("noGroupMessage", comment: "Description")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "ic_team")?.withTintColor(UIColor(named: "tintIconsColor") ?? UIColor.blue)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let str = NSLocalizedString("addFirstGroup", comment: "Add button")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout), NSAttributedString.Key.foregroundColor: UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        let vc = AddGroupViewController(nibName: "AddGroupViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
