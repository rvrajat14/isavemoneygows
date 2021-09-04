//
//  NiceImageView.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/24/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit

public class NiceImageView: UIImageView {

    public override init(image: UIImage?) {
        super.init(image: image)
        
        
        //let imageArrow = UIImage(named: "right_chevron")
        self.image = image
        self.alpha = 0.5
        self.image = image!.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor.gray
        self.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
    }

}
