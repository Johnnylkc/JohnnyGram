//
//  FollowersCell.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/3/2.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit
import Parse

class FollowersCell: UITableViewCell {
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    

    override func awakeFromNib()
    {
        super.awakeFromNib()

        let width = UIScreen.mainScreen().bounds.width
        
        avaImage.frame = CGRectMake(10, 10, width/5.3, width/5.3)
        avaImage.layer.cornerRadius = avaImage.frame.size.width / 2
        avaImage.clipsToBounds = true
        
        userNameLabel.frame = CGRectMake(avaImage.frame.size.width + 20, 25, width/3.2, 30)
        followButton.frame = CGRectMake(width - width/3.5, 30, width/3.5, 30)
        
        
    }
    
    
    
    @IBAction func folowButtonClick(sender: AnyObject)
    {
        let title = followButton.titleForState(.Normal)

        //////追蹤他
        if title == "FOLLOW"
        {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.currentUser()?.username
            object["following"] = userNameLabel.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                
                if success
                {
                    self.followButton.setTitle("FOLLOWING", forState: .Normal)
                    self.followButton.backgroundColor = UIColor.greenColor()
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
            query.whereKey("following", equalTo: userNameLabel.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                if error == nil
                {
                    for object in objects!
                    {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            
                            if success
                            {
                                self.followButton.setTitle("FOLLOW", forState: .Normal)
                                self.followButton.backgroundColor = UIColor.lightGrayColor()
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
    
    
    
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
