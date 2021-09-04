//
//  BackupRestoreViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/25/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet
import FirebaseFirestore
import TinyConstraints
import ISMLDataService
import ISMLBase

class BackupRestoreViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, BackupTableViewCellDelegate {
    
    static var viewIdentifier:String = "BackupRestoreViewController"
    var firestoreRef: Firestore!
    var userFileList: [UserFile] = []
    var userFileMap: [String: UserFile] = [:]
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    var pref: MyPreferences!
    var regListner:ListenerRegistration!
    
    lazy var backupTableView:UITableView = {
        
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.separatorInset = UIEdgeInsets.zero
        table.separatorColor = UIColor.clear
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(cancel(_:)))
    }()
    
    lazy var createButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "cloud"),
                               landscapeImagePhone: UIImage(named: "cloud"),
                               style: .plain,
                               target: self,
                               action: #selector(backup(_:)))
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpActivity()
        self.layoutComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.regListner != nil {
            self.regListner.remove()
        }
    }
    
    func setUpActivity() {
        
        flavor = Flavor()
        pref = MyPreferences()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.firestoreRef = appDelegate.firestoreRef
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.navigationItem.rightBarButtonItem  = createButton
        
       
        self.title = NSLocalizedString("fullBackupTitle", comment: "Backup and Restore")
    }
    
    func layoutComponent() {
        backupTableView.emptyDataSetSource = self
        backupTableView.emptyDataSetDelegate = self
        backupTableView.tableFooterView = UIView()
        backupTableView.register(BackupTableViewCell.self, forCellReuseIdentifier: "backupTableViewCell")
        
        self.view.addSubview(backupTableView)
        backupTableView.edgesToSuperview()
        
        // self.mockupdata()
        self.loadData()
        self.backupTableView.reloadData()
        
    }
    
    func loadData() {
        
        let fbUserFile = FbUserFile(reference: self.firestoreRef)
        self.regListner = fbUserFile.getBySync("user_gid", attr_val: self.pref.getUserIdentifier(), complete: {userFile in
            self.userFileMap[userFile.gid] = userFile
            self.refreshDisplay()
            }, error_message: { error in
                
            })
        
    }
    
    func refreshDisplay() {
        self.userFileList = []
        for (_, value) in self.userFileMap {
            if value.status != -1 {
                self.userFileList.append(value)
            }
            
        }
        
        self.backupTableView.reloadData()
    }
 
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFileList.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let userFile: UserFile = userFileList[indexPath.row]
        
        
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "backupTableViewCell", for: indexPath) as! BackupTableViewCell
        drawerCell.textTitle.text = userFile.name
        drawerCell.textTime.text = "\(Utils.formatTimeStamp(userFile.insert_date))  \(Utils.timeFormat(userFile.insert_date))"
        
        drawerCell.restoreBtn.isHidden = false
        if userFile.active == 0 {
            drawerCell.textStatus.isHidden = false
            drawerCell.textStatus.text = NSLocalizedString("backFileInprogress", comment: "Backup in progress...")
            
        } else if userFile.restore {
            drawerCell.textStatus.isHidden = false
            drawerCell.textStatus.text = NSLocalizedString("backFileRestoreInprogress", comment: "Restore in progress...")
            drawerCell.restoreBtn.isHidden = true
        } else {
            drawerCell.textStatus.isHidden = true
        }
        
        drawerCell.delegate = self
        return drawerCell
        
    
        
    }
    
    func didTapRestore(_ sender: BackupTableViewCell) {
        guard let tappedIndexPath = backupTableView.indexPath(for: sender) else { return }

        let userFile: UserFile = userFileList[tappedIndexPath.row]
    
        let confirm = IsmUtils.confirmAction(appDelegate: self.appDelegate,
                                          description: NSLocalizedString("confirmRestoreBackup", comment: "Would you like to restore [bname]?").replacingOccurrences(of: "[bname]", with: userFile.name), confirmed: {() in
               userFile.restore = true
               let fbUserFile = FbUserFile(reference: self.firestoreRef)
               fbUserFile.update(userFile, completion: {ufile in
                   
               }, error_message: { error in
                   
               })
            
        })
        
        self.present(confirm, animated: true, completion: nil)
        
       
        
    }
    
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let userFile = self.userFileList[indexPath.row]
            let confirm = IsmUtils.confirmDelete(appDelegate: self.appDelegate,
                                name: userFile.name,
                                confirmed: { () in
                                    let fbUserFile = FbUserFile(reference: self.firestoreRef)
                                    fbUserFile.delete(userFile)
                                   
                                })
            self.present(confirm, animated: true, completion: nil)
            // tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //Cancel payee
    @objc func cancel(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backup(_ sender: UIBarButtonItem) {
        
        self.createBackup()
        
    }
    
    func createBackup(){
        let fname = "\(UtilsIsm.dateFormatOrTimeFor(Date(), format: "MMMM_dd_yyyy_hh_mm_ss")).json"
        let ftitle = NSLocalizedString("backFileName",
                                       comment: "Backup [name]")
            .replacingOccurrences(of: "[name]", with: UtilsIsm.dateFormatOrTimeFor(Date(), format: "MMMM dd yyyy"))
        let filePath = "backupIsaveMoneyGo/"+self.pref.getUserIdentifier() + "/" + fname;
        
        let userFile = UserFile()
        userFile.user_gid = self.pref.getUserIdentifier()
        userFile.name = ftitle
        userFile.filename = fname
        userFile.filePath = filePath
        userFile.active = 0
        userFile.insert_date = UtilsIsm.getTimeStamp()
        let fbUserFile = FbUserFile(reference: self.firestoreRef)
        fbUserFile.write(userFile, completion: {ufile in
            
        }, error_message: { error in
            
        })
        
    }
    
    
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
        
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("backup_file_notbackup", comment: "No backup yet.")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("backup_file_des",
                                    comment: "Backup your data and you will be able to restore it later...")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "cloud_computing")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let str = NSLocalizedString("backup_file_addbackup", comment: "Create a backup")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout), NSAttributedString.Key.foregroundColor: UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        
        self.createBackup()
    }

}
