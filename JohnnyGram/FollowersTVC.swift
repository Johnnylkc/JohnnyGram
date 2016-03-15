//
//  FollowersTVC.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/3/2.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit
import Parse

var user = String()
var show = String()

class FollowersTVC: UITableViewController {

    var userNameArray = [String]()
    var avaArray = [PFFile]()
    var followArray = [String]()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.title = show.uppercaseString
        
        if show == "followers"
        {
            loadFollowers()
        }
        
        if show == "followings"
        {
            loadFollowings()
        }
        
    }


    ////從parse找出追蹤這個user的有誰
    /*
    他這方法的步驟分別是 
    1.先進到follow這個class
    2.再去找following這欄位裡跟目前使用者名字一樣的人
    3.


    */
    func loadFollowers()
    {
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            
            if error == nil
            {
                ////不管現在要使用的這個陣列之前有沒有東西 先淨空
                self.followArray.removeAll(keepCapacity: false)
                
                for object in objects!
                {
                    self.followArray.append(object.valueForKey("follower") as! String )
                }
            
                let query = PFQuery(className: "_User")
                query.whereKey("username", containedIn: self.followArray)
                query.addDescendingOrder("creatAt")
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    
                    if error == nil
                    {
                        ////不管現在要使用的這個陣列之前有沒有東西 先淨空
                        self.userNameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity:false)

                        for object in objects!
                        {
                            self.userNameArray.append(object.valueForKey("username") as! String)
                            self.avaArray.append(object.valueForKey("ava") as! PFFile)
                        }
                    
                        self.tableView.reloadData()
                    }
                    else
                    {
                        print("loadFollowers 第二層 發生錯誤\(error)")
                    }
                })
            
            }
            else
            {
                print("loadFollowers 第一層 發生錯誤 \(error)")
            }
        }
        
    }
    
    ////從parse找出這個user正在追蹤誰
    func loadFollowings()
    {
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            
            if error == nil
            {
                self.followArray.removeAll(keepCapacity: false)
                
                for object in objects!
                {
                    self.followArray.append(object.valueForKey("following") as! String)
                }
                
                let query = PFQuery(className: "_User")
                query.whereKey("username", containedIn: self.followArray)
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    
                    if error == nil
                    {
                        self.userNameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                    
                        for object in objects!
                        {
                            self.userNameArray.append(object.valueForKey("username") as! String )
                            self.avaArray.append(object.valueForKey("ava") as! PFFile)
                        }
                    
                        self.tableView.reloadData()

                    }
                    else
                    {
                        print("有些錯誤\(error)")
                    }
                    
                })
                
            }
            else
            {
                print("有錯誤\(error)")
            }
        
        }
        
    }
    


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userNameArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FollowersCell
        
        cell.userNameLabel.text = userNameArray[indexPath.row]
        
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            
            if error == nil
            {
                cell.avaImage.image = UIImage(data: data!)
            }
            else
            {
                print("圖片下載有問題\(error)")
            }
            
        }

       
        
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("following", equalTo: cell.userNameLabel.text!)
        query.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            
            if error == nil
            {
                if count == 0
                {
                    cell.followButton.setTitle("FOLLOW", forState:.Normal)
                    cell.followButton.backgroundColor = UIColor.lightGrayColor()
                    
                }
                else
                {
                    cell.followButton.setTitle("FOLLOWING", forState: .Normal)
                    cell.followButton.backgroundColor = UIColor.greenColor()
                }
            }
        
        }
        
        
        
        if cell.userNameLabel.text == PFUser.currentUser()?.username
        {
            cell.followButton.hidden = true
        }
        
        
        return cell
    }
    

    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FollowersCell
        
        ////如果currentuser點擊到他自己 那就到他自己的首頁 如果不是那就到他點擊的那個人的頁面
        if cell.userNameLabel.text! == PFUser.currentUser()!.username!
        {
            let home = storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! HomeVC
            self.navigationController?.pushViewController(home, animated: true)
        }
        else
        {
            guestName.append(cell.userNameLabel.text!)
            let guest = storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! GuestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
        

    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
