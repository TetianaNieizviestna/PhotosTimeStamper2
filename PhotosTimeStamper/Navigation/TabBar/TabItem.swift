//
//  TabItem.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 19.03.2021.
//

import UIKit

enum TabItem: Equatable {
    static func == (lhs: TabItem, rhs: TabItem) -> Bool {
        return lhs.index == rhs.index
    }
    
    case imageList(TabBarItemCoordinatorType)
    case settings(TabBarItemCoordinatorType)
    case support(TabBarItemCoordinatorType)
    
    var item: UITabBarItem {
        let item = UITabBarItem(title: displayTitle, image: icon, selectedImage: iconFill)
        item.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Style.Color.tabBarSelectedItem], for: .selected)
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Style.Color.tabBarItem], for: .normal)
        
        UITabBar.appearance().tintColor = Style.Color.tabBarSelectedItem
        UITabBar.appearance().unselectedItemTintColor = Style.Color.tabBarItem
        UITabBar.appearance().backgroundColor = Style.Color.tabBarBg

        return item
    }
    
    var index: Int {
        switch self {
        case .imageList:
            return 0
        case .support:
            return 1
        case .settings:
            return 2
        }
    }
    
    var controller: UINavigationController? {
        var controller: UINavigationController?
        switch self {
        case .imageList(let coordinator):
             controller = coordinator.controller
        case .support(let coordinator):
            controller = coordinator.controller
        case .settings(let coordinator):
            controller = coordinator.controller
        }
        controller?.tabBarItem = item
        return controller
    }
    
    var icon: UIImage? {
        var image: UIImage?
        switch self {
        case .imageList:
            image = Style.Image.imageList
        case .support:
            image = Style.Image.support
        case .settings:
            image = Style.Image.settings
        }
        return image?.withRenderingMode(.alwaysTemplate).withTintColor(Style.Color.tabBarItem)
    }
    
    var iconFill: UIImage? {
        var image: UIImage?
        switch self {
        case .imageList:
            image = Style.Image.imageListSelected
        case .support:
            image = Style.Image.supportSelected
        case .settings:
            image = Style.Image.settingsSelected
        }
        return image?.withRenderingMode(.alwaysTemplate).withTintColor(Style.Color.tabBarSelectedItem)
    }
    
    var displayTitle: String {
        switch self {
        case .imageList:
            return "Images"
        case .support:
            return "Support"
        case .settings:
            return "Settings"
        }
    }
}
