//
//  TeamMemberModel.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/7/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import Firebase
import FirebaseDatabase
public class TeamMemberModel{
    
    public var gid:String!
    public var userId:String!
    public var userWithTeamId:String!
    public var userEmail:String!
    public var fullName:String!
    public var teamID:String!
    public var JoiningDate:Int!
    public var team:TeamModel!
    
    public init() {
        
        self.gid = String()
        self.userId = String()
        self.userWithTeamId = String()
        self.userEmail = String()
        self.fullName = String()
        self.teamID = String()
        self.JoiningDate = 0
        self.team = TeamModel()
    }
    
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        
        self.gid = value?["gid"] as? String ?? String()
        self.userId = value?["userId"] as? String ?? String()
        self.userWithTeamId = value?["userWithTeamId"] as? String ?? String()
        self.userEmail = value?["userEmail"] as? String ?? String()
        self.fullName = value?["fullName"] as? String ?? String()
        self.teamID = value?["teamID"] as? String ?? String()
        self.JoiningDate = value?["JoiningDate"] as? Int ?? 0
        self.team = value?["team"] as? TeamModel ?? TeamModel()
    }
    
    public init(dataMap: [String:Any]) {
        
        
        self.gid = dataMap["gid"] as? String ?? String()
        self.userId = dataMap["userId"] as? String ?? String()
        self.userWithTeamId = dataMap["userWithTeamId"] as? String ?? String()
        self.userEmail = dataMap["userEmail"] as? String ?? String()
        self.fullName = dataMap["fullName"] as? String ?? String()
        self.teamID = dataMap["teamID"] as? String ?? String()
        self.JoiningDate = dataMap["JoiningDate"] as? Int ?? 0
        self.team = dataMap["team"] as? TeamModel ?? TeamModel()
    }
    
    
    public func toAnyObject() -> NSDictionary {
        return [
            
            "gid": self.gid as String,
            "userId": self.userId as String,
            "userWithTeamId": self.userWithTeamId as String,
            "userEmail": self.userEmail as String,
            "fullName": self.fullName as String,
            "teamID": self.teamID as String,
            "JoiningDate": self.JoiningDate as Int,
            "team": self.team.toAnyObject() as NSDictionary,
        ]
    }
}
