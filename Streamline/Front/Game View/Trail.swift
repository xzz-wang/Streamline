//
//  Trail.swift
//  Streamline
//
//  Created by Xuezheng Wang on 8/4/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

class Trail: UIView {
    
    // UI Informationn
    private var cornerRadius: CGFloat = 5.0
    var fillColor = UIColor.yellow
    
    // Trail animation Info
    var targetRect: CGRect?
    var isAnimated = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        fillColor.set()
        path.fill()
    }

}
