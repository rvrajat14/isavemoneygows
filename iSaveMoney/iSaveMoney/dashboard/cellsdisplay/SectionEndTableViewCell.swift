//
//  IncomeEndTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/8/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLBase

class SectionEndTableViewCell: UITableViewCell {
    
    var flavor:Flavor!
    

    
    lazy var bottomRoundB:BottomRoundView  = {
        let bView = BottomRoundView()
        bView.height(10)
        return bView;
    }()
    
    lazy var stackOfWiews:UIStackView = {
        let s = UIStackView(arrangedSubviews: [bottomRoundB])
        s.axis = .vertical
        s.distribution = .equalSpacing
        s.alignment = .fill
        s.spacing = 0
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    
    
    lazy var shadowView:UIView = {
        let svw = UIView()
        svw.layer.shadowColor = UIColor.black.cgColor
        svw.layer.shadowOffset = CGSize.zero
        return svw
    }()

    
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
        
        self.backgroundColor = mmChrome.WHITE
        
    
        shadowView.addSubview(stackOfWiews)
        stackOfWiews.edgesToSuperview()
        self.addSubview(shadowView)
        shadowView.edgesToSuperview(excluding: .none, insets: .top(0) + .left(15) + .right(15) + .bottom(15))
    
        
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
}
