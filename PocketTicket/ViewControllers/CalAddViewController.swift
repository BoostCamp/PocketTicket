//
//  CalAddViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 9..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class CalAddViewController: UITableViewController, UITextFieldDelegate{

    //Data model
    let modelInstance = ModelController.sharedInstance()
    
    //Properties for datePicker
    @IBOutlet weak var datePickerShowDate: UIDatePicker!
    @IBOutlet weak var dateDetailLabel: UILabel!
    var datePickerFlag = false
    let dateFormate = DateFormatter()
    var currentDate : Date?

    
    //Properties for genrePickerView
    var genreNameList = [String]()
    @IBOutlet weak var genrePickerView: UIPickerView!
    var genrePickerFlag = false
    @IBOutlet weak var genreDetailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "New"
    
        genreNameList = modelInstance.loadGenreNameList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Todo : 현재시간이 아니라 클릭한 날짜로 해야 함. CalDaily에서 Date받기
        //처음에는 date picker detail 현재시간
        dateFormate.dateFormat = "yyyy.MM.dd    a h:mm"
        if let currentDate = currentDate{
            dateDetailLabel.text = dateFormate.string(from: currentDate)
            datePickerShowDate.date = currentDate
            
        }
    }
    
    // MARK: - Date Picker
    //함수를 호출하면 datapicker show
    func toggleShowDatepicker () {
        datePickerFlag = !datePickerFlag
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    @IBAction func showDatePickerDate(_ sender: Any) {
        dateDetailLabel.text = dateFormate.string(from: datePickerShowDate.date)
    }
    
    
    // MARK: - TableView Delegate
    //row 선택시 이벤트
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //Date row를 클릭하면
        if indexPath.section == 1 && indexPath.row == 1
        {
            //datePicker show
            if !datePickerFlag{
                toggleShowDatepicker()
            }
            //datePicker hide & show date in label
            else{
                toggleShowDatepicker()
            }
        }
        
        //Genre row를 클릭하면
        if indexPath.section == 1 && indexPath.row == 4
        {
            //genre picker show
            if !genrePickerFlag{
                toggleShowgenrePicker()
            }
            //datePicker hide & show date in label
            else{
                 toggleShowgenrePicker()
            }
        }
    }
    
    //row height 정하기
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Hide 되어 있어야 할 경우 date picker의 height를 0으로 줌
        if !datePickerFlag && indexPath.section == 1 && indexPath.row == 2 {
            return 0
        } else if !genrePickerFlag && indexPath.section == 1 && indexPath.row == 5{
            return 0
        }
        //height를 원래 크기로
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
  
}

//MARK:- Genre picker view
extension CalAddViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    //MARK: - Picker View DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //        if pickerView == genrePickerView{
        return genreNameList.count
        //        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genreNameList[row]
    }
    
    //MARK: - Picker View Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        genreDetailLabel.text = genreNameList[row]
        
    }
    
    //함수를 호출하면 genre picker show
    func toggleShowgenrePicker () {
        genrePickerFlag = !genrePickerFlag
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }


}

