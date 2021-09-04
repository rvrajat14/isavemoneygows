//
//  FbTeam.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/7/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import Firebase
import FirebaseFirestore
import ISMLBase

public class FbTeamModel{
    let dbReference: Firestore
    let TEAMINFO = Environment.ENVIRONEMENT+"team"
    
    
    
    /** public init(reference: DatabaseReference) **/
    public init() {
        self.dbReference = Firestore.firestore()
    }
    public init(reference: Firestore) {
        self.dbReference = reference
    }
    
    /** public func write() **/
    public func write(_ teammodel: TeamModel, completion: @escaping (TeamModel)->Void, error_message: @escaping (String)->Void) {
        
        let teammodelRef = self.dbReference.collection(TEAMINFO).document()
        teammodel.gid = teammodelRef.documentID
        teammodel.createdDate = Int(Date().timeIntervalSince1970)
        teammodelRef.setData(teammodel.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to create teammodel. \(error)")
                }else{
                    completion(teammodel)
                }
                
            })
    }
    
    public func write(_ teammodel: TeamModel) {
        
        let teammodelRef = self.dbReference.collection(TEAMINFO).document()
        teammodel.gid = teammodelRef.documentID
        teammodel.createdDate = Int(Date().timeIntervalSince1970)
        teammodelRef.setData(teammodel.toAnyObject() as! [String : Any])
    }
    
    
    /** public func update(:teammodel) **/
    public func update(_ teammodel: TeamModel, completion: @escaping (TeamModel)->Void, error_message: @escaping (String)->Void){
        teammodel.updatedDate = Int(Date().timeIntervalSince1970)
        self.dbReference
            .collection(TEAMINFO)
            .document(teammodel.gid)
            .updateData(teammodel.toAnyObject() as! [String : Any], completion: {(error) in
                if let error = error {
                    error_message("Unable to update teammodel. \(error)")
                }else{
                    completion(teammodel)
                }
                
            })
    }

    public func update(_ teammodel: TeamModel){
        teammodel.updatedDate = Int(Date().timeIntervalSince1970)
        self.dbReference
            .collection(TEAMINFO)
            .document(teammodel.gid)
            .updateData(teammodel.toAnyObject() as! [String : Any])
    }
    
    
    public func get(forId gid: String, listener: @escaping (TeamModel) -> Void, error_message: @escaping (String)->Void) {
        
        self.dbReference.collection(TEAMINFO).document(gid).getDocument( completion: { (teammodelDoc, error) in
            
            if let teammodel = teammodelDoc.flatMap({
                $0.data().flatMap({ (data) in
                    return TeamModel(dataMap: data)
                })
            }) {
                print("teammodel: \(teammodel)")
                listener(teammodel)
            } else {
                print("Unable to load the teammodel")
                error_message("Unable to load the teammodel. \(gid)")
            }
            
        })
    }
    
    
    
    /** public func delete(:teammodel_gid: String) **/
    public func delete(_ teammodel_gid: String) {
        
        self.dbReference.collection(TEAMINFO).document(teammodel_gid).delete()
    }
    
    public func getFor(entityId id:String, _ teammodel_gid:String, complete: @escaping ([TeamModel])->Void, error_message: @escaping (FbError)->Void){
        let query = self.dbReference.collection(TEAMINFO)
        .whereField("gid", isEqualTo: id)
        getDocument(query: query, complete: complete, error_message: error_message)
      
    }
    
    
    public func getForUserteammodel(_ userGid: String, complete: @escaping ([TeamModel])->Void, error_message: @escaping (FbError)->Void) {
        
        let query = self.dbReference.collection(TEAMINFO)
            .whereField("user_gid", isEqualTo: userGid)
            
        getDocument(query: query, complete: complete, error_message: error_message)
    }


    public func listenByGid(userGid gid:String,
        adding: @escaping (TeamModel)->Void,
        remove: @escaping (TeamModel)->Void,
        error_message: @escaping (FbError)->Void) -> ListenerRegistration {
        
        let query = self.dbReference.collection(TEAMINFO)
            .whereField("ownerId", isEqualTo: gid)
            
        return entityListener(query: query,
        adding: adding,
        remove: remove,
        error_message: error_message)
    }


    private func getDocument(query: Query, complete: @escaping ([TeamModel])->Void, error_message: @escaping (FbError)->Void){

          query.getDocuments(completion: { (teammodelsDocs, error)  in
            
            var teammodelsList = [TeamModel]()
            
            if let error = error {
                
                let errorM:FbError = FbError()
                errorM.errorCode = 101
                errorM.errorMessage = "Error getting teammodels: \(error)"
                error_message(errorM)
            } else {
                
                for document in teammodelsDocs!.documents {
                    
                    teammodelsList.append(TeamModel(dataMap: document.data()))
                    
                }
                
                complete(teammodelsList)
            }
            
        })
    }

    private func entityListener(query: Query,
                                adding: @escaping (TeamModel)->Void,
                                remove: @escaping (TeamModel)->Void,
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
                    
                    let teammodel = TeamModel(dataMap: diff.document.data())
                    adding(teammodel)
                    
                }
                if (diff.type == .modified) {
                    
                    let teammodel = TeamModel(dataMap: diff.document.data())
                    
                    adding(teammodel)
                }
                if (diff.type == .removed) {
                    
                    let teammodel = TeamModel(dataMap: diff.document.data())
                    remove(teammodel)
                }
            }
        })
    }
   

}
