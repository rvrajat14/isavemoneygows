//
//  FbMigrationRequest.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 9/24/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

public class FbMigrationRequest {
    
    let dbReference: Firestore
    let MIGRATIONS = Const.ENVIRONEMENT+"requests"
    
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    
    public func write(_ migrate: MigrationRequest, completion: @escaping (MigrationRequest)->Void, error_message: @escaping (String)->Void) {
        
       let migrateRef = self.dbReference.collection(MIGRATIONS).document()
       migrate.gid = migrateRef.documentID
       
       self.dbReference
           .collection(MIGRATIONS)
           .document(migrate.gid)
           .setData(migrate.toAnyObject() as! [String : Any], completion: {(error) in
               if let error = error {
                   error_message("Unable to create migrate. \(error)")
               }else{
                   completion(migrate)
               }
               
           })
    }
    
    
}
