//
// FbUser.swift
// iSaveMoney
//
// Created by Armel Koudoum on 1/15/17.
// Copyright © 2017 UlmatCorpit. All rights reserved.
//


///-------------createBudget----------------------

import Firebase
import FirebaseFirestore
import FirebaseDatabase

public class FbBudget{
    let dbReference: Firestore
    let BUDGETS = Const.ENVIRONEMENT+"budgets"
    let USER_OWN_BUDGETS = Const.ENVIRONEMENT+"user_own_budgets"
    let BUDGET_EDITORS = Const.ENVIRONEMENT+"budget_editors"
    
    var budgetRef:DatabaseQuery!
    var userBudgetRef:DatabaseQuery!
    
    /** public init(reference: DatabaseReference) **/
    
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    
    
    /** public func write() **/
    public func write(_ budget: Budget, returnSaved: @escaping (Budget)->Void) -> Void {
        
        let newbudgetRef = self.dbReference.collection(BUDGETS).document()
        budget.gid = newbudgetRef.documentID
        newbudgetRef.setData(budget.toAnyObject() as! [String : Any])
        
        if Utils.validString(val: budget.owner) {
            
            print("Add budget for user \(budget.owner!) - \(newbudgetRef.documentID)")
            addEditorToBudget(budget_gid: newbudgetRef.documentID, user_gid: budget.owner!, returnSaved: { saved in
                
                
            } )
            
        }
        
        returnSaved(budget)
        
    }
    
    public func update(_ budget: Budget) -> Void {
        
    self.dbReference.collection(BUDGETS).document(budget.gid).updateData(budget.toAnyObject() as! [AnyHashable : Any])
       
    }
    
    public func addEditorToBudget(budget_gid:String, user_gid:String, returnSaved: @escaping (UserOwnBudget)->Void) {
        
        let refEditor = self.dbReference.collection(BUDGET_EDITORS).document()
        let edtitor = BudgetEditor(dataMap: [:])
        edtitor.gid = refEditor.documentID
        edtitor.budgetGid = budget_gid
        edtitor.userGid = user_gid
        
        let userRef = FbUser(reference: self.dbReference)
        userRef.get(userGid: user_gid, listner: {(user) in
            
            edtitor.user_email = user.email
            self.dbReference.collection(self.BUDGET_EDITORS)
                .document(edtitor.gid)
                .setData(edtitor.toAnyObject() as! [String : Any])
            
           
        }, error_message: {(error) in
            print(error)
        })
        
        
        get(budget_gid, completed:{ budget in
            self.addBudgetForUSer(user_gid: user_gid, budget: budget, timestamp: Int(Date().timeIntervalSince1970), returnSaved: {userOwn in
                returnSaved(userOwn)
            })
            
            
        }, not_found: {(notfound) in
            print(notfound)
        })
        
        
    }
    
    public func addBudgetForUSer(user_gid:String, budget:Budget, timestamp:Int, returnSaved: @escaping (UserOwnBudget)->Void) {
        
        //let budgetRef = FbBudget(reference: self.dbReference)
        
        let refUserBudget = self.dbReference.collection(USER_OWN_BUDGETS).document()
        let userBudget = UserOwnBudget(dataMap: [:])
        userBudget.gid = refUserBudget.documentID
        userBudget.userGid = user_gid
        userBudget.budgetGid = budget.gid
        userBudget.start_date = budget.start_date
        userBudget.owner = budget.owner
        userBudget.active = 1
        userBudget.end_date = budget.end_date
        userBudget.last_used = timestamp
        userBudget.budgetTitle = budget.comment
        
        refUserBudget.setData(userBudget.toAnyObject() as! [String : Any])
    
        returnSaved(userBudget)
        
    }
    
