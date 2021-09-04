//
//  HelpTableCell.swift
//  Help Center
//
//  Created by DevD on 23/04/20.
//  Copyright © 2020 Devendra. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var bulletListView: UIView!
    @IBOutlet weak var numberListView: UIView!
    @IBOutlet weak var flatTextView: UIView!
    @IBOutlet weak var youtubeView: UIView!
    
    @IBOutlet weak var bulletLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberSerialLabel: UILabel!
    @IBOutlet weak var flatTextLabel: UILabel!
    @IBOutlet weak var youtubeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
