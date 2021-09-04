//
//  CFPHeaderTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/16/18.
//  Copyright © 2018 UlmatCorpit. All rights reserved.
//

import TinyConstraints
import ISMLBase

class HeaderTableViewCell: UITableViewCell {
    
    lazy var textEmail: NormalTextLabel! = {
        let label = NormalTextLabel()
        label.text = NSLocalizedString("drawerMyAccount", comment: "My account")
        label.textAlignment = .left
        return label
    }()
    
    lazy var imgIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = dropDownImage
        dropDownImage = dropDownImage!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "tintIconsColor")
        return imageView
    }()
    
    lazy var emailStack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [textEmail, imgIndicator])
        s.axis = .horizontal
        s.distribution = .equalSpacing
        s.spacing = 6
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    
    lazy var imgLogo: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "isavemoney")
        imageView.image = image
        imageView.width(50)
        imageView.height(50)
        imageView.setCompressionResistance(.defaultHigh, for: .horizontal)
        imageView.setCompressionResistance(.defaultHigh, for: .vertical)
        imageView.setHugging(.defaultHigh, for: .horizontal)
        imageView.setHugging(.defaultHigh, for: .vertical)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    
    lazy var textAppName: HeaderLevelThree = {
        let label = HeaderLevelThree()
        label.text = NSLocalizedString("drawerAppName", comment: "App name")
        return label
    }()
    
    lazy var textSlogan: SmallTextLabel = {
        let label = SmallTextLabel()
        label.text = NSLocalizedString("drawerAppSlogan", comment: "Slogan")
        return label
    }()
    
    lazy var stackOfAppNameSlogan: UIStackView = {
        let s = UIStackView(arrangedSubviews: [textAppName, textSlogan])
        s.axis = .vertical
        s.alignment = UIStackView.Alignment.center
        s.distribution = UIStackView.Distribution.fill
        s.spacing = 6
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textAppName.leftToSuperview()
        textSlogan.leftToSuperview()
        return s
    }()
    
    
    lazy var logoStack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [imgLogo, stackOfAppNameSlogan])
        s.axis = .horizontal
        s.alignment = .center
        s.distribution = UIStackView.Distribution.fill
        s.spacing = 6
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    
    
    lazy var separator_1: UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor(named: "seperatorColor")
        sep.height(1)
        return sep
    }()
    
    lazy var stackOfWiews:UIStackView = {
        let s = UIStackView(arrangedSubviews: [ logoStack, emailStack, separator_1])
        s.axis = .vertical
        s.distribution = .equalSpacing
        s.spacing = 16
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return s
    }()
    
    //var drawerBackgroundImage:UIImageView!
    var flavor:Flavor!
    
    var dropDownImage = UIImage(named: "dropdown_white")
    var dropUpImage = UIImage(named: "dropup_white")
    
   
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
        //self.backgroundColor = mmChrome.WHITE
        dropUpImage = dropUpImage!.withRenderingMode(.alwaysTemplate)

        addSubview(stackOfWiews)
        
        stackOfWiews.edgesToSuperview(insets: .top(20) + .left(15) + .right(10) + .bottom(5), usingSafeArea: true)
        
    }
    
}

