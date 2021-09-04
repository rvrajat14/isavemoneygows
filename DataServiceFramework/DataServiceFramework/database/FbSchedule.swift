//
// FbUser.swift
// iSaveMoney
//
// Created by Armel Koudoum on 1/15/17.
// Copyright © 2017 UlmatCorpit. All rights reserved.
//
import Firebase
import FirebaseFirestore

public class FbSchedule{
    let dbReference: Firestore
    let SCHEDULES = Const.ENVIRONEMENT+"schedules"
    
    
    
    /** public init(reference: DatabaseReference) **/
    
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    
    
    /** public func write() **/
    public func write(_ schedule: Schedule, completion: @escaping (Schedule)->Void, error_message: @escaping (String)->Void) {
        
        let scheduleRef = self.dbReference.collection(SCHEDULES).document()
        schedule.setGid(scheduleRef.documentID)
        schedule.lastOccurred = schedule.lastOccurred*1000
        
        self.dbReference
            .collection(SCHEDULES)
            .document(schedule.gid)
            .setData(schedule.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create the schedule. \(error)")
                }else{
                    completion(schedule)
                }
                
            })
    }
    
    
    
    /** public func update(:Schedule) **/
    public func update(_ schedule: Schedule, completion: @escaping (Schedule)->Void, error_message: @escaping (String)->Void) {
        
        self.dbReference
            .collection(SCHEDULES)
            .document(schedule.gid)
            .updateData(schedule.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create the schedule. \(error)")
                }else{
                    completion(schedule)
                }
                
            })
    }
    

    public func get(_ schedule_gid: String, listener: @escaping (Schedule) -> Void, error_message: @escaping (String)->Void) {
        
        self.dbReference.collection(SCHEDULES).document(schedule_gid).getDocument( completion: { (scheduleDoc, error) in
            
            
            if let schedule = scheduleDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return Schedule(dataMap: data)
                })
            }) {
                print("Schedule: \(schedule)")
                listener(schedule)
            } else {
                print("Unable to load the schedule")
                error_message("Unable to load the schedule. \(schedule_gid)")
            }
            
        })
        
        
    }
    

    
    /** public func delete(:schedule_gid: String) **/
    public func delete(_ schedule_gid: String) {
        
        self.dbReference.collection(SCHEDULES).document(schedule_gid).delete()
    }
    
    
    public func getByUser(_ user_gid: String, complete: @escaping ([Schedule])->Void, error_message: @escaping (FbError)->Void) {
        
        
        self.dbReference.collection(SCHEDULES)
            .whereField("user_gid", isEqualTo: user_gid)
            .getDocuments( completion: { (scheduleDocs, error)  in
                
                var schedulesList = [Schedule]()
                
                if let error = error {
                    
                    let errorM:FbError = FbError()
                    errorM.errorCode = 101
                    errorM.errorMessage = "Error getting schedule: \(error)"
                    error_message(errorM)
                } else {
                    
                    for document in scheduleDocs!.documents {
                        
                        schedulesList.append(Schedule(dataMap: document.data()))
                        
                    }
                    
                    complete(schedulesList)
                }
                
            })
    }
    
    
    
}
