//
//  Style.swift
//  ViVNewsApp
//
//  Created by Tetiana Nieizviestna on 20.03.2021.
//

import UIKit

struct Style {
    struct Color {
        static let tabBarItem = UIColor(red: 0, green: 0, blue: 50, alpha: 0.5)
        static let tabBarItemSelected = UIColor(red: 0, green: 0, blue: 50, alpha: 0.7)
        
        static let segmentText = UIColor.white
        
        static let segmentBg = UIColor(red: 0, green: 0, blue: 50, alpha: 0.3)
        static let segmentBgSelected = UIColor(red: 0, green: 0, blue: 50, alpha: 0.6)

    }
    
    struct Image {
        static let news = UIImage(named: "news")
        static let newsSelected = UIImage(named: "news_filled")
        static let favourite = UIImage(named: "favorites")
        static let favouriteSelected = UIImage(named: "favorites_filled")
    }
}
