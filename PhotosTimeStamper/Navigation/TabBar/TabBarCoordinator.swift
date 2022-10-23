//
//  TabBarCoordinator.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 19.03.2021.
//

import UIKit

protocol TabCoordinatorType {}

protocol TabBarItemCoordinatorType {
    var controller: UINavigationController { get }
}

final class TabBarCoordinator: NSObject {
    private let window: UIWindow
    private var rootController: UITabBarController?
    private var serviceHolder: ServiceHolder
    var items: [TabItem] = []
    
    init(window: UIWindow, serviceHolder: ServiceHolder) {
        self.window = window
        self.serviceHolder = serviceHolder
    }
    
    func start() {
        let tabController = UITabBarController()

        let imageList = ImageListTabCoordinator(serviceHolder: serviceHolder)
        let support = SupportTabBarCoordinator(serviceHolder: serviceHolder)
        let settings = SettingsTabBarCoordinator(serviceHolder: serviceHolder)

        items = [
            .imageList(imageList),
            .support(support),
            .settings(settings),
        ]
        imageList.start()
        settings.start()
        support.start()
        
        tabController.viewControllers = items.compactMap { $0.controller }
        tabController.delegate = self
        
        window.rootViewController = tabController
        window.makeKeyAndVisible()

        self.rootController = tabController
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}

// MARK: - TabBarCoordinator {
extension TabBarCoordinator {
    
    func getTabCoordinator<T>(index: Int) -> T? {
        let tabIndex = index
        if tabIndex < items.count {
            return items[tabIndex] as? T
        }
        return nil
    }
    
    func selectTab(index: Int) {
        let tabIndex = index
        rootController?.selectedIndex = tabIndex
        let root = getTabCoordinatorRootNavigation(index: index)
        root?.popViewController(animated: true)
    }
    
    private func getTabCoordinatorRootNavigation(index: Int) -> UINavigationController? {
        let tabIndex = index
        if tabIndex < items.count {
            let tabItem = items[tabIndex]
            return tabItem.controller
        }
        return nil
    }
}
