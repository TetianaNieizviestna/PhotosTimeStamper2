//
//  ArticleDetailsViewModel.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 21.03.2021.
//

import Foundation
import UIKit
typealias EditPhotoProps = EditPhotoViewController.Props

protocol EditPhotoViewModelType {
    var didStateChanged: ((EditPhotoProps) -> Void)? { get set }
}

final class EditPhotoViewModel: EditPhotoViewModelType{
    var didStateChanged: ((EditPhotoProps) -> Void)?

    private let coordinator: EditPhotoCoordinatorType
    private var storageService: ImageStorageServiceType

    private var imageId: String
    private var title: String
    private var image: UIImage?
    private var stamp: String
    
    private var isSaved = false
    
    init(_ coordinator: EditPhotoCoordinatorType, serviceHolder: ServiceHolder, imageModel: StampedImageModel, isSaved: Bool) {
        self.coordinator = coordinator
        storageService = serviceHolder.get(by: ImageStorageServiceType.self)

        self.isSaved = isSaved
        
        imageId = imageModel.id
        title = imageModel.title
        stamp = imageModel.stamp
        image = imageModel.image
        
        loadImageData()
    }
    
    private func loadImageData() {
        updateProps()
    }
    
    private func setImage(_ image: UIImage, path: String) {
        if imageId.isEmpty {
            imageId = generateId(path: path)
        }
        isSaved = false
        self.image = image
        updateProps()
    }
    
    private func changeTitle(text: String) {
        isSaved = text == title
        
        title = text
        updateProps()
    }
    
    private func setStamp(text: String) {
        isSaved = self.stamp == text
        stamp = "DATE: \(text)"

        updateProps()
    }
    
    private func generateId(path: String) -> String {
        return "\(path)\(Date().timeIntervalSinceReferenceDate)"
    }
    
    private func saveImageInList() {
        let imageData = StampedImageModel(
            id: imageId,
            title: title,
            image: image,
            stamp: stamp
        )
        storageService.saveImage(imageData: imageData)
    }

    private func updateProps() {
        let props = EditPhotoProps(
            title: title,
            image: image,
            stamp: stamp,
            isSaved: isSaved,
            onSetTitle: CommandWith { [weak self] text in
                self?.changeTitle(text: text)
                self?.saveImageInList()
            },
            onSetImage: CommandWith { [weak self] image, path in
                self?.setImage(image, path: path)
            },
            onSetStamp: CommandWith { [weak self] text in
                self?.setStamp(text: text)
            },
            onBack: Command { [weak self] in
                self?.coordinator.dismiss()
            }
        )
        DispatchQueue.main.async {
            self.didStateChanged?(props)
        }
    }
}
