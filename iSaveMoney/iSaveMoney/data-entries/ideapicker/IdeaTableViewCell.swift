//
//  IdeaTableViewCell.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 12/12/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

class IdeaTableViewCell: UITableViewCell {

    @IBOutlet weak var textRowDis: UILabel!
    @IBOutlet weak var iconOnLeft: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        self.iconOnLeft.image = UIImage(named: "give_idea")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.iconOnLeft?.contentMode = .scaleAspectFit
        self.iconOnLeft.tintColor = UIColor(named: "normalTextColor")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
