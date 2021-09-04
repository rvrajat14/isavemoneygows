//
//  ContributorTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 4/28/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import ISMLBase
import TinyConstraints

class ContributorTableViewCell: UITableViewCell {

    var labelNameTag: SmallTextLabel!
    var labelName: NormalTextLabel!
    var stackViewWrapper: UIStackView!
    var flavor:Flavor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clear
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectionStyle = .none
        // Configure the view for the selected state
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
       
        backgroundColor = .clear
        
        labelNameTag = {
            let label = SmallTextLabel()
            return label
        }()
        labelName = {
            let label = NormalTextLabel()
            return label
        }()
        
        self.addSubview(labelName)
        self.addSubview(labelNameTag)
        
        labelName.edgesToSuperview(excluding: .bottom, insets: .top(10) + .left(10) + .right(10), usingSafeArea: true)
        labelNameTag.topToBottom(of: labelName)
        labelNameTag.leftToSuperview(offset: 10)
        labelNameTag.rightToSuperview(offset: 10)
        labelNameTag.bottomToSuperview(offset: -10)
        
    
    }

}
