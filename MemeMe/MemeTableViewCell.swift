//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by grace montoya on 7/4/16.
//  Copyright © 2016 grace montoya. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

   
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
