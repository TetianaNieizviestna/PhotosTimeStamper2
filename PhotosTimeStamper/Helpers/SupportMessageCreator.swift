//
//  SupportMessageCreator.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 22.10.2022.
//

import UIKit

struct SupportMessageCreator {
    static func createMessage() -> String {
        return """
        Please describe your issue or your propositions.
        \n\n\n\n\n
        Please do not delete the additional information and we resolve your issue ASAP.
        ***
        \(getDeviceInfo())
        """
    }
    
    static func getDeviceInfo() -> String {
        let device = UIDevice.modelName
        let iosVersion = getIosVersion()
        let appVersion = getAppVersion()
        
        return """
        My device: \(device)
        iOS version: \(iosVersion)
        App version: \(appVersion)
        """
    }
    
    static func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    static func getIosVersion() -> String {
        let iosVersion = ProcessInfo.processInfo.operatingSystemVersion
        return "\(iosVersion.majorVersion).\(iosVersion.minorVersion).\(iosVersion.patchVersion)"
    }
}
