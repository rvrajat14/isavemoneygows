//
//  TxtImageView.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/24/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit

public class TxtImageView: UIImageView {
    
    public override init(image: UIImage?) {
        super.init(image: image)
        
        
        //let imageArrow = UIImage(named: "right_chevron")
        self.image = image
        self.image = image!.withRenderingMode(.alwaysTemplate)
        self.tintColor = mmChrome.LIGHT_GREY
        self.frame = CGRect(x: 5, y: 0, width: 24, height: 24)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
    }
    
}
