//
//  IcomeEditTableViewCell.swifIcomeEditTableViewCellt
//  iSaveMoney
//
//  Created by Armel Koudoum on 1/20/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import ISMLBase

class IcomeEditTableViewCell: UITableViewCell {
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var textAmount: UILabel!

    @IBOutlet weak var addRemoveButton: UIButton!
    
    weak var delegate: IncomeEditTableViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
     
    }
    
    func renderIcon() {
        
        let btnImage = UIImage(named: "trash_item")
        addRemoveButton.setImage(btnImage, for: UIControl.State.normal)
        addRemoveButton.backgroundColor = .clear
        addRemoveButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        addRemoveButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        addRemoveButton.heightAnchor.constraint(equalTo: addRemoveButton.widthAnchor).isActive = true
        addRemoveButton.setContentHuggingPriority(UILayoutPriority(rawValue: 650), for: .horizontal)
        addRemoveButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 650), for: .horizontal)
        addRemoveButton.setContentHuggingPriority(UILayoutPriority(rawValue: 650), for: .vertical)
        addRemoveButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 650), for: .vertical)
        addRemoveButton.layer.cornerRadius = 18.0 //* addExpenseButton.bounds.size.width
        addRemoveButton.backgroundColor = Const.RED
        addRemoveButton.layer.shadowColor = UIColor.black.cgColor
        addRemoveButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        addRemoveButton.layer.masksToBounds = false
        addRemoveButton.layer.shadowRadius = 1.0
        addRemoveButton.layer.shadowOpacity = 0.5
        
        addRemoveButton.addTarget(self, action: #selector(IcomeEditTableViewCell.addRemoveTapped), for: .touchUpInside)
    }
    
    func setDeleteButton() {
        
         let btnImage = UIImage(named: "trash_item")
        addRemoveButton.setImage(btnImage, for: UIControl.State.normal)
        addRemoveButton.backgroundColor = Const.RED
    }

    func setAddButton() {
        
        let btnImage = UIImage(named: "ic_add_white_36pt")
        addRemoveButton.setImage(btnImage, for: UIControl.State.normal)
        addRemoveButton.backgroundColor = Const.BLUE
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
    @objc func addRemoveTapped() {
        delegate?.incomeEditTableViewCellDidTaped(self)
    }

}
