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
        return bounds.width > 10 && bounds.height > 10
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
    
    private struct AssociatedObjectKey {
        static var coverableCellsIdentifiers: String = "coverableCellsIdentifiers"
    }
    
    open var coverableCellsIdentifiers: [String]? {
        get {
            return objc_getAssociatedObject(self,
                                              &AssociatedObjectKey.coverableCellsIdentifiers) as? [String]
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedObjectKey.coverableCellsIdentifiers,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var coverablePath: UIBezierPath {
        guard
            let coverableCellsIdentifiers = coverableCellsIdentifiers
            else { return makeCoverablePathFromVisibleCells() }
        return makeCoverablePath(from: coverableCellsIdentifiers)
    }
    
    private func makeCoverablePath(from coverableCellsIdentifiers: [String]) -> UIBezierPath {
        var height: CGFloat = 0
        return coverableCellsIdentifiers.reduce(UIBezierPath(), { totalPath, identifier in
            guard
                let cell = dequeueReusableCell(withIdentifier: identifier)
                else { return totalPath }
            cell.frame = CGRect(x: 0, y: height, width: frame.width, height: cell.frame.height)
            if let cellCoverablePath = cell.makeCoverablePath(superview: cell) {
                cellCoverablePath.translate(to: CGPoint(x: 0, y: cell.frame.origin.y))
                totalPath.append(cellCoverablePath)
            }
            height += cell.frame.height
            return totalPath
        })
    }
    
    private func makeCoverablePathFromVisibleCells() -> UIBezierPath {
        return visibleCells.coverablePath
    }
    
}

extension Array where Element: CoverableView {
    
    var coverablePath: UIBezierPath {
        return reduce(UIBezierPath(), { totalPath, cell in
            guard
                let cellPath = cell.makeCoverablePath()
                else { return totalPath }
            totalPath.append(cellPath)
            return totalPath
        })
    }
    
}

extension UICollectionView: CoverableView {
    
    var coverablePath: UIBezierPath {
        return visibleCells.coverablePath
    }
}

extension UICollectionViewCell: CoverableView {
    
    var coverablePath: UIBezierPath {
        return coverableSubviews()
            .reduce(UIBezierPath(), { totalBezierPath, coverableView in
                coverableView.addCoverablePath(to: totalBezierPath, superview: self)
                return totalBezierPath
            })
    }
    
}
