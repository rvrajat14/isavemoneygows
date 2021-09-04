
//
//  HowItWorksViewController.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 12/6/17.
//  Copyright © 2017 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLDataService
import ISMLBase

class HowItWorksViewController: BaseViewController, UIScrollViewDelegate {
    
    var pref: MyPreferences!
    var flavor:Flavor!
    var appDelegate:AppDelegate!
    
    
    var stackViewWrapper:UIStackView!
    
    
    static var viewIdentifier:String = "HowItWorksViewController"
    
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView(frame: self.view.frame)
        sv.backgroundColor = UIColor(red:0.28, green:0.61, blue:1.00, alpha:1.0)
        sv.delegate = self
        sv.isPagingEnabled = true
        sv.bounces = false
        return sv
    }()
    
    lazy var pageControl : UIPageControl = {
        let pc = UIPageControl(frame: CGRect(x:0,y: 0, width:200, height:50))
        pc.numberOfPages = 4
        pc.currentPage = 0
        pc.tintColor = mmChrome.WHITE
        pc.pageIndicatorTintColor = mmChrome.WHITE
        pc.currentPageIndicatorTintColor = mmChrome.DARK_BLUE
        pc.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        return pc
    }()
    
    lazy var skipButton:UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("text_skip", comment: ""), for: .normal)
        button.setTitleColor(mmChrome.DARK, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.addTarget(self, action: #selector(actionSkipButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton:UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("text_next", comment: ""), for: .normal)
        button.setTitleColor(mmChrome.WHITE, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.addTarget(self, action: #selector(actionNextButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    
    
    
    
    //features
    var labelTitleFeature1:UILabel!
    var labelDescriptionFeature1:UILabel!
    var imgFeature1: UIImageView!
    var featureSctackView1:UIStackView!
    
    var fromScreen = ""
    //
    
    
    public override func getTag() -> String {
        
        return "HowItWorksViewController"
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        flavor = Flavor()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.pref = MyPreferences()
        
        fromScreen = params["fromscreen"] as? String ?? ""

        navigationController?.navigationBar.isHidden = true
        
        self.view.addSubview(scrollView)
        
        self.view.addSubview(pageControl)
        pageControl.bottomToSuperview(offset: -10)
        pageControl.centerXToSuperview()
        self.view.addSubview(skipButton)
        skipButton.bottomToSuperview(offset: -10)
        skipButton.leftToSuperview(offset: 10)
        self.view.addSubview(nextButton)
        nextButton.bottomToSuperview(offset: -10)
        nextButton.rightToSuperview(offset: -10)
        
        var index:Int = 0
        var firstFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
        firstFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
        firstFrame.size = self.scrollView.frame.size
        let firstSubView = UIView(frame: firstFrame)
        self.scrollView.addSubview(firstSubView)
        let part_1:NSDictionary = [
            "title": NSLocalizedString("how_it_works_titles_0", comment: ""),
            "description": NSLocalizedString("how_it_works_bodies_0", comment: ""),
            "image": UIImage(named: "a_manage_your_money")!]
        featureDisplay(content: firstSubView,
                       partDisplay: part_1,
                       color: UIColor(red:0.28, green:0.61, blue:1.00, alpha:1.0))
        //
        index += 1
        var secondFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
        secondFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
        secondFrame.size = self.scrollView.frame.size
        let secondSubView = UIView(frame: secondFrame)
        self.scrollView.addSubview(secondSubView)
        let part_2:NSDictionary = [
            "title": NSLocalizedString("how_it_works_titles_1", comment: ""),
            "description": NSLocalizedString("how_it_works_bodies_1", comment: ""),
            "image": UIImage(named: "b_create_custom_budgets")!]
        featureDisplay(content: secondSubView,
                       partDisplay: part_2,
                       color: UIColor(red:0.37, green:0.69, blue:1.00, alpha:1.0))
        //
        index += 1
        var thirdFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
        thirdFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
        thirdFrame.size = self.scrollView.frame.size
        let thirdSubView = UIView(frame: thirdFrame)
        self.scrollView.addSubview(thirdSubView)
        let part_3:NSDictionary = [
            "title": NSLocalizedString("how_it_works_titles_2", comment: ""),
            "description": NSLocalizedString("how_it_works_bodies_2", comment: ""),
            "image": UIImage(named: "c_track_incomes_epenses")!]
        featureDisplay(content: thirdSubView,
                       partDisplay: part_3,
                       color: UIColor(red:0.46, green:0.76, blue:1.00, alpha:1.0))
        
        //
        index += 1
        var fouthFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
        fouthFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
        fouthFrame.size = self.scrollView.frame.size
        let fouthSubView = UIView(frame: fouthFrame)
        self.scrollView.addSubview(fouthSubView)
        let part_4:NSDictionary = [
            "title": NSLocalizedString("how_it_works_titles_3", comment: ""),
            "description": NSLocalizedString("how_it_works_bodies_3", comment: ""),
            "image": UIImage(named: "d_share_budget")!]
        featureDisplay(content: fouthSubView,
                       partDisplay: part_4,
                       color: UIColor(red:0.53, green:0.81, blue:0.99, alpha:1.0))
        
        
        self.scrollView.contentSize.width = self.scrollView.frame.size.width * 4
        self.scrollView.contentSize.height = self.scrollView.frame.size.height * 0.9
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
        self.updateButtonText()
    }
    func updateButtonText() {
        if pageControl.currentPage == 3 {
            self.nextButton.setTitle(NSLocalizedString("text_start", comment: "Start"), for: .normal)
        } else{
            self.nextButton.setTitle(NSLocalizedString("text_next", comment: "Next"), for: .normal)
        }
    }
    //for scroll
    
    func gotoScreen() {
        let gPref = GlobalPreferences()
        gPref.setShowOnboarding(true)
        if fromScreen == "help" {
            appDelegate.navigateTo(instance: ViewController())
            //appDelegate.navigateTo(viewControler: FeedBackViewController.viewIdentifier)
        } else if fromScreen == "login" {
            // appDelegate.navigateTo(instance: ViewController())
            appDelegate.navigateTo(instance: SignInViewController())
        }
    }
    
    @objc func actionSkipButton(sender: UIButton!) {
        
        gotoScreen()
    }

    @objc func actionNextButton(sender: UIButton!) {
        if self.nextButton.titleLabel?.text! == NSLocalizedString("text_start", comment: "Start") {
            gotoScreen()
            return
        }
        pageControl.currentPage = (pageControl.currentPage + 1) % 4
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        self.updateButtonText()
    }
    
    
    func featureDisplay(content uiView: UIView, partDisplay:NSDictionary, color: UIColor) {
        
        let imgFeature:UIImageView = {
            let imageView = UIImageView()
            let image = partDisplay["image"] as? UIImage ?? UIImage(named: "repeat_1")
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageView.image = image
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return imageView
        }()
        
        let labelTitleFeature:UILabel = {
            let label = UILabel()
            label.text = partDisplay["title"] as? String ?? ""//"Recurring transaction"
            label.textAlignment = .center
            label.textColor = UIColor(red:0.08, green:0.31, blue:0.66, alpha:1.0)
            label.numberOfLines = 0
            label.font = UIFont(name: "Lato-Heavy", size: 18)
            return label
        }()
        
        let labelDescriptionFeature:UILabel = {
            let label = UILabel()
            label.text =  partDisplay["description"] as? String ?? ""//"Get multiple recurring transactions to be executed at the due date"
            label.textAlignment = .center
            label.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
            label.numberOfLines = 0
            label.font = UIFont(name: "Lato-Regular", size: 15)
            return label
        }()
        
        uiView.backgroundColor = color
        uiView.addSubview(imgFeature)
        uiView.addSubview(labelTitleFeature)
        uiView.addSubview(labelDescriptionFeature)
        imgFeature.bottomToSuperview(offset: -300)
        imgFeature.centerXToSuperview()
        labelTitleFeature.topToBottom(of: imgFeature, offset: 20)
        labelTitleFeature.width(self.scrollView.frame.size.width * 4/5)
        labelTitleFeature.centerXToSuperview()
        labelDescriptionFeature.topToBottom(of: labelTitleFeature)
        labelDescriptionFeature.centerXToSuperview()
        labelDescriptionFeature.width(self.scrollView.frame.size.width  * 4/5)
        
    }
    
}


