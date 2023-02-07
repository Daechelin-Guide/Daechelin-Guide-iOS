//
//  CalendarVC.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/07.
//
import UIKit
import SnapKit
import Then
import FSCalendar

class CalendarVC: UIViewController, FSCalendarDelegate {
    
    private let calendar = FSCalendar().then {
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
     
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print("test")
    }
    
    func setup() {
        
        view.addSubview(calendar)
        
        calendar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
