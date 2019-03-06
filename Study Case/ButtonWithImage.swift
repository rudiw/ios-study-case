//
//  ButtonWithImage.swift
//  Study Case
//
//  Created by Rudi Wijaya on 06/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit


class ButtonWithImage: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (bounds.width - 64))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: (imageView?.frame.width)!, bottom: 0, right: 0)
        }
    }
}
