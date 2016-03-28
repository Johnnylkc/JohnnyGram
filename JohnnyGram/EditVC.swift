//
//  EditVC.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/3/24.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit
import Parse


class EditVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

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
 
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        alignment()

        information()
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
        
        
        ////create pickerView
        genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackgroundColor()
        genderPicker.showsSelectionIndicator = true
        genderTextField.inputView = genderPicker

        
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(EditVC.loadImage(_:)))
        avaTap.numberOfTapsRequired = 1
        avaImage.userInteractionEnabled = true
        avaImage.addGestureRecognizer(avaTap)
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(EditVC.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(hideTap)
        
    }
    
    func information()
    {
        let ava = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        ava.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            
            self.avaImage.image = UIImage(data: data!)
            
        }
        
        userNameTextField.text = PFUser.currentUser()?.username
        fullNameTextfield.text = PFUser.currentUser()?.objectForKey("fullName") as? String
        bioTextView.text = PFUser.currentUser()?.objectForKey("bio") as? String
        webTextField.text = PFUser.currentUser()?.objectForKey("web") as? String
        emailTextField.text = PFUser.currentUser()?.email
        telTextField.text = PFUser.currentUser()?.objectForKey("phoneNumber") as? String
        genderTextField.text = PFUser.currentUser()?.objectForKey("gender") as? String
        
    }
    
    
    ////按了大頭照 開啟相機膠卷
    func loadImage(sender:UITapGestureRecognizer)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    ////選了照片之後 當大頭貼
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        avaImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    ////整個view的Tap
    func hideKeyboard(sender:UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    ////如果開始輸入文字 scrollView的contenSize = view的高 ＋ 鍵盤高度的一半 再多一點點
    func keyboardWillShow(sender:NSNotification)
    {
        keyboard = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        UIView.animateWithDuration(0.4) { 
            
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2 + 5
            
        }
        
    }
    
    ////如果結束編輯 鍵盤收走後 scrollView的contentSize 讓他等於零 就是不能滾動了
    func keyboardWillHide(sender:UIGestureRecognizer)
    {
        UIView.animateWithDuration(0.4) {
            
            self.scrollView.contentSize.height = 0
            
        }
        
    }
    
    ////檢查 email
    func validateEmail(email:String) -> Bool
    {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
        let range = email.rangeOfString(regex,options: .RegularExpressionSearch)
        let result = range != nil ? true:false
        
        return result
    }
    
    func validateWeb(web:String) -> Bool
    {
        let regex = "www.+[A-Z0-9a-z._%+-]+.[A-Za-z]{2}"
        let range = web.rangeOfString(regex,options: .RegularExpressionSearch)
        let result = range != nil ? true:false
        return result
    }
    
    ////alertView
    func alert(error:String,message:String)
    {
        let alert = UIAlertController(title: "貼心提醒", message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func save_click(sender: AnyObject)
    {
        if !validateEmail(emailTextField.text!)
        {
            alert("無效的電子信箱", message: "請再確認一下您的電子信箱喔")
        }

        if  !validateWeb(webTextField.text!)
        {
            alert("無效的網址", message: "請再確認一下您的網站喔")
        }
        
        let user = PFUser.currentUser()!
        user.username = userNameTextField.text?.lowercaseString
        user.email = emailTextField.text?.lowercaseString
        user["fullName"] = fullNameTextfield.text?.lowercaseString
        user["bio"] = bioTextView.text.lowercaseString
        
        if telTextField.text!.isEmpty
        {
            user["phoneNimber"] = ""
        }
        else
        {
            user["phoneNimber"] = telTextField.text
        }
        
        if  genderTextField.text!.isEmpty
        {
            user["gender"] = ""
        }
        else
        {
            user["gender"] = genderTextField.text
        }
        
        let avaData = UIImageJPEGRepresentation(avaImage.image!, 0.5)
        let avaFile  = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        user.saveInBackgroundWithBlock { (success:Bool, error:NSError?) in
            
            if success
            {
                self.view.endEditing(true)
                self.dismissViewControllerAnimated(true, completion: nil)
                
                ////這個noti 是要填寫完新的個人資料 更新到HomeVC header
                NSNotificationCenter.defaultCenter().postNotificationName("reload",object:nil)
                
            }
            else
            {
                print("大頭照出了點問題\(error)")
            }
            
        }
        
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
