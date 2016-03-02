//
//  FollowersCell.swift
//  JohnnyGram
//
//  Created by 劉坤昶 on 2016/3/2.
//  Copyright © 2016年 JohnnyKetchup. All rights reserved.
//

import UIKit

class FollowersCell: UITableViewCell {
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
