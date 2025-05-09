//
//  AppStyle.swift
//  MinasMartiCase
//
//  Created by Mina Namlı on 9.05.2025.
//

import Foundation
import UIKit

enum ColorCode: String {
    case martiGreen = "00D600"
    case iconColor = "424242"

    var color: UIColor {
        return UIColor(hex: self.rawValue)
    }
}

struct AppStyle {
    static func color(for code: ColorCode) -> UIColor {
        return code.color
    }

}

extension UIColor {

    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xff0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00ff00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000ff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
