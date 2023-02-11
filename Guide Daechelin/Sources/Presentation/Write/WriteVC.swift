//
//  reviewVC.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/07.
//

import UIKit
import SnapKit
import Then
import Cosmos
import Alamofire

class WriteVC: UIViewController {
    
    var menus:String = ""
    var comment:String = ""
    var star:Double = 0.0
    
    var cosmos = CosmosView()
    
    lazy var completButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(PopCheckAlert))
    
    private let commentTextView = UITextView().then {
        $0.text =  "리뷰를 작성해주세요."
        $0.textColor = UIColor(white: 0, alpha: 0.3)
        $0.font = Pretendard.Regular(size: 18)
        $0.backgroundColor = .buttonColor
        $0.layer.cornerRadius = 8
        $0.isScrollEnabled = false
    }
    
    private let textCount = UILabel().then {
        $0.text = "0/50"
        $0.font = Pretendard.Medium(size: 14)
        $0.textColor = UIColor(white: 0, alpha: 0.3)
        $0.textAlignment = .right
    }
    
    private let error = UILabel().then {
        $0.text = "별점을 먼저 선택하시고 리뷰를 작성해주세요."
        $0.font = Pretendard.Medium(size: 14)
        $0.textColor = UIColor(white: 0, alpha: 0.3)
        $0.textAlignment = .left
    }
    
    @objc func PopCheckAlert() {
        let alert = UIAlertController(title: "완료", message: "리뷰를 업로드하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "네", style: .default) { (action) in
            self.PostRegis()
            self.PostComment()
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "아니오", style: .default, handler : nil)
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func PostRegis() {
        AF.request("\(url)/regis",
                   method: .post,
                   parameters: [
                    "star": star,
                    "menus": menus
                   ],
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"]
        ) { $0.timeoutInterval = 5 }
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    print("POST 성공")
                    print("\(self.star), \(self.menus)")
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func PostComment() {
        
        comment = "\(commentTextView.text!)"
        
        AF.request("\(url)/comment/regis",
                   method: .post,
                   parameters: [
                    "menu": menus,
                    "message": comment
                   ],
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"]
        ) { $0.timeoutInterval = 5 }
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    print("POST 성공")
                    print("\(self.menus), \(self.comment)")
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if commentTextView.text.count > 50 {
            commentTextView.deleteBackward()
        }
        
        textCount.text = "\(commentTextView.text.count)/50"
        
        let attributedString = NSMutableAttributedString(string: "\(commentTextView.text.count)/50")
        attributedString.addAttribute(.foregroundColor, value: UIColor.tintColor as Any, range: ("\(commentTextView.text.count)/50" as NSString).range(of:"\(commentTextView.text.count)"))
        textCount.attributedText = attributedString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        commentTextView.delegate = self
        
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.commentTextView.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func Rating() {
        cosmos.text = "\(Int(cosmos.rating))"
        star = Double(cosmos.rating)
    }
    
    func setup() {
        
        cosmos.settings.filledImage = UIImage(named: "Star.fill")
        cosmos.settings.emptyImage = UIImage(named: "Star")
        cosmos.settings.starSize = 28
        
        cosmos.didFinishTouchingCosmos = { rating in self.Rating() }
        cosmos.text = "\(star)"
        
        navigationItem.rightBarButtonItem = self.completButton

        
        [
            commentTextView,
            textCount,
            cosmos,
            error
        ].forEach{ self.view.addSubview($0) }
        
        commentTextView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(commentTextView.snp.top).offset(84)
        }
        
        textCount.snp.makeConstraints {
            $0.top.equalTo(commentTextView.snp.bottom).offset(6)
            $0.left.equalTo(textCount.snp.right).offset(-100)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(textCount.snp.top).offset(20)
        }
        
        cosmos.snp.makeConstraints {
            $0.top.equalTo(commentTextView.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalTo(textCount.snp.left)
            $0.bottom.equalTo(cosmos.snp.top).offset(28)
        }
        
        error.snp.makeConstraints {
            $0.top.equalTo(cosmos.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(error.snp.top).offset(20)
        }
    }
    
}

extension WriteVC: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text.isEmpty {
            commentTextView.textColor = UIColor(white: 0, alpha: 0.3)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTextView.textColor == UIColor(white: 0, alpha: 0.3) {
            commentTextView.text = nil
            commentTextView.textColor = UIColor.black
        }
    }
    
}
