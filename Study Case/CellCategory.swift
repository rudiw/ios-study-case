//
//  CellCategory.swift
//  Study Case
//
//  Created by Rudi Wijaya on 11/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit

class CellCategory: UITableViewCell {

    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
