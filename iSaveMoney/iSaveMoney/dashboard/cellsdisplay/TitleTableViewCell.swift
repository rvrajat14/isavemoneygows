//
//  TitleTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/8/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import ISMLBase

class TitleTableViewCell: UITableViewCell {

    var flavor:Flavor!
    
    var labelTitle:UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        flavor = Flavor()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        
        self.backgroundColor = mmChrome.DARK
        labelTitle = {
            let label = UILabel()
            label.text = "SPENDING CATEGORY"
            label.textAlignment = .center
            label.textColor = mmChrome.WHITE
            label.font = UIFont(name: "Lato-Bold", size: 14) //UIFont.boldSystemFont(ofSize: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        //print(UIFont.familyNames)
        for family in UIFont.familyNames {
            
            for font in UIFont.fontNames(forFamilyName: family) {
                print(font)
            }
            
        }
        self.addSubview(labelTitle)
        
        labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        labelTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        labelTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        labelTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
}
