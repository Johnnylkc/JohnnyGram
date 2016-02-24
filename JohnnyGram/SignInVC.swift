//
//  SignInVC.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/2/22.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit
import Parse

class SignInVC: UIViewController {

    
    @IBOutlet weak var johnnyGramLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        johnnyGramLabel.frame = CGRectMake(10, 80, self.view.frame.size.width-20, 50)
        userNameTextField.frame = CGRectMake(10, johnnyGramLabel.frame.origin.y+70, self.view.frame.size.width-20, 30)
        passwordTextField.frame = CGRectMake(10, userNameTextField.frame.origin.y+40, self.view.frame.size.width-20, 30)
        forgetButton.frame = CGRectMake(10, passwordTextField.frame.origin.y+30, self.view.frame.size.width-20, 30)
        signInButton.frame = CGRectMake(20, forgetButton.frame.origin.y+40, self.view.frame.size.width/4, 30)
        signUpButton.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width/4 - 20, signInButton.frame.origin.y, self.view.frame.size.width/4, 30)
        
        
        
        
    }

    
   
    @IBAction func signIn(sender: AnyObject)
    {
        print("你按了登入")
        self.view.endEditing(true)
        
        if userNameTextField.text!.isEmpty || passwordTextField.text!.isEmpty
        {
            let alert = UIAlertController(title: "hello", message: "你有些資料沒填完喔", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        PFUser.logInWithUsernameInBackground(userNameTextField.text!, password:passwordTextField.text!) { (user:PFUser?, error:NSError?) -> Void in
            
            if error == nil
            {
                NSUserDefaults.standardUserDefaults().setObject(user?.username, forKey: "userName")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
                
            }
            
        }
        
    }
    
  
    @IBAction func signUp(sender: AnyObject)
    {
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning()
    {
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
