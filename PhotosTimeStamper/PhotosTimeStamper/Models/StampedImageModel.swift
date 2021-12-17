//
//  StampedImageModel.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 17.12.2021.
//

import Foundation
import UIKit

struct StampedImageModel {
    let id: String
    let title: String
    let image: UIImage?
    let stamp: String
    
    static let initial: StampedImageModel = .init(id: "", title: "", image: UIImage(), stamp: "")

    func toCachedData() -> CachedStampedImage? {
        if let data = image?.jpegData(compressionQuality: 1) {
            return .init(
                id: id,
                data: data,
                title: title,
                stamp: stamp
            )
        }
        return nil
    }
}
