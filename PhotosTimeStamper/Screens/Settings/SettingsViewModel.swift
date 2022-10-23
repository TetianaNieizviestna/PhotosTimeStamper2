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
    
    func loadData()
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
    }
    
    private func setScreenState(_ state: SettingsProps.ScreenState) {
        screenState = state
        updateProps()
    }

    private func createItems() -> [StampedImageTableViewCell.Props] {
        return images.map { self.createCellProps($0) }
    }
    
    private func createCellProps(_ imageModel: StampedImageModel) -> StampedImageTableViewCell.Props {
        return .initial
    }
    
    func loadData() {
        setScreenState(.loaded)
    }
    
    private func updateProps() {
        let props = SettingsProps(
            state: screenState,
            title: "Settings",
            tempLabelText: "This page is under contructions...\nIt will be available in the next updates",
            onSave: .nop,
            items: createItems()
        )
        DispatchQueue.main.async { [weak self] in
            self?.didStateChanged?(props)
        }
    }
}
