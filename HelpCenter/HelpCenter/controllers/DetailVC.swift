//
//  DetailVC.swift
//  Help Center
//
//  Created by DevD on 24/04/20.
//  Copyright © 2020 Devendra. All rights reserved.
//

import UIKit

class DetailVC: UITableViewController {
        
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var titleString = ""
    var subTitleString = ""
    var itemModel = [ItemModel]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "TableCell", bundle: Bundle(identifier: HelpCenterBundle)), forCellReuseIdentifier: "TableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*appDelegate.setNavigationBarStyleWithTransparent(navigationController: navigationController!, viewController: self, title: titleString, titleColor: navigationTitleColor, backGroundColor:navigationBackgroundColor)*/
    }
    
    // MARK: - Tableview Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemModel.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 0
        {
            let type = itemModel[section - 1].type
            if type == "list-bullet" || type == "list-number"
            {
                return itemModel[section - 1].display_value_array.count
            }
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0;
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var contentHeight: CGFloat = 50.0
        if indexPath.row == 0
        {
            let width = UIScreen.main.bounds.size.width - 50
            contentHeight = subTitleString.height(withConstrainedWidth: width, font: detailSubTitleFont)
        }
        else
        {
            let type = itemModel[indexPath.section - 1].type
            if type == "title-level2"
            {
                let width = UIScreen.main.bounds.size.width - 50
                contentHeight = itemModel[indexPath.section - 1].display_value_str.height(withConstrainedWidth: width, font: sectionItemTitleFont)
            }
            else if type == "flat-text"
            {
                let width = UIScreen.main.bounds.size.width - 50
                contentHeight = itemModel[indexPath.section - 1].display_value_str.height(withConstrainedWidth: width, font: detailTextFont)
            }
            else if type == "list-bullet"
            {
                let width = UIScreen.main.bounds.size.width - 72
                contentHeight = (itemModel[indexPath.section - 1].display_value_array[indexPath.row] as! String).height(withConstrainedWidth: width, font: detailTextFont)
            }
            else
            {
                var textStr = ""
                if type == "list-number"
                {
                    textStr = itemModel[indexPath.section - 1].display_value_array[indexPath.row] as! String
                }
                else
                {
                    textStr = itemModel[indexPath.section - 1].display_value_str
                }
                let width = UIScreen.main.bounds.size.width - 85
                contentHeight = textStr.height(withConstrainedWidth: width, font: detailTextFont)
            }
        }
        
        if contentHeight < 40
        {
            return 50
        }
        return contentHeight + 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        cell.flatTextView.isHidden = true
        cell.bulletListView.isHidden = true
        cell.numberListView.isHidden = true
        cell.youtubeView.isHidden = true
        if indexPath.section == 0
        {
            cell.flatTextView.isHidden = false
            cell.flatTextLabel.font = detailSubTitleFont
            cell.flatTextLabel.text = subTitleString
        }
        else
        {
            let type = itemModel[indexPath.section - 1].type
            if type == "title-level2"
            {
                cell.flatTextView.isHidden = false
                cell.flatTextLabel.font = sectionItemTitleFont
                cell.flatTextLabel.text = itemModel[indexPath.section - 1].display_value_str
            }
            else if type == "flat-text"
            {
                cell.flatTextView.isHidden = false
                cell.flatTextLabel.font = detailTextFont
                cell.flatTextLabel.text = itemModel[indexPath.section - 1].display_value_str
            }
            else if type == "list-bullet"
            {
                cell.bulletListView.isHidden = false
                cell.bulletLabel.font = detailTextFont
                cell.bulletLabel.text = itemModel[indexPath.section - 1].display_value_array[indexPath.row] as? String
            }
            else if type == "list-number"
            {
                cell.numberListView.isHidden = false
                cell.numberLabel.font = detailTextFont
                cell.numberSerialLabel.text = "\(indexPath.row + 1)"
                cell.numberLabel.text = itemModel[indexPath.section - 1].display_value_array[indexPath.row] as? String
            }
            else
            {
                cell.youtubeView.isHidden = false
                cell.youtubeLabel.font = detailTextFont
                cell.youtubeLabel.text = itemModel[indexPath.section - 1].display_value_str
                cell.youtubeLabel.textColor = sectionTitleColor
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0
        {
            let type = itemModel[indexPath.section - 1].type
            if type == "video-youtub"
            {
                if let url = URL(string: itemModel[indexPath.row].open_link) {
                    UIApplication.shared.open(url, options:  [:], completionHandler: nil)
                }
            }
        }
    }
    

    
}
