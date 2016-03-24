//
//  GuestVC.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/3/13.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
////

import UIKit
import Parse

var guestName = [String]() ////寫在這邊就像寫在.h 可以接別的controller想要傳給這個comtroller的東西


class GuestVC: UICollectionViewController {
    
    var refresher : UIRefreshControl!
        
    var uuidArray = [String]()
    var picArray = [PFFile]()
    var page:Int = 10

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.title = guestName.last
        
        ////將原本的返回紐隱藏 做個新的
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "back", style: .Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = backButton
        
        ////向右滑 回前頁
        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back:")
        backSwipe.direction = .Right
        self.view.addGestureRecognizer(backSwipe)
        
        ////refresher 下拉更新
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents:.ValueChanged)
        collectionView?.addSubview(refresher)
        
        loadPosts()
        
    }

    
    func back(sender:UIBarButtonItem)
    {
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        if !guestName.isEmpty
        {
            guestName.removeAll(keepCapacity: false)
            
        }
    }
    
    
    
    func refresh()
    {
        self.collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    
    func loadPosts()
    {
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: guestName.last!)
        query.limit = page
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            
            if error == nil
            {
                for object in objects!
                {
                    self.uuidArray.append(object.valueForKey("uuid") as! String)
                    self.picArray.append(object.valueForKey("pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()
            }
            else
            {
                print("loadPosts發生錯誤\(error)")
            }
            
        }
        
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
                print("下載圖片有問題\(error)")
            }
        }
        
        return cell
    }
    
    
    ////header設定
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! HeaderView
        
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: guestName.last!)
        infoQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            
            if error == nil
            {
                if objects!.isEmpty
                {
                    print("wrong user")
                }
            
                for object in objects!
                {
                    header.fullNameLabel.text = (object.valueForKey("fullName") as? String)?.uppercaseString
                   
                    header.bioLabel.text = (object.valueForKey("bio") as? String)?.uppercaseString
                    header.bioLabel.sizeToFit()
                    
                    header.webTextView.text = (object.valueForKey("web") as? String)?.uppercaseString
                    header.webTextView.sizeToFit()
                    
                    let avaFile :PFFile = (object.valueForKey("ava") as? PFFile)!
                    avaFile.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) -> Void in
                        
                        if error == nil
                        {
                            header.avaImage.image = UIImage(data: data!)
                        }
                        else
                        {
                            print("header大頭貼下載有問題\(error)")
                        }
                    })
                }
            
            }
            else
            {
                print("header下載有問題\(error)")
            }
        }
        
        
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        followQuery.whereKey("following", equalTo: guestName.last!)
        followQuery.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            
            if error == nil
            {
                if count == 0
                {
                    header.editButton.setTitle("FOLLOW", forState: .Normal)
                    header.editButton.backgroundColor = UIColor.lightGrayColor()
                }
                else
                {
                    header.editButton.setTitle("FOLLOWING", forState: .Normal)
                    header.editButton.backgroundColor = UIColor.greenColor()
                }
            }
            else
            {
                print("followQuery有問題\(error)")
            }
            
        }
        
        
        ////計算點擊的這user有幾則po文
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: guestName.last!)
        posts.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            
            if error == nil
            {
                header.postsNumberLabel.text = "\(count)"
            }
            else
            {
                print("posts這個query有問題\(error)")
            }
        }
        
        ////計算點擊的這個user有幾個人追蹤他
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: guestName.last!)
        followers.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            
            if error == nil
            {
                header.followersNumberLabel.text = "\(count)"
            }
            else
            {
                print("計算這個人有幾個人追蹤他出問題\(error)")
            }
        }
        
        ////計算點擊的這個user追蹤的人數
        let followings = PFQuery(className: "follow")
        followings.whereKey("follower", equalTo: guestName.last!)
        followings.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
        
            if error == nil
            {
                header.followingsNumberLabel.text = "\(count)"
            }
            else
            {
                print("計算這user追蹤的人數時出問題\(error)")
            }
        }
        
        
        ////點了這個user的po文數這個UILabel 就...
        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
        postsTap.numberOfTapsRequired = 1
        header.postsNumberLabel.userInteractionEnabled = true
        header.postsNumberLabel.addGestureRecognizer(postsTap)
        
        ////點了這個user的follower數字label 就...
        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
        followersTap.numberOfTapsRequired = 1
        header.followersNumberLabel.userInteractionEnabled = true
        header.followersNumberLabel.addGestureRecognizer(followersTap)
        
        ////點了這個user的following數字label 就...
        let followingsTap = UITapGestureRecognizer(target: self, action: "followingsTap")
        followersTap.numberOfTapsRequired = 1
        header.followingsNumberLabel.userInteractionEnabled = true
        header.followingsNumberLabel.addGestureRecognizer(followingsTap)
        
        return header
    }
    
    
    ////三個tapGest action執行
    func postsTap()
    {
        if !picArray.isEmpty
        {
            let index = NSIndexPath(forRow: 0, inSection: 0)
            self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: .Top, animated: true)
        }
        
    }
    
    func followersTap()
    {
        user = guestName.last!
        show = "followers"
        
        let followers = storyboard?.instantiateViewControllerWithIdentifier("FollowersTVC") as! FollowersTVC
        self.navigationController?.pushViewController(followers, animated: true)
        
        print("這到底能不能點")
    }
    
    func followingsTap()
    {
        user = guestName.last!
        show = "followings"
        
        
    }
    
    
    
    
    
   
}
