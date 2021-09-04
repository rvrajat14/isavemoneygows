//
//  LabelForm.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 2/12/19.
//  Copyright © 2019 UlmatCorpit. All rights reserved.
//

import UIKit
import TinyConstraints
import ISMLDataService
import ISMLBase



protocol LabelDelegate: class {
    func valueReturn(sender: Label, position:Int)
}


class LabelForm: BaseViewController {
    
    var pref: MyPreferences!
    var flavor:Flavor!
    
    var labelLabelName:UILabel!
    var editLablName:UITextField!
    var stackLabelName:UIStackView!
    
    var lineOneColorStack:UIStackView!
    var lineTwoColorStack:UIStackView!
    
    var rowsColorStack:UIStackView!
    
    var color1:ColorView!
    var color2:ColorView!
    
    var colorBoxSize = 22
    
    
    var stackFormContent:UIStackView!
    
    weak var delegate:LabelDelegate?
    var label:Label!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flavor = Flavor()
        
        self.pref = MyPreferences()
        
        self.navigationController!.navigationBar.isTranslucent = false
        
//        navigationController?.navigationBar.tintColor = flavor.getNavigationBarColor()
//        navigationController?.navigationBar.barTintColor = flavor.getPrimaryColor()
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:flavor.getNavigationBarColor(), NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 18)!]
        
        self.title = "Add Label"
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(LabelForm.cancel(_:)))
        
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        let editButton = UIBarButtonItem(title: NSLocalizedString("text_edit", comment: "Edit"), style: .done, target: self, action:  #selector(LabelForm.edit(_:)))
        
        self.navigationItem.rightBarButtonItem  = editButton
        
        viewsLayout()
    }
    
    func viewsLayout() {
        
        labelLabelName = {
            let label = UILabel()
            label.text = "Description"
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 13)
            return label
        }()
        editLablName = {
            let description = UITextField(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
        
            description.textAlignment = .left
            description.font = UIFont.systemFont(ofSize: 15)
            description.borderStyle = UITextField.BorderStyle.roundedRect
            description.autocorrectionType = UITextAutocorrectionType.no
            description.keyboardType = UIKeyboardType.default
            description.returnKeyType = UIReturnKeyType.done
            return description
        }()

        
    
        
        color1 = {
            let color = ColorView()
            color.reDraw(color: Const.BLUE, checked: true)
            return color
        }()
        
        color2 = {
            let color = ColorView()
            color.reDraw(color: Const.BLUE, checked: false)
            return color
        }()
        
        lineOneColorStack = {
            
            let s = UIStackView(arrangedSubviews: [color1, color2])
            s.axis = .horizontal
            return s
        }()
        
        
        stackFormContent = {
            let s = UIStackView(arrangedSubviews: [labelLabelName,
                                                   editLablName,
                                                   lineOneColorStack])
            s.axis = .vertical
            
            return s
        }()
        
        
        self.view.addSubview(stackFormContent)
        stackFormContent.edgesToSuperview(excluding: .bottom, insets: .top(20) + .left(15) + .right(15), usingSafeArea: true)
        
       
    }
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        
         dismiss(animated: true, completion: nil)
    }
    @objc func edit(_ edit: UIBarButtonItem) {
        
         dismiss(animated: true, completion: nil)
    }
    
}
