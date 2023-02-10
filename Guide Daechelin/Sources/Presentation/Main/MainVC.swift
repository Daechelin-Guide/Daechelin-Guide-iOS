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
    
    //날짜
    lazy var dateButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(presentCalendar), for: .touchUpInside)
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "2023/12/25 화요일"
        $0.font = Pretendard.Medium(size: 20)
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
//        $0.text = "정보를 불러오는 중..."
        $0.text = "쇠고기야채죽,*모닝빵크래미샌드위치,나박김치,허쉬초코크런치시리얼+우유, 바나나"
        $0.font = Pretendard.Regular(size: 14)
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
//        $0.text = "정보를 불러오는 중..."
        $0.text = "*현미밥,돔베고기국수,진미채무침,새우또띠아쌈,깍두기,멜론"
        $0.font = Pretendard.Regular(size: 14)
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
//        $0.text = "정보를 불러오는 중..."
        $0.text = "*기장밥,닭개장,시금치무침,*통모짜돈까스+소스,배추김치,진한사과주스"
        $0.font = Pretendard.Regular(size: 14)
        $0.numberOfLines = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNowDate()
        
        view.backgroundColor = .systemBackground
        setNavigationBar()
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
    
    func setNavigationBar() {
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.isTranslucent = false

        
        let logoImage = UIImage.init(named: "MTMLogo2")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x:0.0,y:0.0, width:120,height:50.0)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 120)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 50.0)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem = imageItem
        
        let bellButtonImage = UIImage(systemName: "gearshape")!
        let bellButton = UIButton(frame: CGRect(x: 0, y: 0, width: bellButtonImage.size.width, height: bellButtonImage.size.height))
        bellButton.setImage(bellButtonImage, for: .normal)
        bellButton.addTarget(self, action: #selector(presentSetting), for: .touchUpInside)
        
        let searchButtonImage = UIImage(systemName: "star")!
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: searchButtonImage.size.width, height: searchButtonImage.size.height))
        searchButton.setImage(searchButtonImage, for: .normal)
        searchButton.addTarget(self, action: #selector(presentRank), for: .touchUpInside)
        
        let bellBarButton = UIBarButtonItem(customView: bellButton)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        self.navigationItem.rightBarButtonItems = [bellBarButton, searchBarButton]
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)

        bellButton.configuration = configuration
        searchButton.configuration = configuration
        
    
    }
    
    
    func setup() {
        
        [
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
        
        dateButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalTo(leftArrow.snp.right)
            $0.right.equalTo(rightArrow.snp.left)
            $0.bottom.equalTo(dateButton.snp.top).offset(40)
        }
        
        leftArrow.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalToSuperview().offset(60)
            $0.right.equalTo(leftArrow.snp.left).offset(40)
            $0.bottom.equalTo(leftArrow.snp.top).offset(40)
        }
        
        rightArrow.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalTo(rightArrow.snp.right).offset(-40)
            $0.right.equalToSuperview().offset(-60)
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
            $0.top.equalTo(dateButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(breakfastButton.snp.top).offset(120)
        }
        
        morningImage.snp.makeConstraints {
            $0.top.equalTo(breakfastButton.snp.top).offset(20)
            $0.left.equalTo(breakfastButton.snp.left).offset(28)
            $0.right.equalTo(morningImage.snp.left).offset(50)
            $0.bottom.equalTo(morningImage.snp.top).offset(40)
        }
        
        breakfastImage.snp.makeConstraints {
            $0.top.equalTo(breakfastImage.snp.bottom).offset(-26)
            $0.left.equalTo(breakfastButton.snp.left).offset(20)
            $0.right.equalTo(breakfastImage.snp.left).offset(66)
            $0.bottom.equalTo(breakfastButton.snp.bottom).offset(-20)
        }
        
        breakfastMenu.snp.makeConstraints {
            $0.top.equalTo(breakfastButton.snp.top).offset(30)
            $0.left.equalTo(breakfastImage.snp.right).offset(20)
            $0.right.equalTo(breakfastButton.snp.right).offset(-20)
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
            $0.left.equalTo(lunchButton.snp.left).offset(28)
            $0.right.equalTo(afternoonImage.snp.left).offset(50)
            $0.bottom.equalTo(afternoonImage.snp.top).offset(40)
        }
        
        lunchImage.snp.makeConstraints {
            $0.top.equalTo(lunchImage.snp.bottom).offset(-26)
            $0.left.equalTo(lunchButton.snp.left).offset(20)
            $0.right.equalTo(lunchImage.snp.left).offset(66)
            $0.bottom.equalTo(lunchButton.snp.bottom).offset(-20)
        }
        
        lunchMenu.snp.makeConstraints {
            $0.top.equalTo(lunchButton.snp.top).offset(30)
            $0.left.equalTo(lunchImage.snp.right).offset(20)
            $0.right.equalTo(lunchButton.snp.right).offset(-20)
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
            $0.left.equalTo(dinnerButton.snp.left).offset(28)
            $0.right.equalTo(nightImage.snp.left).offset(50)
            $0.bottom.equalTo(nightImage.snp.top).offset(40)
        }
        
        dinnerImage.snp.makeConstraints {
            $0.top.equalTo(dinnerImage.snp.bottom).offset(-26)
            $0.left.equalTo(dinnerButton.snp.left).offset(20)
            $0.right.equalTo(dinnerImage.snp.left).offset(66)
            $0.bottom.equalTo(dinnerButton.snp.bottom).offset(-20)
        }
        
        dinnerMenu.snp.makeConstraints {
            $0.top.equalTo(dinnerButton.snp.top).offset(30)
            $0.left.equalTo(dinnerImage.snp.right).offset(20)
            $0.right.equalTo(dinnerButton.snp.right).offset(-20)
            $0.bottom.equalTo(dinnerButton.snp.bottom).offset(-30)
        }
        
        let backBarButtonItem = UIBarButtonItem(title: "급식 상세 정보", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
    }
    
}

extension MainVC {
    
    //MARK: Button action
    
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
    
    //네비게이션바 버튼 action
    @objc func presentRank() {
        print("랭크")
    }
    
    @objc func presentSetting() {
        print("세팅")
    }
    
    
}
