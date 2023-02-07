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
import Cosmos

class MealVC: UIViewController {
    
    var menuData:String = ""
    var star:Int = 0
    
    var cosmos = CosmosView()
    
    private let backView = UIView().then {
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "\(requestDate)"
        $0.font = .systemFont(ofSize: 20, weight: .medium)
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
        $0.text = ""
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .center
        $0.numberOfLines = 8
    }
    
    private let reviewButton = UIButton().then {
        $0.setImage(UIImage(named: "review"), for: .normal)
        $0.addTarget(self, action: #selector(presentReview), for: .touchUpInside)
    }
    
    
    @objc func presentReview() {
        let pushVC = reviewVC()
        self.present(pushVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        getMeal()
        setup()
    }
    
    func getMeal() {
        
        print("\(requestTime) \(requestDate)")
        
        AF.request("\(url)/\(requestTime)",
                   method: .get,
                   parameters: [
                    "date" : requestDate
                   ], encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json"]
        ) { $0.timeoutInterval = 5 }
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    guard let result = try? JSONDecoder().decode(MenuData.self, from: value) else { return }
                    
                    if requestTime == "break" {
                        if result.breakfast == nil {
                            self.menu.text = "없음"
                        } else { self.menu.text =
                            result.breakfast!.replacingOccurrences(of: ",", with: "\n")
                            
                            AF.request("\(url)/star",
                                       method: .get,
                                       parameters: [
                                        "menu": result.breakfast!
                                       ],
                                       encoding: URLEncoding.default,
                                       headers: ["Content-Type": "application/json"]
                            )
                            .validate()
                            .responseData { response in
                                switch response.result {
                                case .success:
                                    guard let value = response.value else { return }
                                    guard let result = try? JSONDecoder().decode(StarData.self, from: value) else { return }
                                    self.star = result.star ?? 0
                                    self.cosmos.rating = Double(self.star)
                                case .failure:
                                    print("실패..")
                                }
                            }
                        }
                    } else if requestTime == "lunch" {
                        if result.lunch == nil {
                            self.menu.text = "없음"
                        } else { self.menu.text =
                            result.lunch!.replacingOccurrences(of: ",", with: "\n")
                            
                            AF.request("\(url)/star",
                                       method: .get,
                                       parameters: [
                                        "menu": result.lunch!
                                       ],
                                       encoding: URLEncoding.default,
                                       headers: ["Content-Type": "application/json"]
                            )
                            .validate()
                            .responseData { response in
                                switch response.result {
                                case .success:
                                    guard let value = response.value else { return }
                                    guard let result = try? JSONDecoder().decode(StarData.self, from: value) else { return }
                                    self.star = result.star ?? 0
                                    print(self.star)
                                case .failure:
                                    print("실패..")
                                }
                            }
                        }
                    } else if requestTime == "dinner" {
                        if result.dinner == nil {
                            self.menu.text = "없음"
                        } else { self.menu.text =
                            result.dinner!.replacingOccurrences(of: ",", with: "\n")
                            
                            AF.request("\(url)/star",
                                       method: .get,
                                       parameters: [
                                        "menu": result.dinner!
                                       ],
                                       encoding: URLEncoding.default,
                                       headers: ["Content-Type": "application/json"]
                            )
                            .validate()
                            .responseData { response in
                                switch response.result {
                                case .success:
                                    guard let value = response.value else { return }
                                    guard let result = try? JSONDecoder().decode(StarData.self, from: value) else { return }
                                    self.star = result.star ?? 0
                                    print(self.star)
                                case .failure:
                                    print("실패..")
                                }
                            }
                        }
                    }
                    
                case .failure:
                    print("실패")
                }
            }
    }
    func setup() {
        
        self.mealImage.image = UIImage(named: "\(requestTime)")
        cosmos.settings.updateOnTouch = false
        
        [
            backView,
            dateLabel,
            mealImage,
            line,
            menu,
            cosmos,
            reviewButton
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
        
        cosmos.snp.makeConstraints {
            $0.top.equalTo(backView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(cosmos.snp.top).offset(32)
        }
        
        reviewButton.snp.makeConstraints {
            $0.top.equalTo(reviewButton.snp.bottom).offset(-60)
            $0.left.equalTo(reviewButton.snp.right).offset(-60)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
    }
    
    
}

