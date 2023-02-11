//
//  RankingVC.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/10.
//

import UIKit
import SnapKit
import Then

class SettingVC: UIViewController {
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .buttonColor
    }
    
    private let changeSchoolLabel = MediumLabel(text: "학교 변경", size: 18)
    
    private let schoolButton = settingButton()
    
    private let personalInfoLabel = MediumLabel(text: "개인정보 관리", size: 18)
    
    private let personalInfoButton = settingButton()
    
    private let appInfoLabel = MediumLabel(text: "앱 정보", size: 18)
    
    private let versionInfoButton = settingButton()
    
    private let developerInfoButton = settingButton()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setup()
    }
    
    
    func setup() {
        
        self.view.addSubview(scrollView)
        
        [
            changeSchoolLabel,
            schoolButton,
            
            personalInfoLabel,
            personalInfoButton,
            
            appInfoLabel,
            versionInfoButton,
            developerInfoButton
            
        ].forEach { scrollView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        changeSchoolLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalTo(changeSchoolLabel.snp.top).offset(18)
        }
        
        schoolButton.snp.makeConstraints {
            $0.top.equalTo(changeSchoolLabel.snp.bottom).offset(10)
            $0.left.equalTo(scrollView.snp.left).offset(16)
            $0.right.equalTo(schoolButton.snp.left).offset(30)
            $0.bottom.equalTo(schoolButton.snp.top).offset(40)
            
        }
    }
}
