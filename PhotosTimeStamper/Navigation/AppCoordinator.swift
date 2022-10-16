//
//  AppCoordinator.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 19.03.2021.
//

import Foundation
import UIKit

final class AppCoordinator {
    private var navigationController: UINavigationController?
    private let window: UIWindow
    
    private var serviceHolder: ServiceHolder!

    private var imageStorageService: ImageStorageService!

    private var tabBarCoordinator: TabBarCoordinator?

    private var imageListCoordinator: ImageListCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        
        startServices()
    }
    
    private func startServices() {
        serviceHolder = ServiceHolder()
        
        imageStorageService = ImageStorageService()
        
        serviceHolder.add(ImageStorageServiceType.self, for: imageStorageService)
    }
    
    func start() {
        tabBarCoordinator = TabBarCoordinator(window: window, serviceHolder: serviceHolder)
        tabBarCoordinator?.start()
    }
}
