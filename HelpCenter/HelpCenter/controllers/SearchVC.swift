//
//  SearchVC.swift
//  Help Center
//
//  Created by DevD on 24/04/20.
//  Copyright © 2020 Devendra. All rights reserved.
//

import UIKit

public class SearchVC: UITableViewController , UISearchResultsUpdating {
    
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let searchController = UISearchController(searchResultsController: nil)
    
    var infoLabel = UILabel(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 50))
    var helpCenterModel = [HelpCenterModel]()
    var allContentDict: Dictionary<String,[ItemModel]> = [:]
    var searchContentDict: Dictionary<String,[ItemModel]> = [:]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //UIFont.loadAllFonts()
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.tableView.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        
        self.view.addSubview(infoLabel)
        infoLabel.numberOfLines = 2
        infoLabel.text =  searchEnterInfo
        infoLabel.textColor = .gray
        infoLabel.textAlignment = .center
        infoLabel.font = errorTextFont
        self.configureSearchBar()
        self.allContentDict.removeAll()
        for subSectionDict in helpCenterModel
        {
            let subSection = subSectionDict.sub_sections
            for contentDict in subSection
            {
                let content = contentDict.content_item
                let subtitle = contentDict.sub_title
                self.allContentDict[subtitle] = content
            }
        }
        searchController.searchBar.backgroundColor = UIColor.clear
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureSearchBar()
    }

    func configureSearchBar()
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let searchTextField:UITextField = searchController.searchBar.searchTextField
        searchTextField.layer.cornerRadius = 2
        searchTextField.font = searchTextFont
        searchTextField.backgroundColor = .white
        searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = ImageLoader.image(named: "search_ic")!
        
        //UIImage(named: "search_ic")!
        let imageView:UIImageView = UIImageView.init(image: image)
        searchTextField.leftView = nil
        searchTextField.placeholder = "Search"
        searchTextField.rightView = imageView
        searchTextField.rightViewMode = UITextField.ViewMode.always
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*appDelegate.setNavigationBarStyleWithTransparent(navigationController: navigationController!, viewController: self, title: "", titleColor: navigationTitleColor, backGroundColor:navigationBackgroundColor)*/
    }
    
    func filterContent(for searchText: String) {
        searchContentDict = allContentDict.filter({ (key: String, content: [ItemModel]) -> Bool in
            let match = key.range(of: searchText, options: .caseInsensitive)
            return match != nil
        })
    }
    
    // MARK: - UISearchResultsUpdating method
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            if searchContentDict.count <= 0
            {
                if searchController.searchBar.searchTextField.text == ""
                {
                    infoLabel.text = searchEnterInfo
                }
                else
                {
                   infoLabel.text = noSearchFoundInfo
                }
                infoLabel.isHidden = false
            }
            else
            {
                infoLabel.isHidden = true
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewController methods
    public override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchContentDict.count
    }

    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subTitle = Array(searchContentDict.keys)[indexPath.row]
        let width = UIScreen.main.bounds.size.width - 62
        let subTitleHeight = subTitle.height(withConstrainedWidth: width, font: sectionItemTitleFont)
        if subTitle == "" {
            return 0
        }
        if subTitleHeight < 50
        {
            return 50
        }
        return subTitleHeight + 15
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subTitle = Array(searchContentDict.keys)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        cell.bulletListView.isHidden = false
        cell.bulletLabel.font = sectionItemTitleFont
        cell.bulletLabel.attributedText = NSAttributedString(string: subTitle , attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        cell.selectionStyle = .none
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailVC(nibName: "DetailVC", bundle: nil)
        let subTitle = Array(searchContentDict.keys)[indexPath.row]
        for subSectionDict in helpCenterModel
        {
            let subSection = subSectionDict.sub_sections
            for contentDict in subSection
            {
                let content = contentDict.content_item
                if content == searchContentDict[subTitle]!
                {
                    detailVC.titleString = subSectionDict.title
                    break
                }
            }
        }
        self.title = ""
        detailVC.subTitleString = subTitle
        detailVC.itemModel = searchContentDict[subTitle]!
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    

}
