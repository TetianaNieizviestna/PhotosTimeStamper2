//
//  GradientButton.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 20.03.2021.
//

import UIKit

@IBDesignable
public class GradientButton: UIButton {
    @IBInspectable var startColor: UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor: UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double = 0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation: Double = 0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode: Bool = false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode: Bool = false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
}

extension UIButton {
    func setImageForAllStates(_ image: UIImage?) {
        setImage(image, for: .highlighted)
        setImage(image, for: .focused)
        setImage(image, for: .normal)
        setImage(image, for: .selected)
    }
    
    func setTitleForAllStates(_ text: String) {
        setTitle(text, for: .highlighted)
        setTitle(text, for: .focused)
        setTitle(text, for: .normal)
        setTitle(text, for: .selected)
    }
    
    func setTitleColorForAllStates(_ color: UIColor) {
        setTitleColor(color, for: .highlighted)
        setTitleColor(color, for: .focused)
        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .selected)
    }
    
    func setupDefaultButton() {
        imageView?.contentMode = .scaleAspectFit
        let image = imageView?.image?.withTintColor(.red, renderingMode: .alwaysTemplate)
        setImageForAllStates(image)
        setTitleColorForAllStates(.red)
        setCornersRadius(6)
        tintColor = .red
    }
}
