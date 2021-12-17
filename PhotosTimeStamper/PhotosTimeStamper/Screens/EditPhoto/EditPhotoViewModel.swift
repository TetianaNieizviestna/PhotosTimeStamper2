//
//  ArticleDetailsViewModel.swift
//  ViVNewsApp
//
//  Created by Tetiana Nieizviestna on 21.03.2021.
//

import Foundation
import UIKit
typealias EditPhotoProps = EditPhotoViewController.Props

protocol EditPhotoViewModelType {
    var didStateChanged: ((EditPhotoProps) -> Void)? { get set }
    
    func setImage(_ image: UIImage, path: String)
    func changeTitle(text: String)
    func setStamp(text: String)
}

final class EditPhotoViewModel: EditPhotoViewModelType{
    var didStateChanged: ((EditPhotoProps) -> Void)?

    private let coordinator: EditPhotoCoordinatorType
    private var imageId: String
    private var title: String
    private var image: UIImage?
    private var stamp: String

    init(_ coordinator: EditPhotoCoordinatorType, serviceHolder: ServiceHolder, imageModel: StampedImageModel) {
        self.coordinator = coordinator
        
        imageId = imageModel.id
        title = imageModel.title
        stamp = imageModel.stamp
        image = imageModel.image
        
        loadImageData()
    }
    
    private func loadImageData() {
        updateProps()
    }
    
    func setImage(_ image: UIImage, path: String) {
        if imageId.isEmpty {
            imageId = generateId(path: path)
        }
        self.image = image
        updateProps()
    }
    
    func changeTitle(text: String) {
        title = text
        updateProps()
    }
    
    func setStamp(text: String) {
        stamp = text
        updateProps()
    }
    
    private func generateId(path: String) -> String {
        return "\(path)\(Date().timeIntervalSinceReferenceDate)"
    }

    private func updateProps() {
        let props = EditPhotoProps(
            title: title,
            image: image,
            stamp: stamp,
            onBack: Command {
                self.coordinator.dismiss()
            }
        )
        DispatchQueue.main.async {
            self.didStateChanged?(props)
        }
    }
}
