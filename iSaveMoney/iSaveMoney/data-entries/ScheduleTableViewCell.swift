//
//  ScheduleTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/24/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

class ScheduleTableViewCell: UITableViewCell {
    
    var flavor:Flavor!
    
    var labelTitle:NormalTextLabel!
    var labelRecurrence:SmallTextLabel!
    var labelNextGoesOff:SmallTextLabel!
    var stateIndicatorImage:UIImageView!
    
    let scheduleOntime = UIImage(named: "schedule_ontime")
    let scheduleOff = UIImage(named: "schedule_off")
    
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
        self.backgroundColor = UIColor.clear
        labelTitle = {
            let label = NormalTextLabel()
            label.text = "Income or expense"
            return label
        }()
        
        labelRecurrence = {
            let label = SmallTextLabel()
            label.text = "Sequense: Every month"
            return label
        }()
        
        labelNextGoesOff = {
            let label = SmallTextLabel()
            label.text = "First goes off : 03/02/2017"
            return label
        }()

        
        
        stateIndicatorImage = {
            
            let imageView = UIImageView()
            imageView.image = scheduleOntime
            imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 700), for: .horizontal)
            imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 700), for: .vertical)
            imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 700), for: .horizontal)
            imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 700), for: .vertical)
            imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = Const.GREEN
            return imageView
        }()
        
        addSubview(stateIndicatorImage)
        stateIndicatorImage.leftToSuperview(offset: 10)
        stateIndicatorImage.topToSuperview(offset:10)
        
        addSubview(labelTitle)
        labelTitle.edgesToSuperview(excluding: .bottom, insets:.left(40) + .top(10) + .right(-5) + .bottom(-10))
        
        addSubview(labelRecurrence)
        labelRecurrence.leftToSuperview(offset: 40)
        labelRecurrence.topToBottom(of: labelTitle)
        addSubview(labelNextGoesOff)
        labelNextGoesOff.leftToSuperview(offset: 40)
        labelNextGoesOff.topToBottom(of: labelRecurrence)
        labelNextGoesOff.bottomToSuperview(offset: -10)
        
    }
}
