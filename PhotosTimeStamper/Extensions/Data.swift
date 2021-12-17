//
//  Data.swift
//  ViVNewsApp
//
//  Created by Tetiana Nieizviestna on 21.03.2021.
//

import Foundation

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
    
    func printJSON() {
        let str = String(decoding: self, as: UTF8.self)
        print("[DATA]: \(str)")
    }
}
