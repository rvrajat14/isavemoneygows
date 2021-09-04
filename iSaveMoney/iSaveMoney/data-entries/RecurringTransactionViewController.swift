//
//  RecurringTransactionViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/24/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet
import FirebaseFirestore
import ISMLDataService
import ISMLBase

class RecurringTransactionViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate , DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    
    var tableView: UITableView!
   
    var firestoreRef: Firestore!
    var pref: MyPreferences!
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    var schedulesList:[Schedule] = []
    var schedulesMap:[String: Schedule] = [:]
    var scheduleListner:ListenerRegistration!

    
    static var viewIdentifier:String = "RecurringTransactionViewController"
    
    public override func getTag() -> String {
        
        return "RecurringTransactionViewController"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        firestoreRef = appDelegate.firestoreRef
        self.setUpActivity()
        self.layoutComponent()
      
    }
    
    func setUpActivity() {
        self.pref = MyPreferences()
        self.title = NSLocalizedString("txtRecurringTransactions", comment: "")


        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(canelPage))

        self.navigationItem.leftBarButtonItem  = cancelButton
    }
    
    func layoutComponent() {
        
        tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "scheduleTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        tableView.separatorColor = UIColor(named: "seperatorColor")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        self.view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadSchedules()
    }
    
    @objc func canelPage() {
        //appDelegate.navigateTo(instance: ViewController())
        self.dismiss(animated: true)
    }
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return schedulesList.count
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.scheduleListner != nil {
            self.scheduleListner.remove()
        }
    }
    
    func loadSchedules() {
        
        let fbScheduler = FbSchedule(reference: firestoreRef)
        fbScheduler.listenByUser(userGid: self.pref.getUserIdentifier(),
                                 adding: {schedule in
                                    self.schedulesMap[schedule.gid] = schedule
                                    self.reloadList()
                                 }, remove: {schedule in
                                    self.schedulesMap.removeValue(forKey: schedule.gid)
                                    self.reloadList()
                                 }, error_message: {error in
                                    
                                 })
        
//        fbScheduler.listenByUser(self.pref.getUserIdentifier(), complete: {(schedules) in
//            self.schedulesList = schedules
//            self.tableView.reloadData()
//        }, error_message: {(error) in
//
//            print(error.errorMessage)
//        })
//
        
    }
    
    func reloadList() {
        self.schedulesList = []
        
        for (k, v) in self.schedulesMap {
            self.schedulesList.append(v)
        }
        
        self.tableView.reloadData()
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let drawerCell = tableView.dequeueReusableCell(withIdentifier: "scheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        let schedule = self.schedulesList[indexPath.row]
        
        if schedule.transaction_str != nil {
            drawerCell.labelTitle.text = formTitle(schedul: schedule)
        }else {
            getTransactionTitle(schedule: schedule, listener: {title in
                
                drawerCell.labelTitle.text = title
            })
        }
        
        let timeStr = Utils.timeFormat(Int(schedule.nextOccurred))
        let dateStr = Utils.formatTimeStamp(Int(schedule.nextOccurred))
        drawerCell.labelRecurrence.text = schedule.verboseSchedule()
        drawerCell.labelNextGoesOff.text = "\(NSLocalizedString("txtFirstGoesOffOn", comment: "")) \(dateStr) \(timeStr)"
        
        let todaytimeStamp = Int(Date().timeIntervalSince1970)
        
        if schedule.nextOccurred < todaytimeStamp {
            
            drawerCell.stateIndicatorImage.image = drawerCell.scheduleOff
            
            drawerCell.stateIndicatorImage.image = drawerCell.stateIndicatorImage.image!.withRenderingMode(.alwaysTemplate)
            drawerCell.stateIndicatorImage.tintColor = Const.RED
        }else {
            
            drawerCell.stateIndicatorImage.image = drawerCell.scheduleOntime
            drawerCell.stateIndicatorImage.image = drawerCell.stateIndicatorImage.image!.withRenderingMode(.alwaysTemplate)
            drawerCell.stateIndicatorImage.tintColor = Const.GREEN
        }
        return drawerCell
    }
    
    func formTitle(schedul: Schedule) -> String {
        
        if schedul.transaction_str != nil {
            
            let payload:NSDictionary = schedul.transaction_str ?? [:]
            var textTitle = ""
            switch schedul.transaction_type {
            case Scheduler.TRANSACTION_TYPE_EXPENSE:
                textTitle = payload["title"] as? String ?? "Transaction"
                
                break
            case Scheduler.TRANSACTION_TYPE_INCOME:
                textTitle = payload["title"] as? String ?? "Transaction"
                
                break
            case Scheduler.TRANSACTION_TYPE_TRANSFER:
                textTitle = "\(payload["from_str"] as? String ?? "Transaction") \(NSLocalizedString("txtTo", comment: "")) \(payload["to_str"] as? String ?? "transaction")"
                
                break
            default:
                textTitle = "Transaction"
            }
            
            return textTitle
            
        } else {
            
            return ""
        }
        
    }
    
    func getTransactionTitle(schedule: Schedule, listener: @escaping (String) -> Void) {
        
        let fbSchedule:FbSchedule = FbSchedule(reference: self.firestoreRef)
        
        switch schedule.transaction_type {
            
        case Scheduler.TRANSACTION_TYPE_INCOME:
            let fbIncome:FbIncome = FbIncome(reference: self.firestoreRef)
            fbIncome.get(income_gid: schedule.transaction_gid, listener: { income in
                
                schedule.transaction_str = income.toAnyObject()
                //fbSchedule.update(schedule)
                
                listener(income.title!)
                
            }, error_message: {(error) in
                print(error)
            })
        case Scheduler.TRANSACTION_TYPE_EXPENSE:
            
            let fbExpense:FbExpense = FbExpense(reference:self.firestoreRef)
            fbExpense.get(schedule.transaction_gid, listener: { expense in
                
                listener(expense.title!)
                
            }, error_message: {(error) in
                print(error)
            })
        case Scheduler.TRANSACTION_TYPE_TRANSFER:
            
            let fbTransfer:FbTransfer = FbTransfer(reference: self.firestoreRef)
            fbTransfer.get(schedule.transaction_gid, listener: { transfer in
                
                listener("\(transfer.from_str!) > \(transfer.to_str!)")
            }, error_message: {(error) in
                print(error)
            })
            
            
        default:
            fbSchedule.delete(schedule.gid)
            listener("")
            break
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let schedule = schedulesList[indexPath.row]
        
        switch schedule.transaction_type {
        case Scheduler.TRANSACTION_TYPE_EXPENSE:
            let params:NSDictionary = ["minDate": Date(),
                                       "maxDate": Date(),
                                       "schedule": schedule.toAnyObject()]
            let expVc = NewExpenseViewController()
            expVc.params = params
            self.navigationController?.pushViewController(expVc, animated: true)
            //self.present(UINavigationController(rootViewController: expVc), animated: true)
            
        case Scheduler.TRANSACTION_TYPE_INCOME:
            let params:NSDictionary = ["minDate": Date(),
                                       "maxDate": Date(),
                                       "schedule": schedule.toAnyObject()]
            
            let incVc = NewIncomeViewController()
            incVc.params = params
            self.navigationController?.pushViewController(incVc, animated: true)
            //self.present(UINavigationController(rootViewController: incVc), animated: true)
            
        case Scheduler.TRANSACTION_TYPE_TRANSFER:
            let params:NSDictionary = ["schedule": schedule.toAnyObject()]
            let transVc = AccountTransferViewController()
            transVc.params = params
            self.navigationController?.pushViewController(transVc, animated: true)
           
            
        default:
            break
        }
        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("NoRecurringTransaction", comment: "No reccuring transaction yet.")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("NoRecurringTransactionDescription", comment: "When you activate a reccuring transaction while recording and expense, income, or transfer, your transaction is executed automatically at the due date.")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "repeat")
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let fbSchedule:FbSchedule = FbSchedule(reference: self.firestoreRef)
            fbSchedule.delete(schedulesList[indexPath.row].gid!)
            schedulesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
