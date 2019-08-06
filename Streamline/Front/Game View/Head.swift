//
//  Head.swift
//  Streamline
//
//  Created by Xuezheng Wang on 8/4/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

@IBDesignable
class Head: UIView {
    
    @IBInspectable private var headColor: UIColor = .orange

    override func draw(_ rect: CGRect) {
        self.layer.isOpaque = false
        
        let path = UIBezierPath(ovalIn: rect)
        
        headColor.setFill()
        path.fill()
    }

}
