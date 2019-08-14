//
//  Trail.swift
//  Streamline
//
//  Created by Xuezheng Wang on 8/4/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

@IBDesignable
class Trail: UIView {
    
    // UI Informationn
    private var cornerRadius: CGFloat = 5.0
    private static var fillColor: UIColor = UIColor.yellow
    
    @IBInspectable var color: UIColor = .yellow {
        didSet {
            Trail.fillColor = self.color
        }
    }
    
    var startLocation: BoardLocation?
    var endLocation: BoardLocation?

    // Trail animation Info
    var initRect: CGRect?
    var targetRect: CGRect?
    var isAnimated = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        Trail.fillColor.set()
        path.fill()
    }

}
