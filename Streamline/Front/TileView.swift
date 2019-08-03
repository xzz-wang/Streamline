//
//  TileView.swift
//  Streamline
//
//  Created by Xuezheng Wang on 8/3/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

class TileView: UIView {
    
    var fillColor: UIColor = .purple
    

    // Custom drawing
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width * 0.2)
        fillColor.setFill()
        path.fill()
    }
    

}
