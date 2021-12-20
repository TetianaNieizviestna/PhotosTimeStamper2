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
    
    var item: UITabBarItem {
        let item = UITabBarItem(title: displayTitle, image: icon, selectedImage: iconFill)
        
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Style.Color.tabBarItemSelected], for: .selected)
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Style.Color.tabBarItem], for: .normal)
        
        UITabBar.appearance().tintColor = Style.Color.tabBarItem
        UITabBar.appearance().unselectedItemTintColor = Style.Color.tabBarItem

        return item
    }
    
    var index: Int {
        switch self {
        case .imageList:
            return 0
        }
    }
    
    var controller: UINavigationController? {
        var controller: UINavigationController?
        switch self {
        case .imageList(let coordinator):
             controller = coordinator.controller
        }
        controller?.tabBarItem = item
        return controller
    }
    
    var icon: UIImage? {
        var image: UIImage?
        switch self {
        case .imageList:
            image = Style.Image.news
        }
        return image?.withRenderingMode(.alwaysOriginal).withTintColor(Style.Color.tabBarItem)
    }
    
    var iconFill: UIImage? {
        var image: UIImage?
        switch self {
        case .imageList:
            image = Style.Image.newsSelected
        }
        return image?.withRenderingMode(.alwaysOriginal).withTintColor(Style.Color.tabBarItemSelected)
    }
    
    var displayTitle: String {
        switch self {
        case .imageList:
            return "Images"
        }
    }
}
