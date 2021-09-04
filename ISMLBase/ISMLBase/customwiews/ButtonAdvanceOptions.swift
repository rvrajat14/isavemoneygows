//
//  ButtonAdvanceOptions.swift
//  ISMLBase
//
//  Created by ARMEL KOUDOUM on 12/5/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import Foundation
import UIKit

public class ButtonAdvanceOptions: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clear //UIColor(named: "buttonBgColor")
        //self.layer.cornerRadius = 5
        self.setTitleColor(UIColor(named: "buttonBgColor"), for: .normal)
        //var image = UIImage(named: "arrow_outline")
        // self.addExpenseButton.imageView?.contentMode = .scaleAspectFit
        self.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.tintColor = UIColor(named: "buttonBgColor")
        self.titleLabel?.font = UIFont(name: IsmFontFamily.DmsansRegular, size: IsmDimems.normal_text_size)
        self.contentHorizontalAlignment = .left
        //self.height(IsmDimems.textEditHeightSize)
       
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 5) // left: (bounds.width - 35)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0) // (imageView?.frame.width)!
        }
    }
}
