//
//  UIViewController+Alert.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 20.03.2021.
//

import UIKit

struct AlertOption {
    let title: String
    let action: Command
    var style: UIAlertAction.Style = .default
}

struct AlertOptionWithText {
    let title: String
    let action: CommandWith<String>
    let style: UIAlertAction.Style = .default
}

extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default) { (_: UIAlertAction) in
            alertVC.dismiss(animated: true, completion: completion)
        }
        
        alertVC.addAction(okay)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showAlertWithOptions(title: String, message: String, options: [AlertOption]) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        options.forEach { alertOption in
            let alertAction = UIAlertAction(title: alertOption.title, style: alertOption.style, handler: { _ in
                alertVC.dismiss(animated: true, completion: {
                    alertOption.action.perform()
                })
            })
            alertVC.addAction(alertAction)
        }
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showAlertWithOptionsAndInput(title: String, message: String, options: [AlertOptionWithText]) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertVC.addTextField { (textField) in
            textField.text = "Title"
        }

        options.forEach { alertOption in
            let alertAction = UIAlertAction(title: alertOption.title, style: alertOption.style, handler: { _ in
                alertVC.dismiss(animated: true, completion: {
                    if let textField = alertVC.textFields?[0],
                       let text = textField.text {
                        alertOption.action.perform(with: text)
                    }
                })
            })
            alertVC.addAction(alertAction)
        }
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
