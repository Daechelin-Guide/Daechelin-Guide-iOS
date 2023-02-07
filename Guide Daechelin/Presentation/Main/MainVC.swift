//
//  MainVC.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/07.
//

import UIKit
import SnapKit
import Then

class MainVC: UIViewController {
    
    private let logo = UILabel().then {
        $0.text = "대슐랭 가이드"
        $0.font = .systemFont(ofSize: 28, weight: .semibold)
    }
    
    //아침
    private let breakfastButton = UIButton().then {
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
    }
    
    private let morningImage = UIImageView().then {
        $0.image = UIImage(named: "morning")
    }
    
    private let breakfastImage = UIImageView().then {
        $0.image = UIImage(named: "breakfast")
    }
    
    private let breakfastMenu = UILabel().then {
        $0.text = "*기장밥,닭개장,시금치무침,*통모짜돈까스+소스,배추김치,진한사과주스"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 4
    }
    
    //점심
    private let lunchButton = UIButton().then {
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
    }
    
    private let afternoonImage = UIImageView().then {
        $0.image = UIImage(named: "afternoon")
    }
    
    private let lunchImage = UIImageView().then {
        $0.image = UIImage(named: "lunch")
    }
    
    private let lunchMenu = UILabel().then {
        $0.text = "쇠고기야채죽,*모닝빵크래미샌드위치,나박김치,허쉬초코크런치시리얼+우유,바나나"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 4
    }
    
    //점심
    private let dinnerButton = UIButton().then {
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
    }
    
    private let nightImage = UIImageView().then {
        $0.image = UIImage(named: "night")
    }
    
    private let dinnerImage = UIImageView().then {
        $0.image = UIImage(named: "dinner")
    }
    
    private let dinnerMenu = UILabel().then {
        $0.text = "*현미밥,돔베고기국수,진미채무침,새우또띠아쌈,깍두기,멜론"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setup()
    }
    
    func setup() {
        
        [
            logo,
            
            breakfastButton,
            morningImage,
            breakfastImage,
            breakfastMenu,
            
            lunchButton,
            afternoonImage,
            lunchImage,
            lunchMenu,
            
            dinnerButton,
            nightImage,
            dinnerImage,
            dinnerMenu
        ].forEach { self.view.addSubview($0) }
        
        logo.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(logo.snp.top).offset(40)
        }
        
        //breakfast
        breakfastButton.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(breakfastButton.snp.top).offset(140)
        }
        
        morningImage.snp.makeConstraints {
            $0.top.equalTo(breakfastButton.snp.top).offset(20)
            $0.left.equalTo(breakfastButton.snp.left).offset(20)
            $0.right.equalTo(morningImage.snp.left).offset(40)
            $0.bottom.equalTo(morningImage.snp.top).offset(60)
        }
        
        breakfastImage.snp.makeConstraints {
            $0.top.equalTo(morningImage.snp.bottom).offset(10)
            $0.left.equalTo(breakfastButton.snp.left).offset(20)
            $0.right.equalTo(breakfastImage.snp.left).offset(40)
            $0.bottom.equalTo(breakfastImage.snp.top).offset(26)
        }
        
        breakfastMenu.snp.makeConstraints {
            $0.top.equalTo(breakfastButton.snp.top).offset(30)
            $0.left.equalTo(morningImage.snp.right).offset(16)
            $0.right.equalTo(breakfastButton.snp.right).offset(-16)
            $0.bottom.equalTo(breakfastButton.snp.bottom).offset(-30)
        }
        
        //lunch
        lunchButton.snp.makeConstraints {
            $0.top.equalTo(breakfastButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(lunchButton.snp.top).offset(140)
        }
        
        afternoonImage.snp.makeConstraints {
            $0.top.equalTo(lunchButton.snp.top).offset(20)
            $0.left.equalTo(lunchButton.snp.left).offset(20)
            $0.right.equalTo(afternoonImage.snp.left).offset(40)
            $0.bottom.equalTo(lunchButton.snp.bottom).offset(-60)
        }
        
        lunchImage.snp.makeConstraints {
            $0.top.equalTo(afternoonImage.snp.bottom).offset(10)
            $0.left.equalTo(lunchButton.snp.left).offset(20)
            $0.right.equalTo(lunchImage.snp.left).offset(40)
            $0.bottom.equalTo(lunchImage.snp.top).offset(26)
        }
        
        lunchMenu.snp.makeConstraints {
            $0.top.equalTo(lunchButton.snp.top).offset(30)
            $0.left.equalTo(afternoonImage.snp.right).offset(16)
            $0.right.equalTo(lunchButton.snp.right).offset(-16)
            $0.bottom.equalTo(lunchButton.snp.bottom).offset(-30)
        }
        
        //dinner
        dinnerButton.snp.makeConstraints {
            $0.top.equalTo(lunchButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(dinnerButton.snp.top).offset(140)
        }
        
        nightImage.snp.makeConstraints {
            $0.top.equalTo(dinnerButton.snp.top).offset(20)
            $0.left.equalTo(dinnerButton.snp.left).offset(20)
            $0.right.equalTo(nightImage.snp.left).offset(40)
            $0.bottom.equalTo(dinnerButton.snp.bottom).offset(-60)
        }
        
        dinnerImage.snp.makeConstraints {
            $0.top.equalTo(nightImage.snp.bottom).offset(10)
            $0.left.equalTo(dinnerButton.snp.left).offset(20)
            $0.right.equalTo(dinnerImage.snp.left).offset(40)
            $0.bottom.equalTo(dinnerImage.snp.top).offset(26)
        }
    
        dinnerMenu.snp.makeConstraints {
            $0.top.equalTo(dinnerButton.snp.top).offset(30)
            $0.left.equalTo(nightImage.snp.right).offset(16)
            $0.right.equalTo(dinnerButton.snp.right).offset(-16)
            $0.bottom.equalTo(dinnerButton.snp.bottom).offset(-30)
        }
        
    }
}

