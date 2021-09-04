//
//  ItemMenuTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 11/10/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

class ItemMenuTableViewCell: UITableViewCell {
    
    var rightArrowImage = UIImage(named: "arrow")
    
    lazy var textTitle:MediumTextLabel = {
        let label = MediumTextLabel()
        label.text = "My account"
        label.textAlignment = .left
        return label
    }()
    
    lazy var imgIndicator:UIImageView = {
        let imageView = UIImageView()
        imageView.image = rightArrowImage
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "tintIconsColor")
        return imageView
    }()
    
    lazy var leftIcon:UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = rightArrowImage
        imageView.setCompressionResistance(.defaultHigh, for: .horizontal)
        imageView.setCompressionResistance(.defaultHigh, for: .vertical)
        imageView.setHugging(.defaultHigh, for: .horizontal)
        imageView.setHugging(.defaultHigh, for: .vertical)
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "tintIconsColor")
        return imageView
    }()
    

    
    lazy var separator_1:UIView =  {
        let sep = UIView()
        sep.backgroundColor = UIColor(named: "seperatorColor")
        sep.height(1)
        return sep
    }()
    
    lazy var stackOfWiews:UIStackView = {
        let s = UIStackView(arrangedSubviews: [leftIcon, textTitle, imgIndicator])
        s.axis = .horizontal
        s.distribution = UIStackView.Distribution.fill
        s.alignment = .center
        s.spacing = 12
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
        return s
    }()
    
    var flavor:Flavor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
        addSubview(stackOfWiews)
        addSubview(separator_1)
        stackOfWiews.edgesToSuperview(insets: .left(0) + .top(10) + .left(15) + .bottom(10), usingSafeArea: true)
        separator_1.edgesToSuperview(excluding: .top, insets: .left(15) + .right(10))

    }

}
