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
    
    private let logo = UILabel().then {
        $0.text = "대슐랭 가이드"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    //날짜
    lazy var dateButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(presentCalendar), for: .touchUpInside)
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "정보를 불러오는 중..."
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textAlignment = .center
    }
    
    lazy var leftArrow = UIButton().then {
        $0.setImage(UIImage(named: "arrow.left"), for: .normal)
        $0.addTarget(self, action: #selector(leftArrowAction), for: .touchUpInside)
    }

    lazy var rightArrow = UIButton().then {
        $0.setImage(UIImage(named: "arrow.right"), for: .normal)
        $0.addTarget(self, action: #selector(rightArrowAction), for: .touchUpInside)
    }
    
    //아침
    lazy var breakfastButton = UIButton().then {
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.addTarget(self, action: #selector(getBreakfast), for: .touchUpInside)
    }
    
    private let morningImage = UIImageView().then {
        $0.image = UIImage(named: "morning")
    }
    
    private let breakfastImage = UIImageView().then {
        $0.image = UIImage(named: "break")
    }
    
    private let breakfastMenu = UILabel().then {
        $0.text = "정보를 불러오는 중..."
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 4
    }
    
    //점심
    lazy var lunchButton = UIButton().then {
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.addTarget(self, action: #selector(getLunch), for: .touchUpInside)
    }
    
    private let afternoonImage = UIImageView().then {
        $0.image = UIImage(named: "afternoon")
    }
    
    private let lunchImage = UIImageView().then {
        $0.image = UIImage(named: "lunch")
    }
    
    private let lunchMenu = UILabel().then {
        $0.text = "정보를 불러오는 중..."
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 4
    }
    
    //저녁
    lazy var dinnerButton = UIButton().then {
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.addTarget(self, action: #selector(getDinner), for: .touchUpInside)
    }
    
    private let nightImage = UIImageView().then {
        $0.image = UIImage(named: "night")
    }
    
    private let dinnerImage = UIImageView().then {
        $0.image = UIImage(named: "dinner")
    }
    
    private let dinnerMenu = UILabel().then {
        $0.text = "정보를 불러오는 중..."
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 4
    }
    
    //Calendar 관련 action
    @objc func presentCalendar() {
        let pushVC = CalendarVC()
        pushVC.modalPresentationStyle = .fullScreen
        self.present(pushVC, animated: true)
    }
    
    @objc func leftArrowAction() {
        let yesterday = Date(timeIntervalSinceNow: -86400)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        requestDate = dateFormatter.string(from: yesterday)
        getMeal()
    }
    
    @objc func rightArrowAction() {
        let tomorrow = Date(timeIntervalSinceNow: 86400)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        requestDate = dateFormatter.string(from: tomorrow)
        getMeal()
    }
    
    //급식 상세화면으로 이동하는 action
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
        
        let date = Date()
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

                    var breakfast = result.data.breakfast
                    var lunch = result.data.lunch
                    var dinner = result.data.dinner
                    
                    if breakfast == nil { breakfast = "조식이 없습니다." }
                    if lunch == nil { lunch = "중식이 없습니다." }
                    if dinner == nil { dinner = "석식이 없습니다." }

                    week = result.data.week!
                    self.dateLabel.text = "\(week)"
                    
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
            leftArrow,
            rightArrow,
            
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
            $0.bottom.equalTo(logo.snp.top).offset(18)
        }
        
        dateButton.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(10)
            $0.left.equalTo(leftArrow.snp.right)
            $0.right.equalTo(rightArrow.snp.left)
            $0.bottom.equalTo(dateButton.snp.top).offset(40)
        }

        leftArrow.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(80)
            $0.right.equalTo(leftArrow.snp.left).offset(40)
            $0.bottom.equalTo(leftArrow.snp.top).offset(40)
        }
        
        rightArrow.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(10)
            $0.left.equalTo(rightArrow.snp.right).offset(-40)
            $0.right.equalToSuperview().offset(-80)
            $0.bottom.equalTo(rightArrow.snp.top).offset(40)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(dateButton.snp.top).offset(10)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(dateButton.snp.bottom).offset(-10)
        }
        
        //breakfast
        breakfastButton.snp.makeConstraints {
            $0.top.equalTo(dateButton.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(breakfastButton.snp.top).offset(120)
        }
        
        morningImage.snp.makeConstraints {
            $0.top.equalTo(breakfastButton.snp.top).offset(20)
            $0.left.equalTo(breakfastButton.snp.left).offset(20)
            $0.right.equalTo(morningImage.snp.left).offset(40)
            $0.bottom.equalTo(breakfastButton.snp.top).offset(60)
        }
        
        breakfastImage.snp.makeConstraints {
            $0.top.equalTo(morningImage.snp.bottom).offset(10)
            $0.left.equalTo(breakfastButton.snp.left).offset(16)
            $0.right.equalTo(breakfastImage.snp.left).offset(48)
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
            $0.bottom.equalTo(lunchButton.snp.top).offset(60)
        }
        
        lunchImage.snp.makeConstraints {
            $0.top.equalTo(afternoonImage.snp.bottom).offset(10)
            $0.left.equalTo(lunchButton.snp.left).offset(16)
            $0.right.equalTo(lunchImage.snp.left).offset(48)
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
            $0.bottom.equalTo(dinnerButton.snp.top).offset(60)
        }
        
        dinnerImage.snp.makeConstraints {
            $0.top.equalTo(nightImage.snp.bottom).offset(10)
            $0.left.equalTo(dinnerButton.snp.left).offset(16)
            $0.right.equalTo(dinnerImage.snp.left).offset(48)
            $0.bottom.equalTo(dinnerImage.snp.top).offset(26)
        }
        
        dinnerMenu.snp.makeConstraints {
            $0.top.equalTo(dinnerButton.snp.top).offset(30)
            $0.left.equalTo(nightImage.snp.right).offset(24)
            $0.right.equalTo(dinnerButton.snp.right).offset(-16)
            $0.bottom.equalTo(dinnerButton.snp.bottom).offset(-30)
        }
        
        let backBarButtonItem = UIBarButtonItem(title: "급식 상세 정보", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
    }
    
}

