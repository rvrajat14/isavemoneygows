//
//  IsmCardView.swift
//  ISMLBase
//
//  Created by ARMEL KOUDOUM on 10/30/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import UIKit
import Darwin

public class IsmCardView: UIView {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.backgroundColor = UIColor(named: "cardBackgroundColor")?.cgColor
        self.layer.cornerRadius = 5
        
       
        
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.backgroundColor = UIColor(named: "cardBackgroundColor")?.cgColor
        self.layer.cornerRadius = 5
    }
    
    
    

}
