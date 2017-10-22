//
//  GradientView.swift
//  allsportsbet
//
//  Created by George Kazhuro on 13.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GradientView: UIView {
    
    @IBInspectable
    var firstColor : UIColor = .white
    
    @IBInspectable
    var secondColor : UIColor = .white
    
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        
    }
}
