//
//  BackupTableViewCell.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/28/20.
//  Copyright © 2020 UlmatCorpit. All rights reserved.
//

import Foundation
import TinyConstraints
import ISMLBase

protocol BackupTableViewCellDelegate : class {
    func didTapRestore(_ sender: BackupTableViewCell)
}

class BackupTableViewCell: UITableViewCell {

    var delegate: BackupTableViewCellDelegate!
    
    lazy var textTitle:NiceTitleThree = {
       let label = NiceTitleThree()
       return label
    }()
    
    lazy var textTime:NiceLabel = {
       let label = NiceLabel()
       return label
    }()
    
    lazy var textStatus:NiceLabel = {
       let label = NiceLabel()
       label.textColor = Const.GREEN
       label.text = NSLocalizedString("backFileInprogress", comment: "Backup in progress...")
       return label
    }()
    
    lazy var restoreBtn: ButtonImage = {
        let btn = ButtonImage(image: "ic_archive", color: Const.BLUE)
        btn.addTarget(self, action: #selector(didTapRestore(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var line: UIView = {
        let btn = UIView()
        btn.height(1)
        btn.backgroundColor = UIColor(named: "seperatorColor")
        return btn
    }()

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
    
    self.layer.backgroundColor = UIColor.clear.cgColor
    self.addSubview(textTitle)
    textTitle.leftToSuperview(offset: 10)
    textTitle.topToSuperview(offset: 10)
    textTitle.rightToSuperview(offset: -32)
    
    self.addSubview(textTime)
    textTime.leftToSuperview(offset: 10)
    textTime.width(to: textTitle)
    textTime.topToBottom(of: textTitle)
    textTime.bottomToSuperview(offset: -20)
    
    self.addSubview(restoreBtn)
    restoreBtn.rightToSuperview(offset: -10)
    restoreBtn.topToSuperview(offset: 10)
    
    self.addSubview(textStatus)
    textStatus.leftToSuperview(offset: 10)
    textStatus.width(to: textTitle)
    textStatus.bottomToSuperview(offset: -5)
    
    self.addSubview(line)
    line.leftToSuperview(offset: 10)
    line.rightToSuperview()
    line.bottomToSuperview()
    
 }
    
    @objc func didTapRestore(sender: UIButton!) {
        delegate?.didTapRestore(self)
    }
}
