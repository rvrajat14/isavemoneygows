//
//  TeamRowTableViewCell.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 1/3/21.
//  Copyright © 2021 Armel Koudoum. All rights reserved.
//

import UIKit
import ISMLBase

public protocol TeamInviteDelegate{
    func onInvite(teamId: String)
}

class TeamRowTableViewCell: UITableViewCell {

    @IBOutlet weak var circledLetter: CircleTextUIView!
    @IBOutlet weak var txtTeamCreateDate: SmallTextLabel!
    @IBOutlet weak var txtTeamTitle: NormalTextLabel!
    @IBOutlet weak var btnInviteUser: UIButton!
    
    var teamId: String!
    var delegate: TeamInviteDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnInviteUser.setImage(btnInviteUser.imageView?.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        btnInviteUser.tintColor = UIColor(named: "tintIconsColor")
        btnInviteUser.addTarget(self, action: #selector(inviteclicked), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func inviteclicked(){
        print("Clicked...")
        if delegate != nil && self.teamId != nil {
            delegate.onInvite(teamId: self.teamId)
        }
    }
    
    
    
}
