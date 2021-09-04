//
//  LabelTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/14/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import ISMLBase

class LabelTableViewCell: UITableViewCell {

    var labelImage:UIImageView!
    var textTitle:UILabel!
    var viewsWraper:UIStackView!
    var bottomLine:UIView!
    
    var contentWrapper:UIStackView!
    
    var flavor:Flavor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

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
        
        labelImage = {
            let image = UIImage(named: "alarm_on")
            let imageView = UIImageView()
            imageView.image = image
            
            return imageView
        }()
        
        textTitle = {
            let label = UILabel()
            label.text = "Description"
            label.textAlignment = .left
            label.textColor = Const.greyDarkColor
            label.font = UIFont(name: "Lato-Heavy", size: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        viewsWraper = {
            let s = UIStackView(arrangedSubviews: [labelImage, textTitle])
            s.axis = .horizontal
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 6
            s.translatesAutoresizingMaskIntoConstraints = false
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
        labelImage.leadingAnchor.constraint(equalTo: viewsWraper.leadingAnchor).isActive = true
        labelImage.topAnchor.constraint(equalTo: viewsWraper.topAnchor).isActive = true
        labelImage.bottomAnchor.constraint(equalTo: viewsWraper.bottomAnchor).isActive = true
        textTitle.trailingAnchor.constraint(equalTo: viewsWraper.trailingAnchor).isActive = true
        textTitle.leadingAnchor.constraint(equalTo: labelImage.trailingAnchor).isActive = true
        
        bottomLine = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = Const.grayBackground
            v.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return v
        }()
        
        contentWrapper = {
            
            let s = UIStackView(arrangedSubviews: [viewsWraper, bottomLine])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 6
            s.translatesAutoresizingMaskIntoConstraints = false
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
        bottomLine.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 0).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: 0).isActive = true
        
        
        self.addSubview(contentWrapper)
        
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        contentWrapper.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        contentWrapper.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        contentWrapper.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        self.layer.backgroundColor = UIColor.clear.cgColor
    }

}
