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
    
    var title: String {
        switch self {
        case .initial:
            return ""
        case .supportEmail:
            return "Send email"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .initial:
            return nil
        case .supportEmail:
            return UIImage(named: "support_ic")
        }
    }
}
