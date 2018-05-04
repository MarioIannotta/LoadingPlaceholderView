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
        let coverablePath = UIBezierPath()
        var currentHeight: CGFloat = 0
        let numberOfSection = 2//dataSource?.numberOfSections?(in: self) ?? 0
        for section in 0..<numberOfSection {
            let numberOfRows = 5//dataSource?.tableView(self, numberOfRowsInSection: section) ?? 0
            for row in 0..<numberOfRows {
                guard
                    let cell = dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: section))
                    else { continue }
                cell.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: cell.frame.size.height)
                guard
                    let cellCoverablePath = cell.makeCoverablePath(superview: cell)
                    else { continue }
                print(cell.frame)
                cellCoverablePath.translate(to: CGPoint(x: 0, y: currentHeight))
                coverablePath.append(cellCoverablePath)
                currentHeight += cell.frame.height
            }
        }
        return coverablePath
    }
    
}
