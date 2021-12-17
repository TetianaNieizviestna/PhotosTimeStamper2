//
//  CacheHelper.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 17.12.2021.
//

import UIKit

struct CachedStampedImage: Codable {
    let id: String // url
    let data: Data
    let title: String
    let stamp: String
    
    func toImage() -> StampedImageModel? {
        if let image = UIImage(data: data) {
            return .init(
                id: id,
                title: title,
                image: image,
                stamp: stamp
            )
        }
        return nil
    }
}

class CacheHelper {
    static let shared: CacheHelper = CacheHelper()
    
    enum Keys {
        static let cachedStampedImages = "cachedStampedImages"
    }
    
    func getImages() -> [StampedImageModel] {
        return getImagesData().compactMap { $0.toImage() }
    }
    
    func getImagesData() -> [CachedStampedImage] {
        if let products = CacheHelper.shared.getData(for: Keys.cachedStampedImages, type: [CachedStampedImage].self) {
            return products
        }
        return []
    }
    
    func addImage(_ stampedImage: StampedImageModel) {
        var products = getImagesData()
        if !products.contains(where: { $0.id == stampedImage.id}) {
            if let data = stampedImage.toCachedData() {
                products.append(data)
            }
        }
        CacheHelper.shared.saveData(key: Keys.cachedStampedImages, object: products)
    }
    
    func saveData<T: Codable>(key: String, object: T) {
        if let data = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }

    func getData<T: Codable>(for key: String, type: T.Type) -> T? {
        if let data = UserDefaults.standard.data(forKey: key) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
}
