//
//  CardView.swift
//  vkapp
//
//  Created by George Kazhuro on 21.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupAlphaGradient()
        self.imageView.clipsToBounds = true
        self.gradientView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 8.0
        self.gradientView.layer.cornerRadius = 8.0
    }
    
    func setupAlphaGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 0.90]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
