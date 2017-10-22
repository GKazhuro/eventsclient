//
//  CircleImageView.swift
//  vkapp
//
//  Created by George Kazhuro on 22.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2
    }

}
