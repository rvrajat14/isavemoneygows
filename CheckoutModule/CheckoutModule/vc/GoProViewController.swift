//
//  GoProViewController.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/5/20.
//

import UIKit

public class GoProViewController: UIViewController {

    @IBOutlet weak var textFeatureUpgrade: UILabel!
    @IBOutlet weak var buttonUpgrade: UIButton!
    @IBOutlet weak var buttonLater: UIButton!
    @IBOutlet weak var buttonRestore: UIButton!
    @IBOutlet weak var closeButton:UIButton!
    
    public var proTextDisplay: String!
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        buttonUpgrade.addTarget(self, action: #selector(upgradeNow), for: .touchUpInside)
        buttonLater.addTarget(self, action: #selector(upgradeLater), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(upgradeLater), for: .touchUpInside)
        buttonRestore.addTarget(self, action: #selector(upgradeNow), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
        textFeatureUpgrade.text = proTextDisplay
    }

    @objc func upgradeNow() {
        self.navigationController?.pushViewController(PurchaseViewController(nibName: "PurchaseViewController", bundle: Bundle(identifier: CoConst.BUNDLE_ID)), animated: true)
    }
    
    @objc func upgradeLater() {
        dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
