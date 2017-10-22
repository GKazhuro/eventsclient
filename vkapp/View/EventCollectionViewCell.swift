//
//  EventCollectionViewCell.swift
//  vkapp
//
//  Created by George Kazhuro on 21.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import UIKit

protocol EventCollectionViewCellDelegate: class {
    func eventLikeBtnPressed(at cell: EventCollectionViewCell)
}

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var gradientImageView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    var gradientLayer: CAGradientLayer!

    weak var delegate: EventCollectionViewCellDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupBtnInsets()
        setupRoundedShadow()
        setupImageViewGradient(heightPercent: 0.90)
    }
    
    override func awakeFromNib() {
        likeButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func setupRoundedShadow() {
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    func setupBtnInsets() {
        let inset = dateLabel.frame.minY + likeButton.bounds.height / 4
        likeButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }
    
    func setupImageViewGradient(heightPercent: NSNumber) {
        if gradientLayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientImageView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func favoriteBtnPressed(sender: UIButton!) {
        delegate?.eventLikeBtnPressed(at: self)
    }
}
