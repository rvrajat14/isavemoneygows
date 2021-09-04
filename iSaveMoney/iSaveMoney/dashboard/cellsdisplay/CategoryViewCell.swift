//
//  CategoryViewCell.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 9/24/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase
import TinyConstraints
protocol CategoryCellDelegate : class {
    func didTapAdd(_ sender: CategoryViewCell)
}

class CategoryViewCell: UITableViewCell {

    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var budgetSpendValueLabel: UILabel!
    @IBOutlet weak var actualSpendValueLabel: UILabel!
    @IBOutlet weak var remainingValueLabel: UILabel!
    @IBOutlet weak var progressGraph: BarIndicatorView!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var addExpenseButton: UIButton!
    
    var flavor:Flavor!
    
    weak var delegate: CategoryCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.mainBackground.backgroundColor = mmChrome.WHITE
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.backgroundColor = UIColor.clear
        
        
        self.separator.backgroundColor = UIColor(named: "seperatorColor")
    
        self.addExpenseButton.setImage(UIImage(systemName: "plus")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        self.addExpenseButton.imageView?.contentMode = .scaleAspectFit
        self.addExpenseButton.imageView?.tintColor = UIColor.white
        self.addExpenseButton.width(32)
        self.addExpenseButton.height(32)
        self.addExpenseButton.backgroundColor = UIColor(named: "tintIconsColor")
        self.addExpenseButton.layer.cornerRadius = 16

       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    @IBAction func addExpense(_ sender: Any) {
        
        delegate?.didTapAdd(self)
    }
    
}
