//
//  CalAddViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 9..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class CalAddViewController: UITableViewController, UITextFieldDelegate{
    
    //MARK: - Properties

    //Data model
    let dataInstacne = DataController.sharedInstance()
    
    //Properties for DatePicker
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateDetailLabel: UILabel!
    var datePickerFlag = false
    let dateFormat = DateFormatter()
    var currentDate : Date?

    //Properties for Genre PickerView
    @IBOutlet weak var genrePickerView: UIPickerView!
    @IBOutlet weak var genreDetailLabel: UILabel!
    var genreNameList = [String]()
    var genrePickerFlag = false

    //textField
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var seatTextField: UITextField!
    
    //Properties for theater
    
    @IBOutlet weak var theaterNameLabel: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    
    //get theater data from map view by tuple
    var theaterData : (theaterName: String, longtitude: Double, latitude: Double, mapSelectedImage: UIImage)? = nil
    
    //Properties for show
    var showTicket : Ticket? = nil
    var showFlag = false
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "New"
        titleTextField.delegate = self
        seatTextField.delegate = self
    
        //Make genre name list
        getGenreNameList()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Todo : 현재시간이 아니라 클릭한 날짜로 해야 함. CalDaily에서 Date받기
        //처음에는 date picker detail 현재시간
        dateFormat.dateFormat = "yyyy.MM.dd    a h:mm"
        if let currentDate = currentDate{
            dateDetailLabel.text = dateFormat.string(from: currentDate)
            datePicker.date = currentDate
        }
        
        //Map에서 받아 온 theater 정보 설정
        if let theaterData = theaterData{
            mapImageView.image = theaterData.mapSelectedImage
            theaterNameLabel.text = theaterData.theaterName
        } else{
            print("fail")
        }
        
        //show data
        if showFlag {
            showSelectedTicket()
            self.navigationItem.leftBarButtonItem = nil
            self.tabBarController?.tabBar.isHidden = true
            showFlag = false
        } else{
            print("fail")
        }
    }
    
    // MARK: - Date Picker
    //함수를 호출하면 datapicker show
    func toggleShowDatepicker () {
        datePickerFlag = !datePickerFlag
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //date picker의 값이 바뀌면 detial label 값 변경
    @IBAction func showDatePickerDate(_ sender: Any) {
         dateDetailLabel.text = dateFormat.string(from: datePicker.date)
    }
    //MARK: - TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide keyboard
        textField.resignFirstResponder()
        return true
    }

    //MARK: - Actions
    //for unwind
    @IBAction func unwindToCalAddViewController(segue: UIStoryboardSegue){
        print("unwind")
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Save datas
    @IBAction func saveAction(_ sender: Any) {
        var theaterId : Int = 0
        //save theater
        if let theaterData = theaterData{
           theaterId = dataInstacne.addTheaterData(name: theaterData.theaterName, latitude: theaterData.latitude, longtitude: theaterData.longtitude, mapImage: theaterData.mapSelectedImage)
        }
        //save ticket
        if theaterId != 0{
            let theaterObject = dataInstacne.getTheaterById(theaterId)
            dataInstacne.addBasicContents(name: titleTextField.text!, seat: seatTextField.text!, date: datePicker.date as NSDate, genre: genreDetailLabel.text!, theater: theaterObject)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Show Ticket
    func showSelectedTicket(){
        if let showTicket = showTicket{
            
            dateFormat.dateFormat = "yyyy.MM.dd    a h:mm"
            if let currentDate = currentDate{
                dateDetailLabel.text = dateFormat.string(from: currentDate)
                datePicker.date = currentDate
            }

            self.titleTextField.text = showTicket.name
            self.seatTextField.text = showTicket.seat
            self.datePicker.date = showTicket.date as Date
            self.dateDetailLabel.text = dateFormat.string(from: showTicket.date as Date)
            self.genreDetailLabel.text = showTicket.genre
            self.theaterNameLabel.text = showTicket.theater?.theaterName
            let tempImage = UIImage(data: showTicket.theater?.mapImage as! Data)
            self.mapImageView.image = tempImage
        }
    }
}


//MARK: - TableView Delegate
extension CalAddViewController{
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

}


//MARK:- Genre picker view
extension CalAddViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: Get Data
    func getGenreNameList(){
        let genreList = dataInstacne.getGenreList()
        for genre in genreList{
            genreNameList.append(genre.genreName)
        }
    }
    
    
    //MARK: Picker View DataSource
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
    
    //MARK: Picker View Delegate
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








