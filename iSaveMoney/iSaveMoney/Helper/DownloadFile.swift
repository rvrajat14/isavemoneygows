//
//  DownloadFile.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 3/22/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit

class DownloadFile {
    
    func load(URL: NSURL, fileType:String, listener: @escaping ((URL)->Void)) {
        
        
        // Create destination URL
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        let destinationFileUrl = documentsUrl.appendingPathComponent("build-csv-file-\(Int(Date().timeIntervalSince1970))." + fileType)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        var request = URLRequest(url: URL as URL)
        request.httpMethod = "GET"
       
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                
                print("Temp url \(tempLocalUrl.absoluteURL)")
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    print("Temp url \(destinationFileUrl.absoluteURL)")
                    
                    listener(destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
                
            }
        }
        task.resume()
    }
}
