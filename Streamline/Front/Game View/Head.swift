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
    
    @IBInspectable private var headColor: UIColor = .orange {
        didSet {
            Head.defaultHeadColor = self.headColor
        }
    }
    
    static var defaultHeadColor = UIColor.orange
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.isOpaque = false
        
        let path = UIBezierPath(ovalIn: rect)
        
        Head.defaultHeadColor.setFill()
        path.fill()
    }
    
}
