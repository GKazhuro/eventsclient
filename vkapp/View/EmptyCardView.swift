//
//  EmptyCardView.swift
//  vkapp
//
//  Created by George Kazhuro on 22.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import Foundation
import UIKit

protocol EmptyDelegate: class {
    func updateBtnPressed()
}

class EmptyCardView: UIView {
    
    weak var delegate: EmptyDelegate?
    
    @IBOutlet weak var notFoundImageView: UIImageView!
    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBAction func updateBtnPressed(sender: UIButton) {
        delegate?.updateBtnPressed()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        updateButton.layer.borderWidth = 1
        updateButton.layer.borderColor = updateButton.titleLabel?.textColor.cgColor
        updateButton.layer.cornerRadius = 8
    }
}
