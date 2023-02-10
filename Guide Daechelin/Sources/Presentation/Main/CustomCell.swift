//
//  Cell.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/07.
//

import UIKit
import SnapKit
import Then

class CustomCell: UITableViewCell {
    
    var cellButtonAction : (() -> ())?
    
    static let identifier = "CustomCell"
    
    let cellButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(TabCell), for: .touchUpInside)
    }
    
    @objc func TabCell() {
        print("눌렀어요")
    }
    
    let dateAndEmotionText = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "OOOO월 OO월 OO일 · OOO!"
        $0.font = UIFont(name: "SDMiSaeng", size: 22)
        $0.textColor = .black
    }
    
    let content = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "내용"
        $0.font = UIFont(name: "SDMiSaeng", size: 20)
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .clear
        
        [
            cellButton,
            dateAndEmotionText,
            content
            
        ].forEach{ self.contentView.addSubview($0) }
        
        cellButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        dateAndEmotionText.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(dateAndEmotionText.snp.left).offset(240)
            $0.bottom.equalTo(dateAndEmotionText.snp.top).offset(20)
        }
        content.snp.makeConstraints {
            $0.top.equalTo(dateAndEmotionText.snp.bottom).offset(-6)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
//            $0.right.equalTo(content.snp.left).offset(240)
            $0.bottom.equalTo(content.snp.top).offset(60)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
