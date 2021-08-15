//
//  YPMenuItem.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 24/01/2018.
//  Copyright © 2016 Yummypets. All rights reserved.
//

import UIKit
import Stevia

final class YPMenuItem: UIView {
    
    var textLabel = UILabel()
    var button = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func setup() {
        backgroundColor = YPImagePickerConfiguration.shared.colors.bottomMenuItemBackgroundColor
        
        sv(
            textLabel,
            button
        )
        
        textLabel.centerInContainer()
        |-(10)-textLabel-(10)-|
        button.fillContainer()
        
        textLabel.style { l in
            l.textAlignment = .center
            l.font = YPConfig.fonts.menuItemFont
            l.textColor = YPImagePickerConfiguration.shared.colors.bottomMenuItemUnselectedTextColor
            l.adjustsFontSizeToFitWidth = true
            l.numberOfLines = 2
        }
    }

    func select(color: UIColor = YPImagePickerConfiguration.shared.colors.bottomMenuItemSelectedTextColor) {
        textLabel.textColor = color
    }
    
    func deselect(color: UIColor = YPImagePickerConfiguration.shared.colors.bottomMenuItemUnselectedTextColor) {
        textLabel.textColor = color
    }
}
