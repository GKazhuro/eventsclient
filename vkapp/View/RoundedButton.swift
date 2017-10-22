//
//  RoundedButton.swift
//  vkapp
//
//  Created by George Kazhuro on 21.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {
    
    @IBInspectable var drawBorder: Bool = false
    @IBInspectable var tintForImage: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2
        
        if drawBorder {
            self.layer.borderWidth = 4
            self.layer.borderColor = UIColor.mainColor.cgColor
        }
        
        if tintForImage {
            let image = UIImage(named: "dislike")?.withRenderingMode(.alwaysTemplate)
            self.setImage(image, for: .normal)
            self.tintColor = UIColor.mainColor
        }
        
        let imageInsets = self.bounds.height / 5.0
        
        self.imageEdgeInsets = UIEdgeInsets(top: imageInsets, left: imageInsets, bottom: imageInsets, right: imageInsets)
    }

}
