//
// FbUser.swift
// iSaveMoney
//
// Created by Armel Koudoum on 1/15/17.
// Copyright © 2017 UlmatCorpit. All rights reserved.
//
import Firebase
import FirebaseFirestore
import ISMLBase

public class FbSchedule{
    let dbReference: Firestore
    let SCHEDULES = Environment.ENVIRONEMENT+"schedules"
    
    
    
    /** public init(reference: DatabaseReference) **/
    public init() {
        self.dbReference = Firestore.firestore()
    }
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    /** public func write() **/
    public func write(_ schedule: Schedule, completion: @escaping (Schedule)->Void, error_message: @escaping (String)->Void) {
        
        let scheduleRef = self.dbReference.collection(SCHEDULES).document()
        schedule.gid = scheduleRef.documentID
        
        scheduleRef.setData(schedule.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create schedule. \(error)")
                }else{
                    completion(schedule)
                }
                
            })
    }
    
    public func write(_ schedule: Schedule) {
        
        let scheduleRef = self.dbReference.collection(SCHEDULES).document()
        schedule.gid = scheduleRef.documentID
        
        scheduleRef.setData(schedule.toAnyObject() as! [String : Any])
    }
    
    
    /** public func update(:schedule) **/
    public func update(_ schedule: Schedule, completion: @escaping (Schedule)->Void, error_message: @escaping (String)->Void){
        
        self.dbReference
            .collection(SCHEDULES)
            .document(schedule.gid)
            .updateData(schedule.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to update schedule. \(error)")
                }else{
                    completion(schedule)
                }
                
            })
    }

    public func update(_ schedule: Schedule){
        
        self.dbReference
            .collection(SCHEDULES)
            .document(schedule.gid)
            .updateData(schedule.toAnyObject() as! [String : Any])
    }
    
    
    public func get(forId gid: String, listener: @escaping (Schedule) -> Void, error_message: @escaping (String)->Void) {
        
        self.dbReference.collection(SCHEDULES).document(gid).getDocument( completion: { (scheduleDoc, error) in
            
            if let schedule = scheduleDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return Schedule(dataMap: data)
                })
            }) {
                print("schedule: \(schedule)")
                listener(schedule)
            } else {
                print("Unable to load the schedule")
                error_message("Unable to load the schedule. \(gid)")
            }
            
        })
    }
    
    
    
    /** public func delete(:schedule_gid: String) **/
    public func delete(_ schedule_gid: String) {
        
        self.dbReference.collection(SCHEDULES).document(schedule_gid).delete()
    }
    
    public func getFor(entityId id:String, _ schedule_gid:String, complete: @escaping ([Schedule])->Void, error_message: @escaping (FbError)->Void){
        let query = self.dbReference.collection(SCHEDULES)
        .whereField("gid", isEqualTo: id)
        getDocument(query: query, complete: complete, error_message: error_message)
      
    }
    
    
    public func getForUserschedule(_ userGid: String, complete: @escaping ([Schedule])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(SCHEDULES)
            .whereField("user_gid", isEqualTo: userGid)
            
        getDocument(query: query, complete: complete, error_message: error_message)
    }


    public func listenByGid(userGid gid:String,
        adding: @escaping (Schedule)->Void,
        remove: @escaping (Schedule)->Void,
        error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        let query = self.dbReference.collection(SCHEDULES)
            .whereField("gid", isEqualTo: gid)
            
        return entityListener(query: query,
        adding: adding,
        remove: remove,
        error_message: error_message)
    }
    
    public func listenByUser(userGid gid:String,
        adding: @escaping (Schedule)->Void,
        remove: @escaping (Schedule)->Void,
        error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        let query = self.dbReference.collection(SCHEDULES)
            .whereField("user_gid", isEqualTo: gid)
            
        return entityListener(query: query,
        adding: adding,
        remove: remove,
        error_message: error_message)
    }


    private func getDocument(query: Query, complete: @escaping ([Schedule])->Void, error_message: @escaping (FbError)->Void){

          query.getDocuments(completion: { (schedulesDocs, error)  in
            
            var schedulesList = [Schedule]()
            
            if let error = error {
                
                let errorM:FbError = FbError()
                errorM.errorCode = 101
                errorM.errorMessage = "Error getting schedules: \(error)"
                error_message(errorM)
            } else {
                
                for document in schedulesDocs!.documents {
                    
                    schedulesList.append(Schedule(dataMap: document.data()))
                    
                }
                
                complete(schedulesList)
            }
            
        })
    }

    private func entityListener(query: Query,
                                adding: @escaping (Schedule)->Void,
                                remove: @escaping (Schedule)->Void,
                                error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        return query.addSnapshotListener({querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                let errorM:FbError = FbError()
                errorM.errorCode = 101
                errorM.errorMessage = "Error fetching documents: \(error!)"
                error_message(errorM)
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    
                    let schedule = Schedule(dataMap: diff.document.data())
                    adding(schedule)
                    
                }
                if (diff.type == .modified) {
                    
                    let schedule = Schedule(dataMap: diff.document.data())
                    
                    adding(schedule)
                }
                if (diff.type == .removed) {
                    
                    let schedule = Schedule(dataMap: diff.document.data())
                    remove(schedule)
                }
            }
        })
    }
   

}
