//
//  enum.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/10.
//

import UIKit

// Pretendard
enum Pretendard: String {
    
    case Black = "Pretendard-Black"
    case Bold = "Pretendard-Bold"
    case SemiBold = "Pretendard-SemiBold"
    case ExtraBold = "Pretendard-ExtraBold"
    case Medium = "Pretendard-Medium"
    case Regular = "Pretendard-Regular"
    case Light = "Pretendard-Light"
    case ExtraLight = "Pretendard-ExtraLight"
    

    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }

    static func Black(size: CGFloat) -> UIFont {
        return Pretendard.Black.of(size: size)
    }

    static func Bold(size: CGFloat) -> UIFont {
        return Pretendard.Bold.of(size: size)
    }
    
    static func SemiBold(size: CGFloat) -> UIFont {
        return Pretendard.SemiBold.of(size: size)
    }

    static func ExtraBold(size: CGFloat) -> UIFont {
        return Pretendard.ExtraBold.of(size: size)
    }
    
    static func Medium(size: CGFloat) -> UIFont {
        return Pretendard.Medium.of(size: size)
    }

    static func Regular(size: CGFloat) -> UIFont {
        return Pretendard.Regular.of(size: size)
    }
    
    static func Light(size: CGFloat) -> UIFont {
        return Pretendard.Light.of(size: size)
    }

    static func ExtraLight(size: CGFloat) -> UIFont {
        return Pretendard.ExtraLight.of(size: size)
    }
}
