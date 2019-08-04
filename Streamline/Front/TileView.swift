//
//  TileView.swift
//  Streamline
//
//  Created by Xuezheng Wang on 8/3/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

@IBDesignable
class TileView: UIView {
    
    // MARK: - Properties
    var fillColor: UIColor = .purple
    var boarderColor: UIColor = .clear
    
    
    // MARK: - Initializers
    // Two initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // Setup that is called in every initializers
    private func setup() {
        self.layer.isOpaque = false
    }
    
    
    // MARK: - Custom drawing
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .clear
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width * 0.2)
        fillColor.setFill()
        boarderColor.setStroke()
        
        path.fill()
    }
    
    // MARK: - Other methods.
    

}
