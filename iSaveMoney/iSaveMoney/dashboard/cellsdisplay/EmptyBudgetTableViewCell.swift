//
//  EmptyBudgetTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/9/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//

import Foundation
import TinyConstraints
import ISMLBase

class EmptyBudgetTableViewCell : UITableViewCell {
    
    var flavor:Flavor!
    
    lazy var emptyBudgetTitle: HeaderLevelFour = {
        let label = HeaderLevelFour()
        label.text = "Your budget looks empty? Worry not..."
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    lazy var emptyBudgetBody: NormalTextLabel = {
        let label = NormalTextLabel()
        label.text = "Use the buttons below to add categories, expenses, or incomes"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var viewsWraper: IsmCardView = {
        let vw = IsmCardView()
        //vw.height(150)
     
        let imgVw = UIImageView()
        imgVw.image = UIImage(named: "empty_wallet")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imgVw.tintColor = UIColor(named: "tintIconsColor")
        imgVw.width(40)
        imgVw.height(40)
        vw.addSubview(imgVw)
        imgVw.topToSuperview(offset: 10)
        imgVw.centerXToSuperview()
        
        vw.addSubview(emptyBudgetTitle)
        emptyBudgetTitle.topToBottom(of: imgVw, offset: 10)
        emptyBudgetTitle.leftToSuperview()
        emptyBudgetTitle.rightToSuperview()
        vw.addSubview(emptyBudgetBody)
        emptyBudgetBody.topToBottom(of: emptyBudgetTitle, offset: 10)
        emptyBudgetBody.leftToSuperview()
        emptyBudgetBody.rightToSuperview()
        emptyBudgetBody.bottomToSuperview(offset: -25)
        return vw
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        flavor = Flavor()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        
        self.backgroundColor = .clear
        self.addSubview(viewsWraper)
        viewsWraper.edgesToSuperview(excluding: .none, insets: .top(15) + .right(15) + .left(15) + .bottom(5), usingSafeArea: true)
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
    
}
