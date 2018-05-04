//
//  CoverableView+UIKit.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 04/05/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

extension CoverableView where Self: UIView {
    
    /**
     usefull to discard small iOS stuff
     for example UIScrollView' scroll indicators are UIImageViews
     */
    var isCoverable: Bool {
        return bounds.width > 20 && bounds.height > 20
    }
    
}

extension UIImageView: CoverableView {
    
    var coverablePath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds,
                            cornerRadius: layer.cornerRadius)
    }

}

extension UIButton: CoverableView {
    
    var coverablePath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds,
                            cornerRadius: layer.cornerRadius)
    }
    
}

extension UILabel: CoverableView {
    
    private var numberOfVisibleLines: Int {
        guard let font = self.font else { return 1 }
        return max(1, Int(bounds.height/font.lineHeight))
    }
    
    var coverablePath: UIBezierPath {
        return .multiLinePath(numberOfLines: numberOfVisibleLines, bounds: bounds)
    }
    
}


extension UITextView: CoverableView {
    
    private var numberOfVisibleLines: Int {
        guard let font = self.font else { return 1 }
        return max(1, Int(bounds.height/font.lineHeight))
    }
    
    var coverablePath: UIBezierPath {
        return .multiLinePath(numberOfLines: numberOfVisibleLines, bounds: bounds)
    }
    
}

extension UISegmentedControl: CoverableView {
    
    var coverablePath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds,
                            cornerRadius: 5)
    }
    
}

extension UITableViewCell: CoverableView {
    
    var coverablePath: UIBezierPath {
        return coverableSubviews()
            .reduce(UIBezierPath(), { totalBezierPath, coverableView in
                coverableView.addCoverablePath(to: totalBezierPath, superview: self)
                return totalBezierPath
            })
    }
    
}

extension UITableView: CoverableView {
    
    var coverablePath: UIBezierPath {
        let identifiers = [
            "AvatarAndLabelCell",
            "AvatarAndLabelCell",
            "TextViewAndSegmentControllCell",
            "TextViewAndSegmentControllCell",
            "TextViewAndSegmentControllCell",
            "TextViewAndSegmentControllCell",
            "TextViewAndSegmentControllCell",
            "TextViewAndSegmentControllCell",
            "AvatarAndLabelCell",
            "AvatarAndLabelCell"
        ]
        var index = 0
        return identifiers.reduce(UIBezierPath(), { totalPath, identifier in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            cell.frame = rectForRow(at: indexPath)
            if let cellCoverablePath = cell.makeCoverablePath(superview: cell) {
                cellCoverablePath.translate(to: CGPoint(x: 0, y: cell.frame.origin.y))
                totalPath.append(cellCoverablePath)
            }
            index += 1
            return totalPath
        })
    }
    
}
