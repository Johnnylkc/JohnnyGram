//
//  HeaderView.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/3/1.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit
import Parse

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var webTextView: UITextView!
    @IBOutlet weak var bioLabel: UILabel!
    
    
    @IBOutlet weak var postsNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    @IBOutlet weak var followingsNumberLabel: UILabel!
    
    
    @IBOutlet weak var postsTitleLabel: UILabel!
    @IBOutlet weak var followersTitleLabel: UILabel!
    @IBOutlet weak var followingsTitleLabel: UILabel!
    
    
    @IBOutlet weak var editButton: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let width = UIScreen.mainScreen().bounds.width
        
        avaImage.frame = CGRectMake(width/16, width/16, width/4, width/4)
        avaImage.layer.cornerRadius = avaImage.frame.size.width/2
        avaImage.clipsToBounds = true
        
        postsNumberLabel.frame = CGRectMake(width/2.5, avaImage.frame.origin.y, 50, 20)
        followersNumberLabel.frame = CGRectMake(width/1.6, avaImage.frame.origin.y, 50, 20)
        followingsNumberLabel.frame = CGRectMake(width/1.2, avaImage.frame.origin.y, 50, 20)
        
        postsTitleLabel.center = CGPointMake(postsNumberLabel.center.x, postsNumberLabel.center.y + 20)
        followersTitleLabel.center = CGPointMake(followersNumberLabel.center.x, followersNumberLabel.center.y + 20)
        followingsTitleLabel.center = CGPointMake(followingsNumberLabel.center.x, followingsNumberLabel.center.y + 20)
        
        editButton.frame = CGRectMake(postsTitleLabel.frame.origin.x, postsTitleLabel.frame.origin.y + 20, width - postsTitleLabel.frame.size.width - 100, 30)
        
        
        
    }
    
    
    
    @IBAction func followButtonClicked(sender: AnyObject)
    {
        let title = editButton.titleForState(.Normal)
        
        //////追蹤他
        if title == "FOLLOW"
        {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.currentUser()?.username
            object["following"] = guestName.last!
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                
                if success
                {
                    self.editButton.setTitle("FOLLOWING", forState: .Normal)
                    self.editButton.backgroundColor = UIColor.greenColor()
                }
                else
                {
                    print(error)
                }
            })
        }
        else ///// 取消追蹤
        {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("following", equalTo: guestName.last!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                if error == nil
                {
                    for object in objects!
                    {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            
                            if success
                            {
                                self.editButton.setTitle("FOLLOW", forState: .Normal)
                                self.editButton.backgroundColor = UIColor.lightGrayColor()
                            }
                            else
                            {
                                print("取消追蹤有問題\(error)")
                            }
                            
                        })
                    }
                }
                else
                {
                    print("取消追蹤有些問題喔\(error)")
                }
                
            })
            
        }

        
    }
    
    
    
    
        
}
