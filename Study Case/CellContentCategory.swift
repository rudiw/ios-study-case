//
//  CellContentCategory.swift
//  Study Case
//
//  Created by Rudi Wijaya on 11/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit

class CellContentCategory: UITableViewCell {

    @IBOutlet weak var collViewCategory: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        self.collViewCategory.frame = self.contentView.bounds;
    }
    
}
