//
//  ValidatePuchase.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/17/20.
//

import Foundation

public class ValidatePuchase {
    public static func validate(callback: @escaping (([Any]) -> (Void))) {
        let pref = AccessPref()
        
       
        let userId = pref.getStringVal(forKey: AccessPref.PREF_USER_IDENTIFIER, defVal: "")
        print("Check user order \(userId)")
        if userId == "" {
            print("Check user order : No user id found")
            //make a server check with user id
            pref.setBoolVal(val: false, forKey: AccessPref.IS_USER_PREMIUM)
            callback([])
            return
        }
        
        
        print("Check user order start")
        if pref.isProAccount() {
            print("Check user order : is Pro already")
            verifyOrder(userId: userId, callback: callback)
            return
        }
        
        
        // get receipr info
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            
            let rawReceiptData = try! Data(contentsOf: appStoreReceiptURL)
            let receiptData = rawReceiptData.base64EncodedString()
            
            print("Here is my receipt \(receiptData)")
            //let requestData: [String: Any] = ["receiptPurchase": receiptData]
            let requestData: [String: Any] = ["receiptPurchase": receiptData, "userId": userId]
            let httpBody = try! JSONSerialization.data(withJSONObject: requestData, options: [])
            
            //let url = "https://buy.itunes.apple.com/verifyReceipt"
            //https://us-central1-isavemoney-1214.cloudfunctions.net/verifyPurchaseIos
            let url = URL(string: "https://us-central1-isavemoney-1214.cloudfunctions.net/verifyPurchaseIos")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                guard let _: Data = data, let _: URLResponse = response, error == nil else {
                    print("*****error")
                    return
                }
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let dataResult:[String:Any] =  parseStringToJson(jsonText: dataString! as String)
                let status = dataResult["status"] as? Bool ?? false
                pref.setBoolVal(val: status, forKey: AccessPref.IS_USER_PREMIUM)
                if(status) {
                    callback(dataResult["orders"] as! [Any])
                }else{
                    callback([])
                }
                print("My reponse Here \(dataResult)  \(status)")
                
            }.resume()
            print("Receipt \(receiptData)")
        }else{
            print("Check user order No receipt found")
            pref.setBoolVal(val: false, forKey: AccessPref.IS_USER_PREMIUM)
            //make a server check with user id always
            verifyOrder(userId: userId, callback: callback)
            
        }
    }
    
    
    public static func verifyOrder(userId: String, callback: @escaping (([Any]) -> (Void))) {
        let pref = AccessPref()
        let requestData: [String: Any] = ["userId": userId]
        let httpBody = try! JSONSerialization.data(withJSONObject: requestData, options: [])
        let url = URL(string: "https://us-central1-isavemoney-1214.cloudfunctions.net/iosCheckUserOrder")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let dataResult:[String:Any] =  parseStringToJson(jsonText: dataString! as String)
            let status = dataResult["status"] as? Bool ?? false
            pref.setBoolVal(val: status, forKey: AccessPref.IS_USER_PREMIUM)
            if(status) {
                callback(dataResult["orders"] as! [Any])
            }else{
                callback([])
            }
            
            print("My reponse Here \(dataResult)  \(status)")
            
        }.resume()
    }
    
    public static func parseStringToJson(jsonText:String) -> [String:Any] {
        var dictonary:[String:Any] = [:]
        
        if let data = jsonText.data(using: String.Encoding.utf8) {
            //as? [String:AnyObject]!
            do {
                dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] ?? [:]
                
                
            } catch let error as NSError {
                print(error)
            }
        }
        
        return dictonary//["status"]! as! Bool ?? false
    }
}
