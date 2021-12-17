//
//  NewsService.swift
//  ViVNewsApp
//
//  Created by Tetiana Nieizviestna on 19.03.2021.
//

import Foundation

protocol ImageStorageServiceType: Service {
    func saveImage(imageData: StampedImageModel)
    func getImages() -> [StampedImageModel]
}

class ImageStorageService: ImageStorageServiceType {
    private var images: [StampedImageModel] = {
        return CacheHelper.shared.getImages()
    }()
    
    func saveImage(imageData: StampedImageModel) {
        CacheHelper.shared.addImage(imageData)
    }
    
    func getImages() -> [StampedImageModel] {
        return images
    }
}
