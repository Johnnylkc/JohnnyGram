//
//  EditVC.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/3/24.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit

class EditVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var webTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    var genderPicker : UIPickerView!
    let genders = ["男","女"]
    
    var keyboard = CGRect()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        ////create pickerView
        genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackgroundColor()
        genderPicker.showsSelectionIndicator = true
        genderTextField.inputView = genderPicker
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(EditVC.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(hideTap)
        
        alignment()

    }
    
    func alignment()
    {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        scrollView.frame = CGRectMake(0, 0, width, height)
        
        avaImage.frame = CGRectMake(width - 68 - 10, 15, 68, 68)
        avaImage.layer.cornerRadius = avaImage.frame.size.width/2
        avaImage.clipsToBounds = true
        
        fullNameTextfield.frame = CGRectMake(10, avaImage.frame.origin.y,width - avaImage.frame.size.width - 30,30)
        userNameTextField.frame =
            CGRectMake(10, fullNameTextfield.frame.origin.y + 40, width - avaImage.frame.size.width - 30, 30)
        webTextField.frame = CGRectMake(10, userNameTextField.frame.origin.y + 40, width - 20, 30)
        
        bioTextView.frame = CGRectMake(10, webTextField.frame.origin.y + 40, width-20, 60)
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1).CGColor
        bioTextView.layer.cornerRadius = bioTextView.frame.size.width / 50
        bioTextView.clipsToBounds = true
        
        emailTextField.frame = CGRectMake(10, bioTextView.frame.origin.y + 100, width-20,30)
        telTextField.frame = CGRectMake(10, emailTextField.frame.origin.y + 40, width-20, 30)
        genderTextField.frame = CGRectMake(10, telTextField.frame.origin.y + 40, width-20, 30)
        
        titleLabel.frame = CGRectMake(15, emailTextField.frame.origin.y - 30, width-20, 30)
        
        
        
    }
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(sender:NSNotification)
    {
        print("鍵盤出現了")
        keyboard = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        UIView.animateWithDuration(0.4) { 
            
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2 + 5
            
        }
        
    }
    
    func keyboardWillHide(sender:UIGestureRecognizer)
    {
        print("鍵盤消失")
        UIView.animateWithDuration(0.4) { 
            
            self.scrollView.contentSize.height = 0
            
        }
        
    }
    
    
    @IBAction func save_click(sender: AnyObject)
    {
        
        
    }
    
    @IBAction func cancel_click(sender: AnyObject)
    {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    ////pickerView 方法
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return genders.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return genders[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        genderTextField.text = genders[row]
        self.view.endEditing(true)
    }
    
    
//    override func didReceiveMemoryWarning()
//    {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
