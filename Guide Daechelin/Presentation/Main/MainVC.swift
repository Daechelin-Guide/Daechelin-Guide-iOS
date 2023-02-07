//
//  MainVC.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/07.
//

import UIKit
import SnapKit
import Then
import Alamofire

class MainVC: UIViewController {

    var date = Date()
    
    private let logo = UILabel().then {
        $0.text = "대슐랭 가이드"
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
    }
    
    //날짜
    private let dateButton = UIButton().then {
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(presentCalendar), for: .touchUpInside)
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "2023년 2월 12일"
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.textAlignment = .center
    }
    
    //아침
    private let breakfastButton = UIButton().then {
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(getBreakfast), for: .touchUpInside)
    }
    
    private let morningImage = UIImageView().then {
        $0.image = UIImage(named: "morning")
        $0.contentMode = .scaleAspectFit
    }
    
    private let breakfastImage = UIImageView().then {
        $0.image = UIImage(named: "breakfast")
        $0.contentMode = .scaleAspectFit
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
        $0.addTarget(self, action: #selector(getLunch), for: .touchUpInside)
    }
    
    private let afternoonImage = UIImageView().then {
        $0.image = UIImage(named: "afternoon")
        $0.contentMode = .scaleAspectFit
    }
    
    private let lunchImage = UIImageView().then {
        $0.image = UIImage(named: "lunch")
        $0.contentMode = .scaleAspectFit
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
        $0.addTarget(self, action: #selector(getDinner), for: .touchUpInside)
    }
    
    private let nightImage = UIImageView().then {
        $0.image = UIImage(named: "night")
        $0.contentMode = .scaleAspectFit
    }
    
    private let dinnerImage = UIImageView().then {
        $0.image = UIImage(named: "dinner")
        $0.contentMode = .scaleAspectFit
    }
    
    private let dinnerMenu = UILabel().then {
        $0.text = "*현미밥,돔베고기국수,진미채무침,새우또띠아쌈,깍두기,멜론"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 4
    }
    
    //action
    @objc func getBreakfast() {
        let pushVC = MealVC()
        requestTime = "break"
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    @objc func getLunch() {
        let pushVC = MealVC()
        requestTime = "lunch"
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    @objc func getDinner() {
        let pushVC = MealVC()
        requestTime = "dinner"
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    @objc func presentCalendar() {
        let pushVC = CalendarVC()
        pushVC.modalPresentationStyle = .fullScreen
        self.present(pushVC, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNowDate()
        
        view.backgroundColor = .systemBackground
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMeal()
    }
    
    func getNowDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        requestDate = dateFormatter.string(from: date)
    }
    
    func getMeal() {
        let components = requestDate.components(separatedBy: "-")
        AF.request("\(url)/menu",
                   method: .get,
                   parameters: [
                    "year": components[0],
                    "month": components[1],
                    "day": components[2]
                   ],
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json"]
        ) { $0.timeoutInterval = 5 }
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    guard let result = try? JSONDecoder().decode(MealData.self, from: value) else { return }
                    
                    let date = result.data.date.components(separatedBy: "-")

                    var breakfast = result.data.breakfast
                    var lunch = result.data.lunch
                    var dinner = result.data.dinner
                    
                    if breakfast == nil { breakfast = "없음" }
                    if lunch == nil { lunch = "없음" }
                    if dinner == nil { dinner = "없음" }

                    
                    self.dateLabel.text = "\(date[0])년 \(date[1])월 \(date[2])일"
                    
                    self.breakfastMenu.text = "\(breakfast!)"
                    self.lunchMenu.text = "\(lunch!)"
                    self.dinnerMenu.text = "\(dinner!)"
                    
                case .failure:
                    print("failed")
                }
            }
    }
    
    func setup() {
        
        [
            logo,
            dateButton,
            dateLabel,
            
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
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(logo.snp.top).offset(20)
        }
        
        dateButton.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(dateButton.snp.top).offset(60)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(dateButton.snp.top).offset(10)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(dateButton.snp.bottom).offset(-10)
        }
        
        //breakfast
        breakfastButton.snp.makeConstraints {
            $0.top.equalTo(dateButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(breakfastButton.snp.top).offset(120)
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
            $0.left.equalTo(morningImage.snp.right).offset(24)
            $0.right.equalTo(breakfastButton.snp.right).offset(-16)
            $0.bottom.equalTo(breakfastButton.snp.bottom).offset(-30)
        }
        
        //lunch
        lunchButton.snp.makeConstraints {
            $0.top.equalTo(breakfastButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(lunchButton.snp.top).offset(120)
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
            $0.left.equalTo(afternoonImage.snp.right).offset(24)
            $0.right.equalTo(lunchButton.snp.right).offset(-16)
            $0.bottom.equalTo(lunchButton.snp.bottom).offset(-30)
        }
        
        //dinner
        dinnerButton.snp.makeConstraints {
            $0.top.equalTo(lunchButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(dinnerButton.snp.top).offset(120)
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
            $0.left.equalTo(nightImage.snp.right).offset(24)
            $0.right.equalTo(dinnerButton.snp.right).offset(-16)
            $0.bottom.equalTo(dinnerButton.snp.bottom).offset(-30)
        }
        
    }
    
}
