//
//  UIView.swift
//  ViVNewsApp
//
//  Created by Tetiana Nieizviestna on 21.03.2021.
//

import UIKit
import NVActivityIndicatorView

// MARK: Round Corners
extension UIView {
    func setCornersRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func roundCorners() {
        superview?.layoutIfNeeded()
        setCornersRadius(frame.height / 2)
    }
}

// MARK: Activity Indicator
extension UIView {
    private var activityIndicator: NVActivityIndicatorView? {
        self.subviews.first { $0 is NVActivityIndicatorView } as? NVActivityIndicatorView
    }
    
    var animating: Bool {
        return activityIndicator?.isAnimating ?? false
    }
    
    func startHud(_ frame: CGRect? = nil) {
        guard animating == false else { return }
        if activityIndicator == nil { addActivityIndicatorView(frame) }
        activityIndicator?.startAnimating()
    }
    
    func stopHud() {
        activityIndicator?.stopAnimating()
    }
    
    private func addActivityIndicatorView(_ frame: CGRect? = nil) {
        let frame = frame ?? CGRect(x: self.center.x - 20, y: self.center.y - 20, width: 40, height: 40)
        let activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballClipRotateMultiple, color: .blue)
        self.addSubview(activityIndicator)
    }
}
