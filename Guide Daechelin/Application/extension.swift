//
//  extention.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/07.
//

import UIKit

public extension UIColor {
    
    class var buttonColor: UIColor? { return UIColor(named: "buttonColor") }
}

public extension UITextField {
    
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
}
