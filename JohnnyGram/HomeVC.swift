//
//  HomeVC.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/3/1.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit
import Parse

class HomeVC: UICollectionViewController {
    
    var refresher : UIRefreshControl!
    var page : Int = 10
    var uuidArray = [String]()
    var picArray = [PFFile]()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        collectionView?.backgroundColor = UIColor.whiteColor()
       
        ////navi title 是這個user的username
        self.navigationItem.title = PFUser.currentUser()?.username?.uppercaseString
        
        ////下拉更新 使用UIRefreshControl
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        collectionView?.addSubview(refresher)
        
        loadPosts()
       
    }

    ////執行下拉更新action
    func refresh()
    {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    ////下載資料 在viewDidLoad執行
    func loadPosts()
    {
        let query = PFQuery(className: "posts")
        query.whereKey("userName", equalTo: PFUser.currentUser()!.username!)
        query.limit = page
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            
            if error == nil
            {
                ////先把這兩個array淨空 不管裡面有沒有東西 先清空 為的是避免裡面有bug
                self.uuidArray.removeAll(keepCapacity: false)
                self.picArray.removeAll(keepCapacity: false)

                for object in objects!
                {
                    self.uuidArray.append(object.valueForKey("uuid") as! String)
                    self.picArray.append(object.valueForKey("pic") as! PFFile)
                    
                }
                
                self.collectionView?.reloadData()
                print("成功下載資料lodaPosts & reloadData")
            }
            else
            {
                print("資料下載有問題\(error!)")
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return picArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell =
        collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PictureCell
        
        picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            
            
            if error == nil
            {
                cell.pictureImage.image = UIImage(data: data!)
                
            }
            else
            {
                print("item下載出問題\(error!)")
            }
        }
        
        return cell
    }
    
    ////header設定
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! HeaderView

        header.fullNameLabel.text = (PFUser.currentUser()?.objectForKey("fullName") as? String)?.uppercaseString
        
        header.webTextView.text = PFUser.currentUser()?.objectForKey("web") as? String
        header.webTextView.sizeToFit()
        
        header.bioLabel.text = PFUser.currentUser()?.objectForKey("bio") as? String
        header.bioLabel.sizeToFit()
        
        let avaQuery = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        avaQuery.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            
            header.avaImage.image = UIImage(data: data!)
            
        }
        
        header.editButton.setTitle("edit profile", forState: .Normal)
        
       
        ////計算這個user總共的po文有幾則
        let posts = PFQuery(className: "posts")
        posts.whereKey("userName", equalTo: PFUser.currentUser()!.username!)
        posts.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            
            if error == nil
            {
                header.postsNumberLabel.text = "\(count)"
            }
        }

        
        ////計算這個user有幾個人在follow
        let followers = PFQuery(className: "follow")
        followers.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        followers.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            
            if error == nil
            {
                header.followersNumberLabel.text = "\(count)"
            }
            
        }
        
        
        ////計算這個user正在追蹤的有多少人
        let following = PFQuery(className: "follow")
        following.whereKey("following", equalTo: PFUser.currentUser()!.username!)
        following.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            
            if error == nil
            {
                header.followingsNumberLabel.text = "\(count)"
            }
        }
        
        
        ////在po文 追蹤者 追蹤中 三個Label(不是數字) 各加上UITapGestureRecognizer
        ////po文Label
        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
        postsTap.numberOfTapsRequired = 1
        header.postsNumberLabel.userInteractionEnabled = true
        header.postsNumberLabel.addGestureRecognizer(postsTap)
        
        ////追蹤者Label
        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
        followersTap.numberOfTapsRequired = 1
        header.followersNumberLabel.userInteractionEnabled = true
        header.followersNumberLabel.addGestureRecognizer(followersTap)
        
        ////追蹤中Label
        let followingTap = UITapGestureRecognizer(target: self, action: "followingTap")
        followingTap.numberOfTapsRequired = 1
        header.followingsNumberLabel.userInteractionEnabled = true
        header.followingsNumberLabel.addGestureRecognizer(followingTap)
        
        
        return header
    }

    
    ////po文 追蹤者 追蹤中 三個Label 加在之上的UITapGestureRecognizer action 執行
    func postsTap()
    {
        if !picArray.isEmpty
        {
            let index = NSIndexPath(forItem: 0, inSection: 0)
            self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: .Top, animated: true)
        }
    }

    func followersTap()
    {
        user = PFUser.currentUser()!.username!
        show = "followers"
        
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("FollowersTVC") as! FollowersTVC
        self.navigationController?.pushViewController(followers, animated: true)
        
    }


    func followingTap()
    {
        user = PFUser.currentUser()!.username!
        show = "followings"
        
        let follwers = self.storyboard?.instantiateViewControllerWithIdentifier("FollowersTVC") as! FollowersTVC
        self.navigationController?.pushViewController(follwers, animated: true)
        
    }
    
    
    

    /*
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
    }
    */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    *///
}
