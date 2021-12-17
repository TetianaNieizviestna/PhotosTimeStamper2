//
//  UIImagePicker+Permissons.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 17.12.2021.
//

import UIKit
import Photos

final class Permissions {
    
    static func checkAllowsLibrary(target: UIViewController, imagePicker: UIImagePickerController) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch (status) {
        case .authorized:
            target.present(imagePicker, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (authStatus) in
                DispatchQueue.main.async {
                    if authStatus == .authorized {
                        target.present(imagePicker, animated: true, completion: nil)
                    } else {
                        showLibraryAccessDeniedAlert(target: target)
                    }
                }
            }
        case .denied:
            showLibraryAccessDeniedAlert(target: target)
        case .restricted:
            let okOption = AlertOption(title: "OK", action: .nop)
            
            target.showAlertWithOptions(
                title: "Restricted",
                message: "You've been restricted from using the photo library on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access.",
                options: [okOption]
            )
        default:
            print("unknown default")
        }
    }
    
    static func checkAllowsCamera(target: UIViewController, imagePicker: UIImagePickerController) {
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch (status) {
        case .authorized:
            target.present(imagePicker, animated: true, completion: nil)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                DispatchQueue.main.async {
                    if (granted) {
                        target.present(imagePicker, animated: true, completion: nil)
                    } else {
                        self.showCamAccessDeniedAlert(target: target)
                    }
                }
            }
        case .denied:
            showCamAccessDeniedAlert(target: target)
        case .restricted:
            let okOption = AlertOption(title: "OK", action: .nop)
            
            target.showAlertWithOptions(
                title: "Restricted",
                message: "You've been restricted from using the camera on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access.",
                options: [okOption]
            )
            
        @unknown default:
            print("unknown default")
        }
    }
    
    static func showCamAccessDeniedAlert(target: UIViewController) {
        var message = "It looks like your privacy settings are preventing us from accessing your camera. You can fix this by doing the following:\n\n1. Close PhotosTimeStamper app.\n2. Open the Settings app.\n3. Scroll to the bottom and select PhotosTimeStamper in the list.\n4. Turn the Camera on.\n5. Open PhotosTimeStamper and try again"

        var alertOptions: [AlertOption] = []
        var okOption = AlertOption(title: "OK", action: .nop)
        
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            message = "It looks like your privacy settings are preventing us from accessing your camera. Press Settings to open settings or cancel to close this message."
            
            okOption = AlertOption(title: "Settings", action: Command {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            
            let cancelOption = AlertOption(title: "Cancel", action: .nop)
            alertOptions.append(cancelOption)
        }
        alertOptions.append(okOption)
        target.showAlertWithOptions(
            title: "",
            message: message,
            options: alertOptions
        )

    }
    
    static func showLibraryAccessDeniedAlert(target: UIViewController) {
        var message = "It looks like your privacy settings are preventing us from accessing your photo library. Press Settings to open settings or cancel to close this message."
        
        var alertOptions: [AlertOption] = []
        var okOption = AlertOption(title: "OK", action: .nop)
        
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            message = "It looks like your privacy settings are preventing us from accessing your photo library. Press Settings to open settings or cancel to close this message."
            
            okOption = AlertOption(title: "Settings", action: Command {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            
            let cancelOption = AlertOption(title: "Cancel", action: .nop)
            alertOptions.append(cancelOption)
        }
        alertOptions.append(okOption)
        target.showAlertWithOptions(
            title: "",
            message: message,
            options: alertOptions
        )
    }
}
