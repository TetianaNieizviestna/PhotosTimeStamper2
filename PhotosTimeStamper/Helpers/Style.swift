//
//  Style.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 20.03.2021.
//

import UIKit

struct Style {
    struct Color {
        static let tabBarSelectedItem = UIColor(hex: "#CE375B")
        static let tabBarItem = UIColor(hex: "#CE375B").withAlphaComponent(0.5)
        static let tabBarBg = UIColor(hex: "#FFD642")
        
        static let tempSettingsIcon = UIColor(hex: "#CE375B")

    }
    
    struct Image {
        static let imageList = UIImage(named: "image_list_ic")
        static let imageListSelected = UIImage(named: "image_list_filled_ic")
        static let support = UIImage(named: "support_ic")
        static let supportSelected = UIImage(named: "support_filled_ic")
        static let settings = UIImage(named: "settings_ic")
        static let settingsSelected = UIImage(named: "settings_filled_ic")
        static let settingsBig = UIImage(named: "settings_big_ic")?.withTintColor(Color.tempSettingsIcon, renderingMode: .alwaysTemplate)
        
        static let locationOn = UIImage(named: "location_ic")
        static let locationOff = UIImage(named: "no-location")
        static let timestampOn = UIImage(named: "timestamp_ic1")
        static let timestampOff = UIImage(named: "no-timestamp")

    }
}
