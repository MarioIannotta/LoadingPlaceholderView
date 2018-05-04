//
//  LoadingPlaceholderView.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 28/04/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

class LoadingPlaceholderView: UIView {
    
    var configuration = Configuration()
    
    private var viewToCover: UIView?
    private var maskLayer = CAShapeLayer()
    private var gradientLayer = CAGradientLayer()
    private var viewToConverObservation: NSKeyValueObservation?
    private var isLoading: Bool {
        return superview != nil
    }
    
    public func cover(_ viewToCover: UIView, configuration: Configuration? = nil) {
        if let configuration = configuration {
            self.configuration = configuration
        }
        setupView(viewToCover: viewToCover)
    }
    
    public func startLoading(animated: Bool) {
        guard !isLoading, let viewToCover = viewToCover else { return }
        viewToCover.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        frame = viewToCover.bounds
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: viewToCover.topAnchor),
            bottomAnchor.constraint(equalTo: viewToCover.bottomAnchor),
            leftAnchor.constraint(equalTo: viewToCover.leftAnchor),
            rightAnchor.constraint(equalTo: viewToCover.rightAnchor)
            ])
        setupMaskLayerIfNeeded()
        setupGradientLayerIfNeeded()
        setupGradientLayerAnimation()
        if animated {
            performFadeInAnimation()
        }
    }
    
    public func stopLoading(animated: Bool) {
        guard isLoading else { return }
        if animated {
            performFadeOutAnimation()
        }
        let dispatchTime: DispatchTime = .now() + configuration.fadeAnimationDuration
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) { [weak self] in
            self?.removeGradientAndMask()
            self?.removeFromSuperview()
        }
    }
    
    deinit {
        viewToConverObservation = nil
    }
    
    private func setupView(viewToCover: UIView) {
        self.viewToCover = viewToCover
        self.frame = viewToCover.bounds
        self.backgroundColor = configuration.backgroundColor
        viewToConverObservation = observe(\.bounds) { [weak self] _, _ in
            if self?.isLoading == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.setupMaskLayerIfNeeded()
                    self?.setupGradientLayerIfNeeded()
                }
            }
        }
    }
    
    private func setupMaskLayerIfNeeded() {
        guard let superview = superview else { return }
        maskLayer.frame = superview.bounds
        let toalBezierPath = superview
            .coverableSubviews()
            .reduce(UIBezierPath(), { totalBezierPath, coverableView in
                coverableView.addCoverablePath(to: totalBezierPath, superview: superview)
                return totalBezierPath
            })
        maskLayer.path = toalBezierPath.cgPath
        maskLayer.fillColor = UIColor.red.cgColor
        layer.addSublayer(maskLayer)
    }
    
    private func setupGradientLayerIfNeeded() {
        guard let superview = superview else { return }
        
        gradientLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: superview.bounds.size.width,
                                     height: superview.bounds.size.height)
        superview.layer.addSublayer(gradientLayer)
        gradientLayer.startPoint = CGPoint(x: -1 - configuration.gradientWidth*2, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1 + configuration.gradientWidth*2, y: 0)
        
        gradientLayer.colors = [
            configuration.gradient.backgroundColor.cgColor,
            configuration.gradient.primaryColor.cgColor,
            configuration.gradient.secondaryColor.cgColor,
            configuration.gradient.primaryColor.cgColor,
            configuration.gradient.backgroundColor.cgColor
        ]
        
        let startLocations = [NSNumber(value: Double(gradientLayer.startPoint.x)),
                              NSNumber(value: Double(gradientLayer.startPoint.x)),
                              NSNumber(value: 0),
                              NSNumber(value: configuration.gradientWidth),
                              NSNumber(value: 1 + configuration.gradientWidth)]
        
        gradientLayer.locations = startLocations
        gradientLayer.cornerRadius = superview.layer.cornerRadius
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = maskLayer
    }
    
    private func setupGradientLayerAnimation() {
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = gradientLayer.locations
        gradientAnimation.toValue = [NSNumber(value: 0),
                                     NSNumber(value: 1),
                                     NSNumber(value: 1),
                                     NSNumber(value: 1 + configuration.gradientWidth),
                                     NSNumber(value: 1 + configuration.gradientWidth)]
        
        gradientAnimation.repeatCount = .infinity
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.duration = configuration.loadingAnimationDuration
        gradientLayer.add(gradientAnimation, forKey: "locations")
    }
    
    private func performFadeInAnimation() {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = alpha
        opacityAnimation.toValue = 1
        opacityAnimation.duration = configuration.fadeAnimationDuration
        gradientLayer.add(opacityAnimation, forKey: "opacityAnimationIn")
        
        UIView.animate(withDuration: configuration.fadeAnimationDuration) {
            self.alpha = 0.8
        }
    }
    
    private func performFadeOutAnimation() {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = alpha
        opacityAnimation.toValue = 0
        opacityAnimation.duration = configuration.fadeAnimationDuration
        gradientLayer.add(opacityAnimation, forKey: "opacityAnimationOut")
        
        UIView.animate(withDuration: configuration.fadeAnimationDuration) {
            self.alpha = 0
        }
    }
    
    private func removeGradientAndMask() {
        gradientLayer.removeAllAnimations()
        gradientLayer.removeFromSuperlayer()
        maskLayer.removeFromSuperlayer()
    }
    
}
