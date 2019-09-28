//
//  LevelViewCell.swift
//  Streamline
//
//  Created by Xuezheng Wang on 9/27/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

@IBDesignable
class LevelViewCell: UICollectionViewCell {
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBInspectable var fillColor: UIColor = .yellow
    
    var levelNumber: Int!
    
    
    // Custom drawing
    override func draw(_ rect: CGRect) {

        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width * 0.2)
        fillColor.setFill()
        
        path.fill()

    }
}
