//
//  UpdateCategory.swift
//  iSaveMoney
//
//  Created by Armel Koudoum on 5/24/18.
//  Copyright © 2018 UlmatCorpit. All rights reserved.
//

import UIKit
import  ISMLDataService
import ISMLBase
import TinyConstraints

protocol ModalCategoryDelegate: class {
    func valueReturn(sender: BudgetSection, position:Int)
}

class UpdateCategory : BaseViewController  {
    
    var pref: MyPreferences!
    var flavor:Flavor!
    var budgetSection:BudgetSection!
    var position:Int = -1
    
    var descriptionLabel:NiceLabel!
    var descriptionTextView:NiceTextField!
    
    var budgetLabel:NiceLabel!
    var budgetTextView:NiceTextField!
    
    var descriptionStack:UIStackView!
    var budgetStack:UIStackView!
    var stackFormContent:UIStackView!
    
    var buttonsStack:UIStackView!
    var saveButton:UIButton!
    var discardButton:UIButton!
    weak var delegate:ModalCategoryDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flavor = Flavor()
    
        self.pref = MyPreferences()
        
        
        let cancelButton = UIBarButtonItem(image: UIImage(named: "back_icon"), landscapeImagePhone: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(UpdateCategory.cancelButtonAction))
        
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        // Do any additional setup after loading the view.
        
        setupForm()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.descriptionTextView.text = budgetSection.title
        self.budgetTextView.text = "\(budgetSection.value)"
        
        if budgetSection.type == RowType.income {
            self.title = "Income"
        }  else {
            self.title = "Expense"
        }
    }
    
    @objc func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonSaveAction() {
        
        self.budgetSection.active = 1
        self.budgetSection.title = self.descriptionTextView.text!
        
        self.budgetSection.value = UtilsIsm.readNumberInput(value: self.budgetTextView.text!)
//        if let number = number {
//            self.budgetSection.value = Double(truncating: number)
//        }
        
        
        delegate?.valueReturn(sender: self.budgetSection, position: self.position)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonDiscardAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupForm() {
        
        
        descriptionLabel =  {
            let label = NiceLabel()
            label.text = NSLocalizedString("newBudgetUpdateDescription", comment: "Description")
            return label
        }()
        
        descriptionTextView = {
            let description = NiceTextField()
            description.borderStyle = UITextField.BorderStyle.roundedRect
            description.autocorrectionType = UITextAutocorrectionType.no
            description.keyboardType = UIKeyboardType.default
            description.returnKeyType = UIReturnKeyType.done
            
            return description
        }()
        
        
        descriptionStack = {
            
            let s = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextView])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
    
        
        //Text
        budgetLabel =  {
            
            let label = NiceLabel()
            label.text = NSLocalizedString("newBudgetUpdateBudget", comment: "Description")
            return label
        }()
        
        budgetTextView = {
            
            let description = NiceTextField()
            description.autocorrectionType = UITextAutocorrectionType.no
            description.keyboardType = UIKeyboardType.decimalPad
            description.returnKeyType = UIReturnKeyType.done
            return description
        }()
        
        budgetStack = {
            
            let s = UIStackView(arrangedSubviews: [budgetLabel, budgetTextView])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
        saveButton = {
            
            let button = UIButton(type: UIButton.ButtonType.system) as UIButton
            
            button.frame = CGRect(x:50, y:100, width:150, height:45)
            button.backgroundColor = UIColor(named: "buttonBgColor")
            button.setTitle("Save and add", for: UIControl.State.normal)
            button.tintColor = UIColor.white
            
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(UpdateCategory.buttonSaveAction), for: .touchUpInside)
            return button
        }()
        
        discardButton = {
            
            let button = UIButton(type: UIButton.ButtonType.system) as UIButton
            
            button.frame = CGRect(x:50, y:100, width:150, height:45)
            button.backgroundColor = UIColor(named: "discardBtnBgColor")
            button.setTitle("Cancel", for: UIControl.State.normal)
            button.tintColor = UIColor.white
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(UpdateCategory.buttonDiscardAction), for: .touchUpInside)
            return button
        }()
        
        buttonsStack = {
            let s = UIStackView(arrangedSubviews: [discardButton, saveButton])
            s.axis = .horizontal
            s.distribution = .fillEqually
            s.alignment = .fill
            s.spacing = 6
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()

        
        stackFormContent = {
            let s = UIStackView(arrangedSubviews: [descriptionStack, budgetStack, buttonsStack])
            s.axis = .vertical
            s.distribution = .equalSpacing
            s.alignment = .fill
            s.spacing = 12
            s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return s
        }()
        
     
        self.view.addSubview(stackFormContent)
        stackFormContent.edgesToSuperview(excluding: .bottom, insets: .top(10) + .left(10) + .right(10), usingSafeArea: true)
    }
}




protocol UpdateCategoryModalDelegate {
    func updateRow(_ sender: BudgetSection, position:Int)
}
