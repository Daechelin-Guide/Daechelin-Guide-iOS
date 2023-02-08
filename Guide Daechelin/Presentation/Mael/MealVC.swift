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

class MealVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    var comment:[CommentData] = []
    var massege:[String] = []
    
    var menus:String = ""
    var star:Double = 0
    
    var cosmos = CosmosView()
    
    private let backView = UIView().then {
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "\(week)"
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textAlignment = .center
    }
    
    private let mealImage = UIImageView().then {
        $0.image = UIImage(named: "lunch")
        $0.contentMode = .scaleAspectFit
    }
    
    private let line = UIView().then {
        $0.backgroundColor = UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 0.3)
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
    
    private let reviewTableView = UITableView().then {
        $0.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    func GetMessage() {
        
        for row in comment {
            if row.message != "" {
                massege.append(row.message!)
            }
        }
        print(massege)
    }
    
    @objc func presentReview() {
        let pushVC = WriteVC()
        self.navigationController?.pushViewController(pushVC, animated: true)
        pushVC.menus = menus
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.reviewTableView.delegate = self
        self.reviewTableView.dataSource = self
        
        getMeal()
        setup()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as! ReviewCell
        cell.selectionStyle = .none
        
        cell.comment.text = "\(massege[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massege.count
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
                            self.menu.text = "조식이 없습니다."
                        } else { self.menu.text =
                            result.breakfast!.replacingOccurrences(of: ",", with: "\n")
                            self.menus = result.breakfast!
                            
                            AF.request("\(url)/star",
                                       method: .get,
                                       parameters: [
                                        "menu": self.menus
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
                                    self.star = Double(result.star ?? 0)
                                    self.cosmos.rating = Double(self.star)
                                    self.cosmos.text = "\(String(format: "%.2f", self.star))"
                                    print("별점 성공")
                                    
                                case .failure:
                                    print("별점 성공")
                                }
                            }
                            
                            AF.request("\(url)/comment/message",
                                       method: .get,
                                       parameters: [
                                        "menu": self.menus
                                       ],
                                       encoding: URLEncoding.default,
                                       headers: ["Content-Type": "application/json"]
                            )
                            .validate()
                            .responseData { response in
                                switch response.result {
                                case .success:
                                    guard let value = response.value else { return }
                                    guard let result = try? JSONDecoder().decode([CommentData].self, from: value) else { return }
                                    self.comment = result
                                    
                                    print("\(self.comment)")
                                    self.GetMessage()
                                    self.reviewTableView.reloadData()
                                    
                                case .failure:
                                    print("댓글 실패")
                                }
                            }
                            
                        }
                    } else if requestTime == "lunch" {
                        if result.lunch == nil {
                            self.menu.text = "중식이 없습니다."
                        } else { self.menu.text =
                            result.lunch!.replacingOccurrences(of: ",", with: "\n")
                            self.menus = result.lunch!
                            
                            AF.request("\(url)/star",
                                       method: .get,
                                       parameters: [
                                        "menu": self.menus
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
                                    self.star = Double(result.star ?? 0)
                                    self.cosmos.rating = Double(self.star)
                                    self.cosmos.text = "\(String(format: "%.2f", self.star))"
                                    print("별점 성공")
                                    
                                case .failure:
                                    print("별점 실패")
                                }
                            }
                            
                            AF.request("\(url)/comment/message",
                                       method: .get,
                                       parameters: [
                                        "menu": self.menus
                                       ],
                                       encoding: URLEncoding.default,
                                       headers: ["Content-Type": "application/json"]
                            )
                            .validate()
                            .responseData { response in
                                switch response.result {
                                case .success:
                                    guard let value = response.value else { return }
                                    guard let result = try? JSONDecoder().decode([CommentData].self, from: value) else { return }
                                    self.comment = result
                                    
                                    print("\(self.comment)")
                                    self.GetMessage()
                                    self.reviewTableView.reloadData()
                                    
                                case .failure:
                                    print("댓글 실패")
                                }
                            }
                        }
                    } else if requestTime == "dinner" {
                        if result.dinner == nil {
                            self.menu.text = "석식이 없습니다."
                        } else { self.menu.text =
                            result.dinner!.replacingOccurrences(of: ",", with: "\n")
                            self.menus = result.dinner!
                            
                            AF.request("\(url)/star",
                                       method: .get,
                                       parameters: [
                                        "menu": self.menus
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
                                    self.star = Double(result.star ?? 0)
                                    self.cosmos.rating = Double(self.star)
                                    self.cosmos.text = "\(String(format: "%.2f", self.star))"
                                    print("별점 성공")
                                    
                                case .failure:
                                    print("별점 성공")
                                }
                            }
                            
                            AF.request("\(url)/comment/message",
                                       method: .get,
                                       parameters: [
                                        "menu": self.menus
                                       ],
                                       encoding: URLEncoding.default,
                                       headers: ["Content-Type": "application/json"]
                            )
                            .validate()
                            .responseData { response in
                                switch response.result {
                                case .success:
                                    guard let value = response.value else { return }
                                    guard let result = try? JSONDecoder().decode([CommentData].self, from: value) else { return }
                                    self.comment = result
                                    
                                    print("\(self.comment)")
                                    self.GetMessage()
                                    self.reviewTableView.reloadData()
                                    
                                case .failure:
                                    print("댓글 실패")
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
        cosmos.settings.filledImage = UIImage(named: "Star.fill")
        cosmos.settings.emptyImage = UIImage(named: "Star")
        cosmos.settings.starSize = 36
        cosmos.rating = 0
        cosmos.text = "0.0"
        
        [
            backView,
            dateLabel,
            mealImage,
            cosmos,
            line,
            menu,
            reviewTableView,
            reviewButton
        ].forEach { self.view.addSubview($0) }
        
        backView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(backView.snp.top).offset(260)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(dateLabel.snp.top).offset(24)
        }
        
        mealImage.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(160)
            $0.right.equalToSuperview().offset(-160)
            $0.bottom.equalTo(mealImage.snp.top).offset(30)
        }
        
        cosmos.snp.makeConstraints {
            $0.top.equalTo(mealImage.snp.bottom).offset(8)
            $0.centerX.equalTo(backView)
            $0.centerY.equalTo(mealImage.snp.bottom).offset(10)
        }
        
        menu.snp.makeConstraints {
            $0.top.equalTo(cosmos.snp.bottom).offset(14)
            $0.left.equalTo(backView.snp.left).offset(20)
            $0.right.equalTo(backView.snp.right).offset(-20)
            $0.bottom.equalTo(backView.snp.bottom)
        }
        
        reviewTableView.snp.makeConstraints {
            $0.top.equalTo(backView.snp.bottom).offset(20)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        reviewButton.snp.makeConstraints {
            $0.top.equalTo(reviewButton.snp.bottom).offset(-60)
            $0.left.equalTo(reviewButton.snp.right).offset(-60)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        let backBarButtonItem = UIBarButtonItem(title: "리뷰 달기", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    
}

