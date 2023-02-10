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
    
    let userIcon = UIImageView().then {
        $0.image = UIImage(named: "user")
    }
    
    let userName = UILabel().then {
        $0.text = "익명의 대소고인"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .black
    }

    let comment = UILabel().then {
        $0.text = "댓글을 불러오는 중..."
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
            $0.top.equalToSuperview().offset(8)
            $0.left.equalTo(userIcon.snp.right).offset(10)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(userName.snp.top).offset(14)
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
