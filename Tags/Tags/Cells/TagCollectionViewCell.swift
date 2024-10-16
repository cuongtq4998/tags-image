//
//  UICollectionView+sort.swift
//  Tags
//
//  Created by Tatevik Tovmasyan on 5/26/20.
//  Copyright © 2020 Helix Consulting LLC. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundVieww: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratioAspect: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    static let heightCell: CGFloat = 45.0
    static let spaceRightLeftTitle: CGFloat = 25.0
    static let spaceLeftImage: CGFloat = 10.0
    
    override var intrinsicContentSize: CGSize {
        let widthContainer = titleLabel.intrinsicContentSize.width +
        TagCollectionViewCell.spaceRightLeftTitle +
        imageView.intrinsicContentSize.width +
        TagCollectionViewCell.spaceLeftImage
        
        return CGSize(
            width: widthContainer,
            height: TagCollectionViewCell.heightCell)
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundVieww.layer.cornerRadius = TagCollectionViewCell.heightCell/2
    }
    
    func config(tag: Tags) {
        self.titleLabel.text = tag.title
        
        if let image = tag.image {
            imageView.image = image
            let ratio = image.size.width/image.size.height
            ratioAspect = ratioAspect.changeMultiplier(to: ratio)
        }
    }
}

public extension NSLayoutConstraint {
    func changeMultiplier(to newMultiplier: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        
        // Create a new constraint with the same properties but a new multiplier
        let newConstraint = NSLayoutConstraint(
            item: self.firstItem as Any,
            attribute: self.firstAttribute,
            relatedBy: self.relation,
            toItem: self.secondItem,
            attribute: self.secondAttribute,
            multiplier: newMultiplier,
            constant: self.constant
        )
        
        // Copy priority and identifier if needed
        newConstraint.priority = self.priority
        newConstraint.identifier = self.identifier
        
        // Activate the new constraint
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}
