//
//  OtoViewController.swift
//  CheckoutModule
//
//  Created by ARMEL KOUDOUM on 12/5/20.
//

import UIKit

public class OtoViewController: UIViewController {

    @IBOutlet weak var purpleBackView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var strikedPrice: UILabel!
    @IBOutlet weak var txtNewPrice: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        purpleBackView.layer.cornerRadius = 20
        purpleBackView.layer.masksToBounds = true
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$4.99")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        strikedPrice.text = "$4.99"
        strikedPrice.attributedText = attributeString
        strikedPrice.textAlignment = .right
    }


    @IBAction func buyThis() {
        
    }
    
    @IBAction func noCancel(){
        
    }
    
    @IBAction func close() {
        
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
