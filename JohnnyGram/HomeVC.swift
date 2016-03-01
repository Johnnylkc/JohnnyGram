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

    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        collectionView?.backgroundColor = UIColor.whiteColor()
       
        ////navi title 是這個user的username
        self.navigationItem.title = PFUser.currentUser()?.username?.uppercaseString

       
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
 

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 0
    }

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
