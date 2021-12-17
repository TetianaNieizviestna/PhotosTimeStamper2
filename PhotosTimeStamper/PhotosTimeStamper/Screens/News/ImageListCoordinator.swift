//
//  NewsCoordinator.swift
//  ViVNewsApp
//
//  Created by Tetiana Nieizviestna on 19.03.2021.
//

import UIKit

protocol NewsTabCoordinatorType {}

class ImageListTabCoordinator: NSObject, NewsTabCoordinatorType, TabBarItemCoordinatorType {
    
    let controller = UINavigationController()

    private var serviceHolder: ServiceHolder
    private var newsCoordinator: ImageListCoordinator?
    
    init(serviceHolder: ServiceHolder) {
        self.serviceHolder = serviceHolder
    }
    
    func start() {
        controller.navigationBar.isTranslucent = false
        
        newsCoordinator = ImageListCoordinator(navigationController: controller, serviceHolder: serviceHolder)
        newsCoordinator?.start()
    }
}

protocol ImageListCoordinatorType {
    func onImageDetails(imageModel: StampedImageModel)
}

final class ImageListCoordinator: ImageListCoordinatorType {
    weak var controller: ImageListViewController? = Storyboard.images.instantiateViewController()
    private let navigationController: UINavigationController?
    private var serviceHolder: ServiceHolder!
    
    init(navigationController: UINavigationController?, serviceHolder: ServiceHolder) {
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        self.serviceHolder = serviceHolder
        controller?.viewModel = ImageListViewModel(self, serviceHolder: self.serviceHolder)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    func onImageDetails(imageModel: StampedImageModel) {
        let coordinator = EditPhotoCoordinator(navigationController: navigationController, serviceHolder: serviceHolder, imageModel: imageModel)
        coordinator.start(with: controller)
    }
}

