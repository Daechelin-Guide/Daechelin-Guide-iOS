//
//  ReviewCell.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/07.
//

import UIKit
import SnapKit
import Then

class ReviewCell: UITableViewCell {
    
    static let identifier = "ReviewCell"
    
    var anonymous:[String] = ["거대한 곰돌이","소심한 드래곤","귀여운 송아지","활발한 강아지","규칙적인 대소고인","게으른 대소고인","키가 큰 대소고인","슬픈 대소고인","발랄한 대소고인","착한 대소고인","배부른 대소고인","사랑스러운 대소고인"]
    
    let userIcon = UIImageView().then {
        $0.image = UIImage(named: "user")
    }
    
    let userName = UILabel().then {
        $0.text = "익명의 대소고인"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .black
    }

    let comment = UILabel().then {
        $0.text = "테스트용 더미데이터로 댓글이 아닙니다"
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    func setup() {
        
        backgroundColor = .clear
        
        [
            userIcon,
            userName,
            comment
        ].forEach{ self.contentView.addSubview($0) }
        
        userIcon.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(userIcon.snp.left).offset(48)
            $0.bottom.equalToSuperview()
        }
        
        userName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.left.equalTo(userIcon.snp.right).offset(10)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(userName.snp.top).offset(20)
        }
        
        comment.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom)
            $0.left.equalTo(userIcon.snp.right).offset(10)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
