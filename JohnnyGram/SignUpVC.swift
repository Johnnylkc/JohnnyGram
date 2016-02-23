//
//  SignUpVC.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/2/22.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var avaImage: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPassordTextField: UITextField!
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
        
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyboard:", name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
        
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboardTap:")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        

    }

    
    
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer)
    {
        self.view.endEditing(true)
        
    }
    
    
    
    
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
