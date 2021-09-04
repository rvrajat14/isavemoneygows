//
//  FbUserFile.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/28/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import ISMLBase

public class FbUserFile {
    
    let dbReference: Firestore
    let USER_FILE = Const.ENVIRONEMENT+"backup_files"
    
    /* public init */
    public init(reference: Firestore) {
        
        self.dbReference = reference
    }
    
    
    
    /** Write **/
    public func write(_ userFile: UserFile, completion: @escaping (UserFile)->Void, error_message: @escaping (String)->Void) {
        
        let userFileRef = self.dbReference.collection(USER_FILE).document()
        userFile.gid = userFileRef.documentID
        self.dbReference
            .collection(USER_FILE)
            .document(userFile.gid)
            .setData(userFile.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create the userFile. \(error)")
                }else{
                    completion(userFile)
                }
                
            })
        
    }
    
    
    
    /** public func update(:UserFile) **/
    public func update(_ userFile: UserFile , completion: @escaping (UserFile)->Void, error_message: @escaping (String)->Void){
        self.dbReference
            .collection(USER_FILE)
            .document(userFile.gid)
            .updateData(userFile.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create the userFile. \(error)")
                }else{
                    completion(userFile)
                }
                
            })
    }
    
    
    
 
    public func get(gid:String, listener: @escaping (UserFile) -> Void, error_message: @escaping (String)->Void) {
        
    
        self.dbReference.collection(USER_FILE).document(gid).getDocument(completion: { (userDoc, error) in
            
            
            if let userFile = userDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return UserFile(dataMap: data)
                })
            }) {
                
                listener(userFile)
            } else {
                print("Unable to load the userFile")
                error_message("Unable to load the userFile. \(gid)")
            }
            
        })
        
    }
    
    
    public func delete(_ userFile: UserFile) {
        
       self.dbReference.collection(USER_FILE).document(userFile.gid).delete()
        
    }
    
    
    
    
    
    public func getBySync(_ attr_name: String,
                   attr_val: String,
                        complete: @escaping (UserFile)->Void,
                        error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        return self.dbReference.collection(USER_FILE)
            .whereField(attr_name, isEqualTo: attr_val)
            .addSnapshotListener({querySnapshot, error in
                
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
                        
                        let userFile = UserFile(dataMap: diff.document.data())
                        userFile.status = 1
                        complete(userFile)
                        
                    }
                    if (diff.type == .modified) {
                        
                        let userFile = UserFile(dataMap: diff.document.data())
                        userFile.status = 2
                        complete(userFile)
                    }
                    if (diff.type == .removed) {
                        
                        let userFile = UserFile(dataMap: diff.document.data())
                        userFile.status = -1
                        complete(userFile)
                    }
                }
                
                
                
            })
        
        
    }
        
    
    
}
