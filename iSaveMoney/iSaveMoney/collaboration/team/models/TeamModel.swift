//
//  TeamModel.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/7/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import Firebase
import FirebaseDatabase
public class TeamModel{
    
    public var gid:String!
    public var name:String!
    public var memo:String!
    public var teamAuthor:String!
    public var ownerId:String!
    public var profileImage:String!
    public var createdDate:Int!
    public var updatedDate:Int!
    public var status:Int = 1
    
    public init() {
        
        self.gid = ""
        self.name = ""
        self.memo = ""
        self.teamAuthor = ""
        self.ownerId = ""
        self.profileImage = ""
        self.createdDate = 0
        self.updatedDate = 0
    }
    
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        
        self.gid = value?["gid"] as? String ?? ""
        self.name = value?["name"] as? String ?? ""
        self.memo = value?["memo"] as? String ?? ""
        self.teamAuthor = value?["teamAuthor"] as? String ?? ""
        self.ownerId = value?["ownerId"] as? String ?? ""
        self.profileImage = value?["profileImage"] as? String ?? ""
        self.createdDate = value?["createdDate"] as? Int ?? 0
        self.updatedDate = value?["updatedDate"] as? Int ?? 0
    }
    
    public init(dataMap: [String:Any]) {
        
        
        self.gid = dataMap["gid"] as? String ?? ""
        self.name = dataMap["name"] as? String ?? ""
        self.memo = dataMap["memo"] as? String ?? ""
        self.teamAuthor = dataMap["teamAuthor"] as? String ?? ""
        self.ownerId = dataMap["ownerId"] as? String ?? ""
        self.profileImage = dataMap["profileImage"] as? String ?? ""
        self.createdDate = dataMap["createdDate"] as? Int ?? 0
        self.updatedDate = dataMap["updatedDate"] as? Int ?? 0
    }
    
    
    public func toAnyObject() -> NSDictionary {
        return [
            
            "gid": self.gid as String,
            "name": self.name as String,
            "memo": self.memo as String,
            "teamAuthor": self.teamAuthor as String,
            "ownerId": self.ownerId as String,
            "profileImage": self.profileImage as String,
            "createdDate": self.createdDate as Int,
            "updatedDate": self.updatedDate as Int,
        ]
    }
}