    public func markAsUnread(userBudgetGid:String, status:Bool = true) {
        
        //let budgetRef = FbBudget(reference: self.dbReference)
        
        self.dbReference
            .collection(USER_OWN_BUDGETS)
            .document(userBudgetGid)
            .updateData(["unread": status])
        
    }
    
    
    public func getUserBudgets(user_gid:String, onBudgetRead: @escaping ([UserOwnBudget])->Void) -> Void {
        
        self.dbReference.collection(USER_OWN_BUDGETS)
            .whereField("userGid", isEqualTo: user_gid)
            .order(by: "start_date", descending: true)
            .getDocuments(completion: { (documentsResult, err) in
                
                var userBugetsList = [UserOwnBudget]()
                
                if err != nil {
                    
                    let error:FbError = FbError()
                    error.errorCode = 101
                    error.errorMessage = "Error getting user budgets: \(String(describing: err))"
                    onBudgetRead([])
                } else {
                    
                    for document in documentsResult!.documents {
                    
                        let userBudgetEntry = UserOwnBudget(dataMap: document.data())
                        userBudgetEntry.gid = document.documentID
                        
                        userBugetsList.append(userBudgetEntry)
                        
                        
                    }
                    
                    onBudgetRead(userBugetsList)
                }
                
            })
        
        
    }
    public func getUserBudgetsSync(user_gid:String,
                            onBudgetRead: @escaping (UserOwnBudget)->Void,
                            error_message: @escaping (String)->Void) -> ListenerRegistration {
        
        return self.dbReference.collection(USER_OWN_BUDGETS)
            .whereField("userGid", isEqualTo: user_gid)
            .addSnapshotListener({querySnapshot, error in
                
                guard let snapshot = querySnapshot else {
                    
                    error_message("Error fetching snapshots: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                     
                        let userOwnBudget = UserOwnBudget(dataMap: diff.document.data())
                        userOwnBudget.status = 1
                        onBudgetRead(userOwnBudget)
                        
                    }
                    if (diff.type == .modified) {
                       
                        let userOwnBudget = UserOwnBudget(dataMap: diff.document.data())
                        userOwnBudget.status = 2
                        onBudgetRead(userOwnBudget)
                    }
                    if (diff.type == .removed) {
                 
                        let userOwnBudget = UserOwnBudget(dataMap: diff.document.data())
                        userOwnBudget.status = -1
                        onBudgetRead(userOwnBudget)
                    }
                }
            })
        
    }
    
    
    public func getUserBudgetsActive(user_gid:String, onBudgetRead: @escaping ([UserOwnBudget])->Void) -> Void {
        
        self.dbReference.collection(USER_OWN_BUDGETS)
            .whereField("userGid", isEqualTo: user_gid)
            .whereField("active", isEqualTo: 1)
            .order(by: "start_date", descending: true)
            .getDocuments(completion: { (documentsResult, err) in
                
                var userBugetsList = [UserOwnBudget]()
                
                if err != nil {
                    
                    let error:FbError = FbError()
                    error.errorCode = 101
                    error.errorMessage = "Error getting user budgets: \(String(describing: err))"
                    onBudgetRead([])
                } else {
                    
                    for document in documentsResult!.documents {
                        
                        
                        let userBudgetEntry = UserOwnBudget(dataMap: document.data())
                        userBudgetEntry.gid = document.documentID
                        
                        userBugetsList.append(userBudgetEntry)
                        
                        
                    }
                    
                    onBudgetRead(userBugetsList)
                }
                
            })
        
        
    }
    
    public func getAllBudgetsBelonging(user_gid:String, onBudgetRead: @escaping ([UserOwnBudget])->Void) -> Void {
        
        self.dbReference.collection(USER_OWN_BUDGETS)
            .whereField("userGid", isEqualTo: user_gid)
            .order(by: "start_date", descending: true)
            .getDocuments(completion: { (documentsResult, err) in
                
                var userBugetsList = [UserOwnBudget]()
                
                if err != nil {
                    
                    let error:FbError = FbError()
                    error.errorCode = 101
                    error.errorMessage = "Error getting user budgets: \(String(describing: err))"
                    onBudgetRead([])
                } else {
                    
                    for document in documentsResult!.documents {
                        
                        let userBudgetEntry = UserOwnBudget(dataMap: document.data())
                        userBudgetEntry.gid = document.documentID
                        
                        userBugetsList.append(userBudgetEntry)
                        
                        
                    }
                    
                    onBudgetRead(userBugetsList)
                }
                
            })
        
        
    }
    
    public func lookUpBudgetForUser(bugdet_gid:String, user_gid:String, onBudgetRead: @escaping ([UserOwnBudget])->Void) -> Void {
        
        self.dbReference.collection(USER_OWN_BUDGETS)
            .whereField("budgetGid", isEqualTo: bugdet_gid)
            .whereField("userGid", isEqualTo: user_gid)
            .getDocuments(completion: { (documentsResult, err) in
                
                var userBugetsList = [UserOwnBudget]()
                
                if err != nil {
                    
                    let error:FbError = FbError()
                    error.errorCode = 101
                    error.errorMessage = "Error getting user budgets: \(String(describing: err))"
                    onBudgetRead([])
                } else {
                    
                    for document in documentsResult!.documents {
                        
                        let userBudgetEntry = UserOwnBudget(dataMap: document.data())
                        userBudgetEntry.gid = document.documentID
                        
                        userBugetsList.append(userBudgetEntry)
                        
                        
                    }
                    
                    onBudgetRead(userBugetsList)
                }
                
            })
        
        
    }
    
