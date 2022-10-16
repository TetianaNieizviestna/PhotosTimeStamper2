//
//  NewsCoordinator.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 19.03.2021.
//

import UIKit

class ImageListTabCoordinator: NSObject, TabCoordinatorType, TabBarItemCoordinatorType {
    
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
    func onImageDetails(delegate: SaveImageDelegate?, imageModel: StampedImageModel, isSaved: Bool)
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
    
    func onImageDetails(delegate: SaveImageDelegate?, imageModel: StampedImageModel, isSaved: Bool) {
        let coordinator = EditPhotoCoordinator(
            navigationController: navigationController,
            serviceHolder: serviceHolder,
            delegate: delegate,
            imageModel: imageModel,
            isSaved: isSaved
        )
        coordinator.start(with: controller)
    }
}

