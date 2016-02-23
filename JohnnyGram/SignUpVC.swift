//
//  SignUpVC.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/2/22.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    @IBOutlet weak var avaImage: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPassordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var webTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollViewHeight : CGFloat = 0
    
    var keyBoard = CGRect()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyboard:", name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
        
        
        avaImage.layer.cornerRadius = avaImage.frame.size.width/2
        avaImage.clipsToBounds = true
        
        
        ////加在scrollView 碰一下可以收鍵盤
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboardTap:")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        let avaTap = UITapGestureRecognizer(target: self, action: "loadImage:")
        avaTap.numberOfTapsRequired = 1
        self.avaImage.userInteractionEnabled = true
        avaImage.addGestureRecognizer(avaTap)
        
    }

    func loadImage(recoginizer:UITapGestureRecognizer)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        avaImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer)
    {
        self.view.endEditing(true)
        
    }
    
    
    
    ////執行兩個在viewDidLoad的 notification
    func showKeyboard(notification:NSNotification)
    {
        
        keyBoard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyBoard.height
        }
    }
    
    func hideKeyboard(notification:NSNotification)
    {
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }

    
    
    
    @IBAction func signUp(sender: AnyObject)
    {
        print("我要登入")
        if(userNameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || repeatPassordTextField.text!.isEmpty || fullNameTextField.text!.isEmpty || bioTextField.text!.isEmpty || webTextField.text!.isEmpty || emailTextField.text!.isEmpty)
        {
            let alert = UIAlertController(title: "拜託", message: "請把資料填完", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
            }
        
        if(passwordTextField.text != repeatPassordTextField.text)
        {
            let alert = UIAlertController(title: "抱歉", message: "請再確認一次你的密碼", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    @IBAction func cancel(sender: AnyObject)
    {
        print("我要取消")
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
