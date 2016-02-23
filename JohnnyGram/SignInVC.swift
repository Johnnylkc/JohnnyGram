//
//  SignInVC.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/2/22.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

  
    @IBAction func signUp(sender: AnyObject)
    {
        print("123123")
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
