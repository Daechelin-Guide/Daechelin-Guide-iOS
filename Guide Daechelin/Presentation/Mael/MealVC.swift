//
//  Detail.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/07.
//

import UIKit
import SnapKit
import Then
import Alamofire

class MealVC: UIViewController {
   
    private let backView = UIView().then {
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "2023년 02월 07일 "
        $0.font = .systemFont(ofSize: 22, weight: .medium)
        $0.textAlignment = .center
    }
    
    private let mealImage = UIImageView().then {
        $0.image = UIImage(named: "lunch")
        $0.contentMode = .scaleAspectFit
    }
    
    private let line = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private let menu = UILabel().then {
        let str = "*기장밥,닭개장,시금치무침,*통모짜돈까스+소스,배추김치,진한사과주스"
        let str2 = str.replacingOccurrences(of: ",", with: "\n")
        
        $0.text = str2
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .center
        $0.numberOfLines = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        getMeal()
        setup()
    }
    
    func getMeal() {
        AF.request("\(url)/\(requestTime)",
                   method: .get,
                   parameters: [
                    "date": requestDate
                   ],
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json"]
        ) { $0.timeoutInterval = 5 }
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    guard let result = try? JSONDecoder().decode(Meal.self, from: value) else { return }
                    
                    print(result)
                    
                case .failure:
                    print("failed")
                }
            }
    }
    
    func setup() {
        
        [
            backView,
            dateLabel,
            mealImage,
            line,
            menu
        ].forEach { self.view.addSubview($0) }
        
        backView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(backView.snp.top).offset(220)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(10)
            $0.left.equalToSuperview().offset(100)
            $0.right.equalToSuperview().offset(-100)
            $0.bottom.equalTo(dateLabel.snp.top).offset(24)
        }
        
        mealImage.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(160)
            $0.right.equalToSuperview().offset(-160)
            $0.bottom.equalTo(mealImage.snp.top).offset(28)
        }
        
        line.snp.makeConstraints {
            $0.top.equalTo(mealImage.snp.bottom).offset(10)
            $0.left.equalTo(backView.snp.left).offset(20)
            $0.right.equalTo(backView.snp.right).offset(-20)
            $0.bottom.equalTo(line.snp.top).offset(1)
        }
        
        menu.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(9)
            $0.left.equalTo(backView.snp.left).offset(20)
            $0.right.equalTo(backView.snp.right).offset(-20)
            $0.bottom.equalTo(backView.snp.bottom).offset(-10)
        }
        
    }
    
    
}
