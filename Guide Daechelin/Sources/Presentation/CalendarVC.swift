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

class CalendarVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    var calendar = FSCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setup()
    }
     
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(dateFormatter.string(from: date))
        
        requestDate = dateFormatter.string(from: date)
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func setup() {
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        self.calendar.appearance.headerDateFormat = "YYYY년 M월"
        self.calendar.appearance.weekdayTextColor = .black
        self.calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red
        self.calendar.calendarWeekdayView.weekdayLabels[6].textColor = .blue

        view.addSubview(calendar)
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
