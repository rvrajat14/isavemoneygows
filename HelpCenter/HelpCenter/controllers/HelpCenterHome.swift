//
//  HelpCenter.swift
//  Help Center
//
//  Created by DevD on 24/04/20.
//  Copyright © 2020 Devendra. All rights reserved.
//

import UIKit








public class HelpCenterHome: UITableViewController {
    
    lazy var cancelButton:UIBarButtonItem = {
              return UIBarButtonItem(image: UIImage(named: "back_icon"),
                                     landscapeImagePhone: UIImage(named: "back_icon"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(HelpCenterHome.cancel(_:)))
          }()
       
    
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var helpCenterModel : [HelpCenterModel] = []
    
    let kHeaderSectionTag: Int = 6900;
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Help Center", bundle: Bundle(identifier: HelpCenterBundle)!, comment: "Help Center")
        self.navigationItem.leftBarButtonItem  = cancelButton
        self.tableView!.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "TableCell", bundle: Bundle(identifier: HelpCenterBundle)), forCellReuseIdentifier: "TableCell")
        self.helpCenterModel.removeAll()
        self.parseHelpCenterJson()
        //self.readJsonFile()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*appDelegate.setNavigationBarStyleWithTransparent(navigationController: navigationController!, viewController: self, title: helpCenter, titleColor: navigationTitleColor, backGroundColor:navigationBackgroundColor)*/
        self.navigationItem.setHidesBackButton(true, animated: true)
        let rightBarButtonItem = UIBarButtonItem.init(image: ImageLoader.image(named: "search_ic"), style: .done, target: self, action: #selector(self.rightBarButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @IBAction func rightBarButtonTapped(sender: UIButton)
    {
        let searchVC = SearchVC(nibName: "SearchVC", bundle: Bundle(identifier: HelpCenterBundle))
        self.title = ""
        searchVC.helpCenterModel = self.helpCenterModel
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func readJsonFile() {
        if let url = URL(string: "https://s3.amazonaws.com/isavemoney.app/help-center-ismgo.json") {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                 }
               }
           }.resume()
        }
        
    }
    // MARK: - Parse JSON File
    func parseHelpCenterJson()
    {
        
        var bundleName = Bundle(identifier: HelpCenterBundle)
        let url = bundleName?.url(forResource: "help_center", withExtension: "json")!
        //let url = Bundle.main.url(forResource: "help_center", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url!)
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData) as! NSArray
            
            for dictArray in jsonArray
            {
                let helpCenterModelTemp = HelpCenterModel()
                
                let dictArrayTemp = dictArray as! NSDictionary
                let titleStr = dictArrayTemp["title"] as! String
                let sectionID = dictArrayTemp["sectionId"] as! String
                helpCenterModelTemp.scetion_id = sectionID
                helpCenterModelTemp.title = titleStr
                
                let subSections = dictArrayTemp["subsections"] as! NSArray
                var contentModel = [ContentModel]()
                for subArray in subSections
                {
                    let subArrayTemp = subArray as! NSDictionary
                    let contentModelTemp = ContentModel()
                    if subArrayTemp["subtitle"] != nil
                    {
                        let subTitleStr = subArrayTemp["subtitle"] as! String
                        contentModelTemp.sub_title = subTitleStr
                    }
                    let contentArray = subArrayTemp["content"] as! NSArray
                    var itemModel = [ItemModel]()
                    for itemArray in contentArray
                    {
                        let itemModelTemp = ItemModel()
                        let itemArrayTemp = itemArray as! NSDictionary
                        let typeStr = itemArrayTemp["type"] as! String
                        itemModelTemp.type = typeStr
                        if itemArrayTemp["display-value"] as? NSArray != nil
                        {
                            let displayValueArray = itemArrayTemp["display-value"] as! NSArray
                            itemModelTemp.display_value_array = displayValueArray
                        }
                        else
                        {
                            let displayValueStr = itemArrayTemp["display-value"] as! String
                            itemModelTemp.display_value_str = displayValueStr
                        }
                        
                        if itemArrayTemp["open-link"] != nil
                        {
                            let openLinkStr = itemArrayTemp["open-link"] as! String
                            itemModelTemp.open_link = openLinkStr
                        }
                        itemModel.append(itemModelTemp)
                    }
                    contentModelTemp.content_item = itemModel
                    contentModel.append(contentModelTemp)
                }
                helpCenterModelTemp.sub_sections = contentModel
                self.helpCenterModel.append(helpCenterModelTemp)
            }
            self.tableView.reloadData()
        }
        catch {
            print(error)
        }
    }
    
    // MARK: - Tableview Methods
    public override func numberOfSections(in tableView: UITableView) -> Int {
        if self.helpCenterModel.count > 0 {
            tableView.backgroundView = nil
            return self.helpCenterModel.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = sectionItemTitleFont
            //messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
        }
        return 0
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let arrayOfContents = self.helpCenterModel[section].sub_sections
            return arrayOfContents.count;
        } else {
            return 0;
        }
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.helpCenterModel.count != 0) {
            return ""
        }
        return ""
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0;
    }
    
    public override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.helpCenterModel[indexPath.section].sub_sections
        let subTitleStr = section[indexPath.row].sub_title
        let width = UIScreen.main.bounds.size.width - 62
        let subTitleHeight = subTitleStr.height(withConstrainedWidth: width, font: sectionItemTitleFont)
        if subTitleStr == "" {
            return 0
        }
        if subTitleHeight < 50
        {
            return 50
        }
        return subTitleHeight + 15
    }
    
    public override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.white
        
        let headerFrame = self.view.frame.size
        let headerView = UIView(frame: CGRect(x: 15, y: 5, width: headerFrame.width - 30, height: 50));
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 5
        headerView.layer.borderWidth = 1
        headerView.layer.borderColor = navigationBackgroundColor.cgColor
        header.addSubview(headerView)
        
        let headertitleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: headerFrame.width - 60, height: 50));
        headertitleLabel.textColor = sectionTitleColor
        headertitleLabel.font = sectionTitleFont
        headertitleLabel.numberOfLines = 2
        headertitleLabel.textAlignment = .left
        headerView.addSubview(headertitleLabel)
        headertitleLabel.text = self.helpCenterModel[section].title
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 72, y: 13, width: 20, height: 20));
        theImageView.image = ImageLoader.image(named: "down_arrow")
        theImageView.tag = kHeaderSectionTag + section
        headerView.addSubview(theImageView)
        
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(HelpCenterHome.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        let section = self.helpCenterModel[indexPath.section].sub_sections
        cell.bulletListView.isHidden = false
        cell.bulletLabel.font = sectionItemTitleFont
        cell.bulletLabel.attributedText = NSAttributedString(string: section[indexPath.row].sub_title, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        cell.selectionStyle = .none
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailVC(nibName: "DetailVC", bundle: Bundle(identifier: HelpCenterBundle))
        detailVC.titleString = self.helpCenterModel[indexPath.section].title
        self.title = ""
        let section = self.helpCenterModel[indexPath.section].sub_sections
        detailVC.subTitleString = section[indexPath.row].sub_title
        detailVC.itemModel = section[indexPath.row].content_item
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Expand / Collapse Methods
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.helpCenterModel[section].sub_sections
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.helpCenterModel[section].sub_sections
        
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    //cancel
    @objc func cancel(_ sender: UIBarButtonItem) {
        
        //_ = navigationController?.popViewController(animated: true)
        // _ = navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
    }
    
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return ceil(boundingBox.height)
    }
}
