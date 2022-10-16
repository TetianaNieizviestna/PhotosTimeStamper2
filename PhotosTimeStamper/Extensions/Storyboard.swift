//
//  Storyboard.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 19.03.2021.
//

import UIKit

struct Storyboard {
    static let images = UIStoryboard(name: "ImageList", bundle: nil)
    static let settings = UIStoryboard(name: "Settings", bundle: nil)
    static let editPhoto = UIStoryboard(name: "EditPhoto", bundle: nil)

}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self.self)
    }
}

extension UIStoryboard {
    func instantiateViewController<T: StoryboardIdentifiable>() -> T? {
        return instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
    }
}

extension UIViewController: StoryboardIdentifiable { }
