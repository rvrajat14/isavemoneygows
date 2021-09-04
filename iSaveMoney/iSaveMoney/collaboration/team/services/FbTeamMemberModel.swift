//
//  FbTeamMemberModel.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/7/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import Firebase
import FirebaseFirestore
import ISMLBase

public class FbTeamMember{
    let dbReference: Firestore
    let TEAM_MEMBERS = Environment.ENVIRONEMENT+"team_members"
    
    
    
    /** public init(reference: DatabaseReference) **/
    public init() {
        self.dbReference = Firestore.firestore()
    }
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    /** public func write() **/
    public func write(_ teammembermodel: TeamMemberModel, completion: @escaping (TeamMemberModel)->Void, error_message: @escaping (String)->Void) {
        
        let teammembermodelRef = self.dbReference.collection(TEAM_MEMBERS).document()
        teammembermodel.gid = teammembermodelRef.documentID
        
        teammembermodelRef.setData(teammembermodel.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create teammembermodel. \(error)")
                }else{
                    completion(teammembermodel)
                }
                
            })
    }
    
    public func write(_ teammembermodel: TeamMemberModel) {
        
        let teammembermodelRef = self.dbReference.collection(TEAM_MEMBERS).document()
        teammembermodel.gid = teammembermodelRef.documentID
        
        teammembermodelRef.setData(teammembermodel.toAnyObject() as! [String : Any])
    }
    
    
    /** public func update(:teammembermodel) **/
    public func update(_ teammembermodel: TeamMemberModel, completion: @escaping (TeamMemberModel)->Void, error_message: @escaping (String)->Void){
        
        self.dbReference
            .collection(TEAM_MEMBERS)
            .document(teammembermodel.gid)
            .updateData(teammembermodel.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to update teammembermodel. \(error)")
                }else{
                    completion(teammembermodel)
                }
                
            })
    }

    public func update(_ teammembermodel: TeamMemberModel){
        
        self.dbReference
            .collection(TEAM_MEMBERS)
            .document(teammembermodel.gid)
            .updateData(teammembermodel.toAnyObject() as! [String : Any])
    }
    
    
    public func get(forId gid: String, listener: @escaping (TeamMemberModel) -> Void, error_message: @escaping (String)->Void) {
        
        self.dbReference.collection(TEAM_MEMBERS).document(gid).getDocument( completion: { (teammembermodelDoc, error) in
            
            if let teammembermodel = teammembermodelDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return TeamMemberModel(dataMap: data)
                })
            }) {
                print("teammembermodel: \(teammembermodel)")
                listener(teammembermodel)
            } else {
                print("Unable to load the teammembermodel")
                error_message("Unable to load the teammembermodel. \(gid)")
            }
            
        })
    }
    
    
    
    /** public func delete(:teammembermodel_gid: String) **/
    public func delete(_ teammembermodel_gid: String) {
        
        self.dbReference.collection(TEAM_MEMBERS).document(teammembermodel_gid).delete()
    }
    
    public func getFor(entityId id:String, _ teammembermodel_gid:String, complete: @escaping ([TeamMemberModel])->Void, error_message: @escaping (FbError)->Void){
        let query = self.dbReference.collection(TEAM_MEMBERS)
        .whereField("gid", isEqualTo: id)
        getDocument(query: query, complete: complete, error_message: error_message)
      
    }
    
    
    public func getForUserteammembermodel(_ userGid: String, complete: @escaping ([TeamMemberModel])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(TEAM_MEMBERS)
            .whereField("user_gid", isEqualTo: userGid)
            
        getDocument(query: query, complete: complete, error_message: error_message)
    }


    public func listenByGid(userGid gid:String,
        adding: @escaping (TeamMemberModel)->Void,
        remove: @escaping (TeamMemberModel)->Void,
        error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        let query = self.dbReference.collection(TEAM_MEMBERS)
            .whereField("gid", isEqualTo: gid)
            
        return entityListener(query: query,
        adding: adding,
        remove: remove,
        error_message: error_message)
    }
    
    public func listenByGid(teamGid gid:String,
        adding: @escaping (TeamMemberModel)->Void,
        remove: @escaping (TeamMemberModel)->Void,
        error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        let query = self.dbReference.collection(TEAM_MEMBERS)
            .whereField("teamID", isEqualTo: gid)
            
        return entityListener(query: query,
        adding: adding,
        remove: remove,
        error_message: error_message)
    }


    private func getDocument(query: Query, complete: @escaping ([TeamMemberModel])->Void, error_message: @escaping (FbError)->Void){

          query.getDocuments(completion: { (teammembermodelsDocs, error)  in
            
            var teammembermodelsList = [TeamMemberModel]()
            
            if let error = error {
                
                let errorM:FbError = FbError()
                errorM.errorCode = 101
                errorM.errorMessage = "Error getting teammembermodels: \(error)"
                error_message(errorM)
            } else {
                
                for document in teammembermodelsDocs!.documents {
                    
                    teammembermodelsList.append(TeamMemberModel(dataMap: document.data()))
                    
                }
                
                complete(teammembermodelsList)
            }
            
        })
    }

    private func entityListener(query: Query,
                                adding: @escaping (TeamMemberModel)->Void,
                                remove: @escaping (TeamMemberModel)->Void,
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
                    
                    let teammembermodel = TeamMemberModel(dataMap: diff.document.data())
                    adding(teammembermodel)
                    
                }
                if (diff.type == .modified) {
                    
                    let teammembermodel = TeamMemberModel(dataMap: diff.document.data())
                    
                    adding(teammembermodel)
                }
                if (diff.type == .removed) {
                    
                    let teammembermodel = TeamMemberModel(dataMap: diff.document.data())
                    remove(teammembermodel)
                }
            }
        })
    }
   

}