    public func getUnreadBudget(userGid: String, completed: @escaping (UserOwnBudget)->Void, not_found: @escaping (String)->Void) -> ListenerRegistration {
        return self.dbReference.collection(USER_OWN_BUDGETS)
            .whereField("userGid", isEqualTo: userGid)
            .whereField("unread", isEqualTo: true)
            .addSnapshotListener({documentSnapshot, error in
                
                guard let snapshot = documentSnapshot else {
                    
                    not_found("Error fetching snapshots: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                       
                        let userOwn = UserOwnBudget(dataMap: diff.document.data())
                        userOwn.status = 1
                        completed(userOwn)
                        
                    }
                    if (diff.type == .modified) {
                        let userOwn = UserOwnBudget(dataMap: diff.document.data())
                        userOwn.status = 2
                        completed(userOwn)
                    }
                    if (diff.type == .removed) {
                        let userOwn = UserOwnBudget(dataMap: diff.document.data())
                        userOwn.status = -1
                        completed(userOwn)
                    }
                }
            })
    }
    
    public func getBudgetEditors(budget_gid:String, completed: @escaping (BudgetEditor)->Void, not_found: @escaping (String)->Void ) -> ListenerRegistration {
        
        return self.dbReference.collection(BUDGET_EDITORS)
            .whereField("budgetGid", isEqualTo: budget_gid)
            .addSnapshotListener({documentSnapshot, error in
                
                guard let snapshot = documentSnapshot else {
                    
                    not_found("Error fetching snapshots: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        
                        let editor = BudgetEditor(dataMap: diff.document.data())
                        editor.status = 1
                        completed(editor)
                        
                    }
                    if (diff.type == .modified) {
                        
                        let editor = BudgetEditor(dataMap: diff.document.data())
                        editor.status = 2
                        completed(editor)
                    }
                    if (diff.type == .removed) {
                       
                        let editor = BudgetEditor(dataMap: diff.document.data())
                        editor.status = -1
                        completed(editor)
                    }
                }
                
                
            })
        
    }
    

    
    public func removeEditor(editorGid:String) {
        
        self.dbReference.collection(BUDGET_EDITORS).document(editorGid).delete()
        
        
    }
    
    public func removeBudgetFromUser(userBudgetGid:String) {
        
        self.dbReference.collection(USER_OWN_BUDGETS).document(userBudgetGid).delete()
        
    }

    
    /** public func get(:budget_gid: String) **/
    public func get(_ budget_gid: String, completed: @escaping (Budget)->Void, not_found: @escaping (String)->Void ) {
        
        self.dbReference.collection(BUDGETS).document(budget_gid).getDocument( completion: { (docQuery, error) in
            
                if let budget = docQuery.flatMap({
                    $0.data().flatMap({ (data) in
                        return Budget(value: data)
                    })
                }) {
                    
                    
                    completed(budget)
                } else {
                    
                    not_found("Document does not exist")
                }
        })
            

    }
    
    public func getSync(_ budget_gid: String, completed: @escaping (Budget)->Void, not_found: @escaping (String)->Void ) -> ListenerRegistration {
        
        return self.dbReference.collection(BUDGETS)
            .whereField("gid", isEqualTo: budget_gid)
            .addSnapshotListener({documentSnapshot, error in
                

                guard let snapshot = documentSnapshot else {
                    
                    not_found("Error fetching snapshots: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                    
                        let budget = Budget(value: diff.document.data())
                        budget.status = 1
                        completed(budget)
                        
                    }
                    if (diff.type == .modified) {
                       
                        let budget = Budget(value: diff.document.data())
                        budget.status = 2
                        completed(budget)
                    }
                    if (diff.type == .removed) {
                        
                        let budget = Budget(value: diff.document.data())
                        budget.status = -1
                        completed(budget)
                    }
                }
                
                
            })
        
        
    }
    
    
    
    /** public func delete(:budget_gid: String) **/
    public func delete(_ budget: Budget, cleanUpCompleted: @escaping (Int)->Void) {
        
        
        self.dbReference.collection(BUDGETS).document(budget.gid).delete()
        cleanUpCompleted(1)
        
    }

    
    
    public func firstThree(listBudgets: [Budget]) -> [Budget] {
        
        var first3Return:[Budget] = []
       
        for i in 0 ..< 3 {
            first3Return.append(listBudgets[i])
        }
        
        return first3Return
            
    }
    
    public func fisterActives(listBudgets: [Budget]) -> [Budget] {
        
        var first3Return:[Budget] = []
        
        for budget in listBudgets {
            if budget.active == 1 {
                first3Return.append(budget)
            }
            
        }
        
        return first3Return
    }
    
    
    /** public func updateActive() **/
    public func updateActive(_ budget_gid: String, value: Int) {
        self.dbReference.collection(USER_OWN_BUDGETS).document(budget_gid).updateData(["active":value])
    }
    
    
    public func updateLastOpened(_ budget_gid: String) {
    self.dbReference.collection(USER_OWN_BUDGETS).document(budget_gid).updateData(["last_used":Int(Date().timeIntervalSince1970), "unread": false])
    }
    
}
