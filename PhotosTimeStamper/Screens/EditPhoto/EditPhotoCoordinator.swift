//
//  ArticleDetailsCoordinator.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 21.03.2021.
//

import UIKit

protocol EditPhotoCoordinatorType {
    func dismiss()
}

final class EditPhotoCoordinator: EditPhotoCoordinatorType {
    weak var controller: EditPhotoViewController? = Storyboard.editPhoto.instantiateViewController()
    private let navigationController: UINavigationController?
    private var serviceHolder: ServiceHolder!
    
    private var imageModel: StampedImageModel
    
    init(
        navigationController: UINavigationController?,
        serviceHolder: ServiceHolder,
        delegate: SaveImageDelegate?,
        imageModel: StampedImageModel,
        isSaved: Bool
    ) {
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isTranslucent = true
        self.serviceHolder = serviceHolder
        self.imageModel = imageModel
        
        controller?.viewModel = EditPhotoViewModel(
            self,
            serviceHolder: self.serviceHolder,
            delegate: delegate,
            imageModel: imageModel,
            isSaved: isSaved
        )
    }
    
    func start(with delegate: EditPhotoScreenDelegate?) {
        if let controller = controller {
            controller.modalTransitionStyle = .coverVertical
            controller.modalPresentationStyle = .overFullScreen
            controller.delegate = delegate
            navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
    func dismiss() {
        self.controller?.dismiss(animated: false) 
    }
}
