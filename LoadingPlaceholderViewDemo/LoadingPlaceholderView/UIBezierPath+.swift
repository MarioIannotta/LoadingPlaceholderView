//
//  UIBezierPath+.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 04/05/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    static func multiLinePath(numberOfLines: Int,
                              spacing: CGFloat,
                              bounds: CGRect) -> UIBezierPath {
        let numberOfLinesFloat = CGFloat(numberOfLines)
        let height = bounds.height
        let lineHeight = CGFloat((height - ((numberOfLinesFloat - 1) * spacing))/numberOfLinesFloat)
        let totalPath = UIBezierPath()
        for index in 0..<numberOfLines {
            let lineFrame = CGRect(x: 0,
                                   y: (lineHeight + spacing)*CGFloat(index),
                                   width: bounds.width,
                                   height: lineHeight)
            let linePath = UIBezierPath(roundedRect: lineFrame,
                                        cornerRadius: lineFrame.height/2)
            totalPath.append(linePath)
        }
        return totalPath
    }

    func translate(to point: CGPoint) {
        apply(CGAffineTransform(translationX: point.x, y: point.y))
    }
    
}
