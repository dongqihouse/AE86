//
//  AE86Cell.swift
//  AE86
//
//  Created by DQ on 16/11/28.
//  Copyright © 2016年 DQ. All rights reserved.
//

import UIKit

class AE86Cell: UITableViewCell {

    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var model: MovieModel? {
        didSet{
            nameLabel.text = model?.name
            sizeLabel.text = model?.size
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
