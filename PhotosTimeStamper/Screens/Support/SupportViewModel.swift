//
//  SupportViewModel.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 22.10.2022.
//

import Foundation
typealias SupportProps = SupportViewController.Props

protocol SupportViewModelType {
    var didStateChanged: ((SupportProps) -> Void)? { get set }
    
    func loadData()
}

final class SupportViewModel: SupportViewModelType {
    var didStateChanged: ((SupportProps) -> Void)?

    private let coordinator: SupportCoordinatorType

    private var items: [MenuItem] = [
        .supportEmail
    ]

    private var screenState: SupportProps.ScreenState = .initial
    
    init(_ coordinator: SupportCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
    }
    
    func loadData() {
        setScreenState(.loaded)
    }
    
    private func setScreenState(_ state: SupportProps.ScreenState) {
        screenState = state
        updateProps()
    }

    private func createItems() -> [MenuTableViewCell.Props] {
        return items.map { createCellProps($0) }
    }
    
    private func createCellProps(_ item: MenuItem) -> MenuTableViewCell.Props {
        return .init(
            itemType: item,
            onSelect: Command { [weak self] in
                guard let self = self else { return }
                self.coordinator.openEmail(emailModel: self.createMessage())
            }
        )
    }
    
    private func createMessage() -> EmailMessageModel {
        return .init(
            subject: "PhotosTimeStamper feedback",
            messageBody: SupportMessageCreator.createMessage()
        )
    }
    
    private func updateProps() {
        let props = SupportProps(
            state: screenState,
            title: "Support",
            appVersionText: "App version: \(SupportMessageCreator.getAppVersion())",
            onSave: .nop,
            items: createItems()
        )
        DispatchQueue.main.async { [weak self] in
            self?.didStateChanged?(props)
        }
    }
}
