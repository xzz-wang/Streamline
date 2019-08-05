//
//  Trail.swift
//  Streamline
//
//  Created by Xuezheng Wang on 8/4/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

class Trail: UIView {
    
    private var cornerRadius: CGFloat = 5.0
    var fillColor = UIColor.brown

    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        fillColor.set()
        path.fill()
    }

}
