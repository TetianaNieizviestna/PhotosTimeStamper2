//
//  EmailMessageModel.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 23.10.2022.
//

import Foundation

struct EmailMessageModel {
    let subject: String
    let messageBody: String
    
    static let initial: EmailMessageModel = .init(subject: "", messageBody: "")
}
