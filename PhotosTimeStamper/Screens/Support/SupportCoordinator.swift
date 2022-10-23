//
//  SupportCoordinator.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 22.10.2022.
//

import UIKit
import MessageUI

class SupportTabBarCoordinator: NSObject, TabCoordinatorType, TabBarItemCoordinatorType {
    
    let controller = UINavigationController()

    private var serviceHolder: ServiceHolder
    private var newsCoordinator: SupportCoordinator?
    
    init(serviceHolder: ServiceHolder) {
        self.serviceHolder = serviceHolder
    }
    
    func start() {
        controller.navigationBar.isTranslucent = false
        
        newsCoordinator = SupportCoordinator(navigationController: controller, serviceHolder: serviceHolder)
        newsCoordinator?.start()
    }
}

protocol SupportCoordinatorType {
    func openEmail(emailModel: EmailMessageModel)
    func showAbout()
}

final class SupportCoordinator: NSObject, SupportCoordinatorType {
    weak var controller: SupportViewController? = Storyboard.support.instantiateViewController()
    private let navigationController: UINavigationController?
    private var serviceHolder: ServiceHolder!
    
    init(navigationController: UINavigationController?, serviceHolder: ServiceHolder) {
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        self.serviceHolder = serviceHolder
        super.init()

        
        controller?.viewModel = SupportViewModel(self, serviceHolder: self.serviceHolder)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    func openEmail(emailModel: EmailMessageModel) {
        guard MFMailComposeViewController.canSendMail() == true else { return }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([Defines.Support.email])
        mail.setSubject(emailModel.subject)
        mail.setMessageBody(emailModel.messageBody, isHTML: false)
        navigationController?.present(mail, animated: true)
    }
    
    func showAbout() {
        navigationController?.showAlert(
            title: "About Us",
            message: "The iPhone application that shows the real time of creation and location of any picture.\nYou can save, share, print the picture with a timestamp."
        )
    }
}

extension SupportCoordinator: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        navigationController?.dismiss(animated: true)
    }
}
