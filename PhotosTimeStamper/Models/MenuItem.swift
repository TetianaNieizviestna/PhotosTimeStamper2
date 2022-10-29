//
//  MenuItem.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 23.10.2022.
//

import UIKit

enum MenuItem {
    case initial
    case supportEmail
    case appInfo
    case aboutUs
    
    var title: String {
        switch self {
        case .initial:
            return ""
        case .supportEmail:
            return "Send email"
        case .appInfo:
            return "App Info"
        case .aboutUs:
            return "About Us"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .initial:
            return nil
        case .supportEmail:
            return UIImage(named: "email_ic")
        case .appInfo:
            return UIImage(named: "appinfo_ic")
        case .aboutUs:
            return UIImage(named: "about_us_ic")
        }
    }
}
