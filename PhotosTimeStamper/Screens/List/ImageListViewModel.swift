//
//  NewsViewModel.swift
//  ViVNewsApp
//
//  Created by Tetiana Nieizviestna on 19.03.2021.
//

import Foundation

typealias ImageListProps = ImageListViewController.Props

protocol ImageListViewModelType {
    var didStateChanged: ((ImageListProps) -> Void)? { get set }
    
    func refresh()
    func addNewPhotoScreen()
}

final class ImageListViewModel: ImageListViewModelType {
    var didStateChanged: ((ImageListProps) -> Void)?

    private let coordinator: ImageListCoordinatorType
    private var storageService: ImageStorageServiceType

    private var images: [StampedImageModel] = []

    private var screenState: ImageListProps.ScreenState = .initial
    
    init(_ coordinator: ImageListCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        
        storageService = serviceHolder.get(by: ImageStorageServiceType.self)
        loadImages()
    }
    
    private func setScreenState(_ state: ImageListProps.ScreenState) {
        screenState = state
        updateProps()
    }
    
    private func loadImages() {
        setScreenState(.loading)
        images = storageService.getImages()
        setScreenState(.loaded)
    }
    
    func refresh() {
        loadImages()
    }

    private func createItems() -> [StampedImageTableViewCell.Props] {
        return images.map { self.createCellProps($0) }
    }
    
    private func createCellProps(_ imageModel: StampedImageModel) -> StampedImageTableViewCell.Props {
        return .init(
            imageData: imageModel,
            onSelect: Command {
                self.coordinator.onImageDetails(imageModel: imageModel)
            }
        )
    }
    
    func updateProps() {
        let props = ImageListProps(
            state: self.screenState,
            onRefresh: Command {
                self.refresh()
            },
            items: self.createItems()
        )
        DispatchQueue.main.async {
            self.didStateChanged?(props)
        }
    }
    
    func addNewPhotoScreen() {
        coordinator.onImageDetails(imageModel: StampedImageModel.initial)
    }
}
