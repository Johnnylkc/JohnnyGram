//
//  SignUpVC.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/2/22.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    @IBOutlet weak var avaImage: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPassordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var webTextField: UITextField!

    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollViewHeight : CGFloat = 0
    
    var keyBoard = CGRect()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpVC.showKeyboard(_:)), name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpVC.hideKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
        allUI()
        
        
    }

    func allUI()
    {
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height

        avaImage.layer.cornerRadius = avaImage.frame.size.width/2
        avaImage.clipsToBounds = true
        
        
        ////加在scrollView 碰一下可以收鍵盤
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        ////在那個大頭貼上加UITapGestureRecognizer 而不是加按鈕 按了之後開啟相機膠卷
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.loadImage(_:)))
        avaTap.numberOfTapsRequired = 1
        self.avaImage.userInteractionEnabled = true
        avaImage.addGestureRecognizer(avaTap)
        
        
        ////位置大小
        avaImage.frame = CGRectMake(self.view.frame.size.width/2 - 40, 40, 80, 80)
        
        userNameTextField.frame = CGRectMake(10, avaImage.frame.origin.y + 90, self.view.frame.size.width - 20, 30)
        
        passwordTextField.frame =
            CGRectMake(10, userNameTextField.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        
        repeatPassordTextField.frame =
            CGRectMake(10, passwordTextField.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
       
        emailTextField.frame =
            CGRectMake(10, repeatPassordTextField.frame.origin.y + 60, self.view.frame.size.width - 20, 30)
        
        fullNameTextField.frame =
            CGRectMake(10, emailTextField.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        
        bioTextField.frame =
            CGRectMake(10, fullNameTextField.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        
        webTextField.frame =
            CGRectMake(10, bioTextField.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        
        signUpButton.frame = CGRectMake(10, webTextField.frame.origin.y + 50, self.view.frame.size.width/4, 30)
        
        cancelButton.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width/4 - 20, signUpButton.frame.origin.y, self.view.frame.size.width/4, 30)
        
        ////背景圖片
        let backImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        backImage.image = UIImage(named: "a02")
        backImage.layer.zPosition = -1
        self.view.addSubview(backImage)
        
    }
    
    
    func loadImage(recoginizer:UITapGestureRecognizer)
    {


        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        self.presentViewController(picker, animated: true, completion: nil)
        
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
        ////如果有一個textfield沒填寫 就跳出個alert
        if(userNameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || repeatPassordTextField.text!.isEmpty || fullNameTextField.text!.isEmpty || bioTextField.text!.isEmpty || webTextField.text!.isEmpty || emailTextField.text!.isEmpty)
        {
            let alert = UIAlertController(title: "拜託", message: "請把資料填完", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
            }
        
        ////如果密碼和密碼確認不一樣 跳出alert
        if(passwordTextField.text != repeatPassordTextField.text)
        {
            let alert = UIAlertController(title: "抱歉", message: "請再確認一次你的密碼", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let user = PFUser()
        user.username = userNameTextField.text?.lowercaseString
        user.email = emailTextField.text?.lowercaseString
        user.password = passwordTextField.text
        user["fullName"] = fullNameTextField.text?.lowercaseString
        user["bio"] = bioTextField.text
        user["web"] = webTextField.text?.lowercaseString
        
        ////這兩個還沒要用 先創建
        user["phoneNimber"] = ""
        user["grnder"] = ""
        
        let avaData = UIImageJPEGRepresentation(avaImage.image!, 0.4)
        let avafile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avafile
        
        user.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            
            if success
            {
                NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "userName")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
                
                
                print("註冊成功")
                print("寫入userDefaults")
            }
            else
            {
                let alert =
                UIAlertController(title: "發現錯誤", message: error?.localizedDescription, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
                print("有些錯誤")
            }
        }
        
    }
    
    
    @IBAction func cancel(sender: AnyObject)
    {
        print("我要取消")
        self.view.endEditing(true)
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
