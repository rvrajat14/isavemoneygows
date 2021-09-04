//
//  ReportsTabsViewController.swift
//  iSaveMoney
//
//  Created by ARMEL KOUDOUM on 8/27/20.
//  Copyright © 2020 Armel Koudoum. All rights reserved.
//

import UIKit

class ReportsTabsViewController: BaseScreenViewController,UITabBarControllerDelegate {

    var tabsController = UITabBarController()
    
    let titles = [NSLocalizedString("LineChart", comment: "Line Chart"),
                  NSLocalizedString("BarChart", comment: "Bar Chart"),
                  NSLocalizedString("PieChart", comment: "Pie Chart")]
    
    lazy var cancelButton:UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_icon"),
                               landscapeImagePhone: UIImage(named: "back_icon"),
                               style: .plain,
                               target: self,
                               action: #selector(PayeeFormViewController.cancel(_:)))
    }()
    
    lazy var openBarChart:UITabBarItem = {
        let t = UITabBarItem()
        t.title = "Bar chart"
        t.image = UIImage(named: "bar_chart")
        t.tag = 0
        
        
        return t
    }()
    lazy var openLineChart:UITabBarItem = {
        let t = UITabBarItem()
        t.title = "Pie Chart"
        t.image = UIImage(named: "pie")
        t.tag = 1
        return t
    }()
    lazy var openPieChart:UITabBarItem = {
        let t = UITabBarItem()
        t.title = "Line Chart"
        t.image = UIImage(named: "chart")
        t.tag = 2
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("LineChart", comment: "Line Chart")
        self.navigationItem.leftBarButtonItem  = cancelButton

        
        
        let lineChartViewController = LineChartViewController()
        lineChartViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("LineChart", comment: "Line Chart"), image: UIImage(named: "chart"), tag: 1)
       
        let barChartViewController = BarchartDailyViewController()
        barChartViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("BarChart", comment: "Bar Chart"), image: UIImage(named: "bar_chart"), tag: 2)
        
        let pieChartViewController = PieChartViewController()
        pieChartViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("PieChart", comment: "Pie Chart"), image: UIImage(named: "pie"), tag: 3)
        
        self.tabsController.viewControllers = [lineChartViewController,barChartViewController,pieChartViewController]
        self.view.addSubview(tabsController.view)
        self.tabsController.delegate = self
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch self.tabsController.selectedIndex {
        case 0:
            self.title = NSLocalizedString("LineChart", comment: "Line Chart")
            break
        case 1:
            self.title = NSLocalizedString("BarChart", comment: "Bar Chart")
            break
        default:
            self.title = NSLocalizedString("PieChart", comment: "Pie Chart")
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem  = cancelButton
        }
    }
    
    
    //cancel
    @objc func cancel(_ sender: UIBarButtonItem) {
        //appDelegate.navigateTo(instance: PayeeViewController())
        _ = navigationController?.popViewController(animated: true)
        
    }

}
