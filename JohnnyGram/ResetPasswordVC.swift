//
//  ResetPasswordVC.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/2/22.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit
import Parse

class ResetPasswordVC: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()


    }

    
    
    @IBAction func reset(sender: AnyObject)
    {
        print("重設密碼")
        self.view.endEditing(true)
        
        if emailTextField.text!.isEmpty
        {
            let alert = UIAlertController(title: "hello", message: "email要填喔", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        PFUser.requestPasswordResetForEmailInBackground(emailTextField.text!) { (success:Bool, error:NSError?) -> Void in
            
            if success
            {
                let alert = UIAlertController(title: "親愛的用戶你好", message: "我們已經把新的密碼寄到你剛輸入的信箱了", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "ok", style: .Default, handler: { (UIAlertAction) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            else
            {
                print(error)
            }
            
        }
        
    }
    
    
    @IBAction func cancel(sender: AnyObject)
    {
        print("取消取消拉")
        self.dismissViewControllerAnimated(true, completion: nil)
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
