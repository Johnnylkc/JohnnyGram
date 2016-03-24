//
//  PictureCell.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/3/1.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureImage: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let width = UIScreen.mainScreen().bounds.width
        
        pictureImage.frame = CGRectMake(0, 0, width/3, width/3)
        
    }
    
}
