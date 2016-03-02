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
                ////先把這兩個array淨空 不管裡面有沒有東西 先清空
                self.uuidArray.removeAll(keepCapacity: false)
                self.picArray.removeAll(keepCapacity: false)

                for object in objects!
                {
                    self.uuidArray.append(object.valueForKey("uuid") as! String)
                    self.picArray.append(object.valueForKey("pic") as! PFFile)
                    
                    print("okok")
                }
                
                self.collectionView?.reloadData()
            }
            else
            {
                print("有問題\(error!)")
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
                print("有些問題\(error!)")
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

        
        return header
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
