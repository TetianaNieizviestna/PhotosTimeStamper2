//
//  SettingsViewModel.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 16.10.2022.
//

import Foundation

typealias SettingsProps = SettingsViewController.Props

protocol SettingsViewModelType {
    var didStateChanged: ((SettingsProps) -> Void)? { get set }
}

final class SettingsViewModel: SettingsViewModelType {
    var didStateChanged: ((SettingsProps) -> Void)?

    private let coordinator: SettingsCoordinatorType
    private var storageService: ImageStorageServiceType

    private var images: [StampedImageModel] = []

    private var screenState: SettingsProps.ScreenState = .initial
    
    init(_ coordinator: SettingsCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        
        storageService = serviceHolder.get(by: ImageStorageServiceType.self)
        loadImages()
    }
    
    private func setScreenState(_ state: SettingsProps.ScreenState) {
        screenState = state
        updateProps()
    }
    
    private func loadImages() {
        setScreenState(.loading)
        images = storageService.getImages()
        setScreenState(.loaded)
    }
    
    private func refresh() {
        loadImages()
    }

    private func createItems() -> [StampedImageTableViewCell.Props] {
        return images.map { self.createCellProps($0) }
    }
    
    private func createCellProps(_ imageModel: StampedImageModel) -> StampedImageTableViewCell.Props {
        return .initial
    }
    
    private func updateProps() {
        let props = SettingsProps(
            state: self.screenState,
            title: "Settings",
            tempLabelText: "This page is under contructions...\nIt will be available in the next updates",
            onSave: .nop,
            onRefresh: Command { [weak self] in
                self?.refresh()
            },
            items: createItems()
        )
        DispatchQueue.main.async {
            self.didStateChanged?(props)
        }
    }
}

extension SettingsViewModel: SaveImageDelegate {
    func didNewImageSaved() {
        refresh()
    }
}
