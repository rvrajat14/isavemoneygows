//
//  AccountIncomingTableViewCell.swift
//  
//
//  Created by Armel Koudoum on 1/19/19.
//

import UIKit
import TinyConstraints
import ISMLBase

class AccountTransactionTableViewCell: UITableViewCell {

    var ckboxPoited:UISwitch!
    var textDescription:NormalTextLabel!
    var textDate:SmallTextLabel!
    var textAmount:HeaderLevelFour!
    
    
    var position:Int = 0
    var flavor:Flavor!
    
    weak var delegate: AccountTransactionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    /*
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        flavor = Flavor()
        setUpViews()
    }*/
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        flavor = Flavor()
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        
        ckboxPoited = {
            let ckbox = UISwitch()
            ckbox.addTarget(self, action: #selector(AccountTransactionTableViewCell.addCheckTapped), for: .valueChanged)
            return ckbox
        }()
        
        
        textDescription = {
            let label = NormalTextLabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        
        textDate = {
            let label = SmallTextLabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        textAmount = {
            let label = HeaderLevelFour()
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        addSubview(ckboxPoited)
        ckboxPoited.leftToSuperview(offset: 10)
        ckboxPoited.centerYToSuperview()
        addSubview(textDescription)
        textDescription.topToSuperview(offset: 10)
        textDescription.leftToSuperview(offset: 65)
        textDescription.rightToSuperview()
        addSubview(textDate)
        textDate.leftToSuperview(offset: 65)
        textDate.topToBottom(of: textDescription)
        addSubview(textAmount)
        textAmount.rightToSuperview(offset: -10)
        textAmount.topToBottom(of: textDescription)
        
        
       
    }
    
    @objc func addCheckTapped() {
        delegate?.accountTransactionTableViewCellDidTaped(self, position: self.position)
    }

}
