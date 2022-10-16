//
//  ArticleDetailsViewModel.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 21.03.2021.
//

import Foundation
import UIKit

typealias EditPhotoProps = EditPhotoViewController.Props

protocol SaveImageDelegate: AnyObject {
    func didNewImageSaved()
}

protocol EditPhotoViewModelType {
    var didStateChanged: ((EditPhotoProps) -> Void)? { get set }
}

final class EditPhotoViewModel: EditPhotoViewModelType{
    var didStateChanged: ((EditPhotoProps) -> Void)?

    private let coordinator: EditPhotoCoordinatorType
    private var storageService: ImageStorageServiceType
    private var delegate: SaveImageDelegate?
    
    private var imageId: String
    private var title: String
    private var image: UIImage?
    private var timestampText: String
    private var locationText: String

    private var isSaved = false
    
    init(
        _ coordinator: EditPhotoCoordinatorType,
        serviceHolder: ServiceHolder,
        delegate: SaveImageDelegate?,
        imageModel: StampedImageModel,
        isSaved: Bool
    ) {
        self.coordinator = coordinator
        self.delegate = delegate
        
        storageService = serviceHolder.get(by: ImageStorageServiceType.self)

        self.isSaved = isSaved
        
        imageId = imageModel.id
        title = imageModel.title
        timestampText = imageModel.stamp
        locationText = imageModel.locationText
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
        isSaved = self.timestampText == text
        timestampText = text

        updateProps()
    }
    
    private func setLocation(text: String) {
        isSaved = locationText == text
        locationText = text

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
            stamp: timestampText,
            locationText: locationText
        )
        storageService.saveImage(imageData: imageData)
        isSaved = true
        delegate?.didNewImageSaved()
        updateProps()
    }

    private func updateProps() {
        let props = EditPhotoProps(
            title: title,
            image: image,
            stamp: timestampText,
            location: locationText,
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
            onSetLocation: CommandWith { [weak self] text in
                self?.setLocation(text: text)
            },
            onBack: Command { [weak self] in
                self?.coordinator.dismiss()
            }
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.didStateChanged?(props)
        }
    }
}
