//
//  FreeFoodTableViewCell.swift
//  First App
//
//  Created by Theodore Ando on 12/7/16.
//  Copyright © 2016 Theodore Ando. All rights reserved.
//

import UIKit

class FreeFoodTableViewCell: UITableViewCell {
    // MARK:  Properties

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
