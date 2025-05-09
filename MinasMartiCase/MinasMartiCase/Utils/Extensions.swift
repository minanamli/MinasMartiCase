//
//  Extensions.swift
//  MinasMartiCase
//
//  Created by Mina Namlı on 8.05.2025.
//

import Foundation
import UIKit

extension UIViewController {
    func makeAlert(title: String, message: String, buttonTitle: String? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle != nil ? buttonTitle : Constants.AppStr.ok, style: .default))
        present(alert, animated: true)
    }
}

extension UIView {
    func addButtonShadow(radius: CGFloat) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 15.0
        self.layer.cornerRadius = radius
    }
}

extension UILabel {
    func setLbl(text: String ,textColor: UIColor, textAlignment: NSTextAlignment,font: UIFont, fontsize: Int) {
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.font = font.withSize(CGFloat(fontsize))
    }
}

extension UIImageView {
    func setSystemImage(imgName: String ,tintColor: UIColor? = nil) {
        self.image = UIImage(systemName: imgName)
        if tintColor != nil {
            self.tintColor = tintColor
        }else{
            self.tintColor = .black
        }
    }
    
    func setImageView(imgName: String, tintColor: UIColor? = nil){
        if tintColor == nil {
            self.image = UIImage(named: imgName)
        } else {
            self.image = UIImage(named: imgName)?.withTintColor(tintColor!)
        }
    }
}

extension Notification.Name {
    static let didReceiveNewCoordinate = Notification.Name("didReceiveNewCoordinate")
}
