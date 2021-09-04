//
//  UserFile.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/25/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//
import Firebase

public class UserFile {
    public var gid: String!
    public var user_gid: String!
    public var filePath: String!
    public var name: String!
    public var filename: String!
    public var active: Int!
    public var restore: Bool!
    public var status: Int!
    public var insert_date: Int!
    public var last_update: Int!

    public init() {
        self.gid = ""
        self.user_gid = ""
        self.filePath = ""
        self.name = ""
        self.filename = ""
        self.active = 0
        self.restore = false
        self.insert_date = 0
        self.last_update = 0
    }
    /*
    public init(snapshot: DataSnapshot!) {
        let value = snapshot.value as? NSDictionary
        self.gid = value?["gid"] as? String ?? ""
        self.user_gid = value?["user_gid"] as? String ?? ""
        self.filePath = value?["filePath"] as? String ?? ""
        self.name = value?["name"] as? String ?? ""
        self.filename = value?["filename"] as? String ?? ""
        self.active = value?["active"] as? Int ?? 0
        self.restore = value?["restore"] as? Bool ?? false
        self.insert_date = value?["insert_date"] as? Int ?? 0
        self.last_update = value?["last_update"] as? Int ?? 0
    }*/
    public init(dataMap: [String:Any]) {
        self.gid = dataMap["gid"] as? String ?? ""
        self.user_gid = dataMap["user_gid"] as? String ?? ""
        self.filePath = dataMap["filePath"] as? String ?? ""
        self.name = dataMap["name"] as? String ?? ""
        self.filename = dataMap["filename"] as? String ?? ""
        self.active = dataMap["active"] as? Int ?? 0
        self.restore = dataMap["restore"] as? Bool ?? false
        self.insert_date = dataMap["insert_date"] as? Int ?? 0
        self.last_update = dataMap["last_update"] as? Int ?? 0
    }
    public func toAnyObject() -> NSDictionary {
        return [
        "gid": self.gid as String,
        "user_gid": self.user_gid as String,
        "filePath": self.filePath as String,
        "name": self.name as String,
        "filename": self.filename as String,
        "active": self.active as Int,
        "restore": self.restore as Bool,
        "insert_date": self.insert_date as Int,
        "last_update": self.last_update as Int,
        ]
    }
}
