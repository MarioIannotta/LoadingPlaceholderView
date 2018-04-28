//
//  CoverableView.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 28/04/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

@objc protocol CoverableView {
    
    @objc var isCoverable: Bool { get }
    
    var coverablePath: UIBezierPath { get }
    
}

extension UIView: CoverableView {
    
    var isCoverable: Bool {
        let isACoverableView = self is UILabel ||
            self is UIImageView ||
            self is UITextView ||
            self is UIButton
        return isACoverableView && isBigEnough
    }
    
    var coverablePath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds,
                            cornerRadius: layer.cornerRadius)
    }
    
    /**
     usefull to discard small iOS stuff
     for example uiscrollview' scroll indicators are uiimageviews
     */
    private var isBigEnough: Bool {
        return frame.width > 20 && frame.height > 20
    }
    
}

extension UITextView {
    
    private var numberOfVisibleLines: Int {
        guard let font = self.font else { return 1 }
        return Int(frame.height/font.lineHeight)
    }
    
    override var coverablePath: UIBezierPath {
        return .makeMultiLinePath(numberOfLines: numberOfVisibleLines, frame: frame)
    }
    
}

extension UILabel {
    
    private var numberOfVisibleLines: Int {
        guard let font = self.font else { return 1 }
        return Int(frame.height/font.lineHeight)
    }
    
    override var coverablePath: UIBezierPath {
        return .makeMultiLinePath(numberOfLines: numberOfVisibleLines, frame: frame)
    }
    
}

extension UIBezierPath {
    
    static func makeMultiLinePath(numberOfLines: Int,
                                  frame: CGRect) -> UIBezierPath {
        let spacing: CGFloat = 3
        let numberOfLines = CGFloat(numberOfLines)
        let height = frame.height
        let lineHeight = CGFloat((height - ((numberOfLines - 1) * spacing))/numberOfLines)
        let totalPath = UIBezierPath()
        for index in 0..<Int(numberOfLines) {
            let lineFrame = CGRect(x: CGFloat(0),
                                   y: (lineHeight + spacing)*CGFloat(index),
                                   width: frame.width,
                                   height: lineHeight)
            let linePath = UIBezierPath(roundedRect: lineFrame,
                                        cornerRadius: lineFrame.height/2)
            totalPath.append(linePath)
        }
        return totalPath
    }
    
}
