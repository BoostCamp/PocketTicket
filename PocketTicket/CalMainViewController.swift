//
//  CalMainViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 7..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit
import FSCalendar

class CalMainViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        //달력 구분 선 제거
        calendar.clipsToBounds = true
        //header date format
        calendar.appearance.headerDateFormat = "yyyy.MM"
    }
    
    //다음 달로 넘어가기
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        //위 아래로 스크롤 바꾸기
        calendar.scrollDirection = .vertical
    }
    
    // 각 날짜에 특정 문자열을 표시할 수 있습니다. 이미지를 표시하는 메소드도 있으니 API를 참조하세요.
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String?{
        return ""
    }
    
    // 특정 날짜를 선택했을 때, 발생하는 이벤트는 이 곳에서 처리할 수 있겠네요.
    func calendar(_ calendar: FSCalendar, didSelect date: Date){
        let selectDate = date
        
        let calDailyVC = self.storyboard?.instantiateViewController(withIdentifier: "CalDailyViewController") as! CalDailyViewController
        
        calDailyVC.tempDate = selectDate
        
        
        self.navigationController!.pushViewController(calDailyVC, animated: true)
        
        
    }
  
    

    
    
}
