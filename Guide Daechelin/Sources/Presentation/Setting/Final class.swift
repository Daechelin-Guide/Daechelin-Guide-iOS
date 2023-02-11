//
//  Final class.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/11.
//

import UIKit

final class RegularLabel: UILabel {
    
    init(text: String, size: Int) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = .TextColor
        self.font = Pretendard.Regular(size: CGFloat(size))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MediumLabel: UILabel {
    
    init(text: String, size: Int) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = .TextColor
        self.font = Pretendard.Medium(size: CGFloat(size))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class settingButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.shadowOpacity = 0.1
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
