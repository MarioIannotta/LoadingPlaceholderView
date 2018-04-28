//
//  LoadingPlaceholderView+Configuration.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 28/04/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

struct Configuration {
    
    struct Gradient {
        
        var backgroundColor: UIColor = .clear
        var primaryColor: UIColor = .clear
        var secondaryColor: UIColor = .clear
        
        init() {
            self.init(color: .white)
        }
        
        init(color: UIColor) {
            backgroundColor = color.withBrightness(brightness: 0.98)
            primaryColor = color.withBrightness(brightness: 0.95)
            secondaryColor = color.withBrightness(brightness: 0.88)
        }
        
    }
    
    var fadeAnimationDuration: TimeInterval = 0.15
    var loadingAnimationDuration: TimeInterval = 1
    var gradientWidth: Double = 0.2
    var defaultBorderRadius: CGFloat = 8
    var backgroundColor: UIColor = .clear
    var gradient = Gradient()
    var gradientColor: UIColor = .clear {
        didSet {
            gradient = Gradient(color: gradientColor)
        }
    }
    
}

extension UIColor {
    
    fileprivate func withBrightness(brightness: CGFloat) -> UIColor {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        if getHue(&H, saturation: &S, brightness: &B, alpha: &A) {
            B += (brightness - 1.0)
            B = max(min(B, 1.0), 0.0)
            return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
        }
        return self
    }
    
}
