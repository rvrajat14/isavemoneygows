//
//  FbLabel.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/12/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import Firebase
import FirebaseDatabase
import FirebaseFirestore

public class FbLabel {
    let dbReference: Firestore
    let LABELS = Const.ENVIRONEMENT+"labels"
    
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    public func makeKey() -> String {
        return ""
        //return self.dbReference.child((LABELS)).childByAutoId().key!
    }
    
    public func writeDico(_ labels: [AnyHashable : Any]) {
        
        //self.dbReference.child("\(LABELS)").updateChildValues(labels)
        
    }
    
    /** public func write(Label) **/
    public func write(_ label: Label) -> String {
        
        /*let key = self.dbReference.child((LABELS)).childByAutoId().key!
        label.gid = key
        let labelDitionary = label.toAnyObject()
        let childUpdates = ["/\(LABELS)/\(key)": labelDitionary]
        self.dbReference.updateChildValues(childUpdates)*/
        
        return ""//key
    }
    
    
    
    /** public func update(:Label) **/
    public func update(_ label: Label) -> String {
        
        let labelDitionary = label.toAnyObject()
        let childUpdates = ["/\(LABELS)/\(label.gid!)": labelDitionary]
        //self.dbReference.updateChildValues(childUpdates)
        
        return label.gid
    }
    
    
    public func get(label_gid:String, listener: @escaping (Label) -> Void) {
        
        /*self.dbReference.child("\(LABELS)/\(label_gid)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.value != nil {
                
                listener(Label(snapshot: snapshot))
            } else {
                listener(Label())
            }
            
        })*/
        
    }
    
    public func getListForUsers(userGid: String, listener: @escaping ([Label])-> Void) {
        
        var labels:[Label] = []
        /*self.dbReference.child(LABELS).child("\(LABELS)").queryOrdered(byChild: "user_gid").queryEqual(toValue: userGid).observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                
                labels.append(Label(snapshot: child as? DataSnapshot))
                
            }
        })*/
        
    }
    
    public func keepSync(_ label_gid: String, status: Bool) {
        /*
        if Utils.validString(val: label_gid) {
            self.dbReference.child("\(LABELS)/\(label_gid)").keepSynced(status)
        }*/
        
    }
    
    /** public func delete(:Label: String) **/
    public func delete(_ label: Label) {
        /*
        if Utils.validString(val: label.gid!) {
            self.dbReference.child("\(LABELS)/\(label.gid!)").removeValue()
        }*/
        
    }
    
    
}
