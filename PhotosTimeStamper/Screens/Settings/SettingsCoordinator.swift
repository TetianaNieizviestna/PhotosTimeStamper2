//
//  SettingsCoordinator.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 16.10.2022.
//

import UIKit

class SettingsTabBarCoordinator: NSObject, TabCoordinatorType, TabBarItemCoordinatorType {
    
    let controller = UINavigationController()

    private var serviceHolder: ServiceHolder
    private var newsCoordinator: SettingsCoordinator?
    
    init(serviceHolder: ServiceHolder) {
        self.serviceHolder = serviceHolder
    }
    
    func start() {
        controller.navigationBar.isTranslucent = false
        
        newsCoordinator = SettingsCoordinator(navigationController: controller, serviceHolder: serviceHolder)
        newsCoordinator?.start()
    }
}

protocol SettingsCoordinatorType {}

final class SettingsCoordinator: SettingsCoordinatorType {
    weak var controller: SettingsViewController? = Storyboard.settings.instantiateViewController()
    private let navigationController: UINavigationController?
    private var serviceHolder: ServiceHolder!
    
    init(navigationController: UINavigationController?, serviceHolder: ServiceHolder) {
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        self.serviceHolder = serviceHolder
        controller?.viewModel = SettingsViewModel(self, serviceHolder: self.serviceHolder)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: false)
        }
    }
}

