//
//  CalAddViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 9..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit
import SafariServices
import UserNotifications

class CalAddViewController: UITableViewController, UITextFieldDelegate{
    
    //MARK: - Properties

    //Data model
    let dataInstacne = DataController.sharedInstance()
    
    //Properties for DatePicker
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    var datePickerFlag = false
    let dateFormat = DateFormatter()
    var currentDate : Date?

    //Properties for Genre PickerView
    @IBOutlet weak var genrePickerView: UIPickerView!
    @IBOutlet weak var genreLabel: UILabel!
    var genreNameList = [String]()
    var genrePickerFlag = false
    var genreLabelFlag = false
    
    //Properites for Alarm Picker
    var alarmPickFlag = false
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var Button3Week: UIButton!
    @IBOutlet weak var Button2Week: UIButton!
    @IBOutlet weak var Button1Week: UIButton!
    @IBOutlet weak var Button5Day: UIButton!
    @IBOutlet weak var Button3Day: UIButton!
    @IBOutlet weak var Button1Day: UIButton!
    var possibleClickFlag = [true, true, true, true, true, true]
    var clickedFlag = [false, false, false, false, false, false]
    let alarmAllDic = [1:"1일전", 2:"3일전", 3:"5일전", 4:"1주전", 5:"2주전", 6:"3주전"]
    let alarmTimeDic = [1:1, 2:3, 3:5, 4:7, 5:14, 6:21]
    var alarmSet = Set<Int>()
    var identifierArray = [String]()
    let ticketNotfication = NotificationManager()
    

    //textField
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var seatTextField: UITextField!
    @IBOutlet weak var actorTextField: UITextField!
    
    //Properties for theater
    @IBOutlet weak var theaterNameLabel: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var routeButton: UIButton!
    
    //Get theater data from map view by tuple
    var theaterData : (theaterName: String, longtitude: Double, latitude: Double, mapSelectedImage: UIImage, locationDetail: String)? = nil
    var locationDetail : String = ""
    
    //Properties for show
    var showTicket : Ticket? = nil
    var showFlag = false
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New"
        dateFormat.dateFormat = "yyyy.MM.dd a h:mm"
        self.routeButton.isHidden = true

        titleTextField.delegate = self
        seatTextField.delegate = self
        actorTextField.delegate = self
    
        //Make genre name list
        self.getGenreNameList()
        
        if let currentDate = currentDate{
            datePicker.date = currentDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Set theater data from Map view : map image, theater name, location detail
        if let theaterData = self.theaterData{
            self.mapImageView.image = theaterData.mapSelectedImage
            self.theaterNameLabel.text = theaterData.theaterName
            self.locationDetail = theaterData.locationDetail
        }
        
        //Show data
        if showFlag {
            showSelectedTicket()
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            self.tabBarController?.tabBar.isHidden = true
            self.routeButton.isHidden = false
            self.showFlag = false
            self.title = showTicket?.name
            //tableview cannot select
            self.tableView.allowsSelection = false
            //textField cannot edit
            self.titleTextField.isUserInteractionEnabled = false
            self.seatTextField.isUserInteractionEnabled = false
            self.actorTextField.isUserInteractionEnabled = false
        }
    }
    


    //MARK: - Actions
    //Unwind from SearchMapController
    @IBAction func unwindToCalAddViewController(segue: UIStoryboardSegue){
    }
    
    //Find Route - using SafariViewController
    @IBAction func findRoute(_ sender: Any) {
        var urlString = "https://m.map.naver.com/search2/search.nhn?query="
        //locationDetail -> url encoding
        let escapedString = locationDetail.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        urlString += escapedString!

        let sfViewController = SFSafariViewController(url: NSURL(string: urlString)! as URL, entersReaderIfAvailable: false)
        self.present(sfViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Save data
    @IBAction func saveAction(_ sender: Any) {
        var theaterId : Int = 0
        var theaterObject : Theater?
        var ticketId : Int = 0
        var alarmObjectArray = [Alarm]()
        //save theater in realm
        if let theaterData = self.theaterData{
            theaterId = self.dataInstacne.addTheaterData(name: theaterData.theaterName, latitude: theaterData.latitude, longtitude: theaterData.longtitude, mapImage: theaterData.mapSelectedImage, locationDetail: theaterData.locationDetail)
        }
        
        //save alarm in realm
        for index in self.alarmSet{
            let timeTrigger = self.makeAlarmTrigger(setDate: datePicker.date, index: index)
            let contentTitle = self.titleTextField.text
            let remain = self.alarmAllDic[index]!
            let contentBody = "공연 \(remain) 입니다!"
            let alarmObject = self.dataInstacne.addAlarmData(setTime: timeTrigger, contentTitle: contentTitle!, contentBody: contentBody)
            alarmObjectArray.append(alarmObject)
        }
        
        //save ticket in realm
        //Get theater object
        if theaterId > 0{
            theaterObject = self.dataInstacne.getTheaterById(theaterId)
        }
        ticketId = self.dataInstacne.addBasicContents(name: self.titleTextField.text!, seat: self.seatTextField.text, date: self.datePicker.date as NSDate, genre: self.genreLabel.text!, theater: theaterObject, actor: self.actorTextField.text, alarmLabel: self.alarmLabel.text)
        
        //save alarm objects in ticket
        if alarmObjectArray.count > 0{
            self.dataInstacne.addAlarmObjectInTicket(alarms: alarmObjectArray, id: ticketId)
        }
        
        //save alarm in notification
        for alarm in alarmObjectArray{
            self.ticketNotfication.setNotification(identifier: "\(alarm.id)", title: alarm.contentTitle, body: alarm.contentBody, setTime: alarm.triggerTime)
        }
        
        ticketNotfication.showList()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Show Ticket
    func showSelectedTicket(){
        if let showTicket = showTicket{
            
            self.titleTextField.text = showTicket.name
            self.seatTextField.text = showTicket.seat
            self.datePicker.date = showTicket.date as Date
            self.dateLabel.text = dateFormat.string(from: showTicket.date as Date)
            self.genreLabel.text = showTicket.genre
            self.actorTextField.text = showTicket.actor
            self.theaterNameLabel.text = showTicket.theater?.theaterName
            let tempImage = UIImage(data: showTicket.theater?.mapImage as! Data)
            self.mapImageView.image = tempImage
            self.locationDetail = (showTicket.theater?.locationDetail)!
            if showTicket.alarmLabel == ""{
                self.alarmLabel.text = "알람없음"
            } else{
                self.alarmLabel.text = showTicket.alarmLabel
            }
        }
    }
    
    // MARK: - Date Picker
    //함수를 호출하면 datapicker show
    func toggleShowDatepicker () {
        self.datePickerFlag = !datePickerFlag
        
        self.dateLabel.text = dateFormat.string(from: datePicker.date)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    //date picker의 값이 바뀌면 detial label 값 변경
    @IBAction func showDatePickerDate(_ sender: Any) {
        let setDate = datePicker.date
        self.dateLabel.text = self.dateFormat.string(from: setDate)
        //date Picker의 값이 바뀌면 Alarm 초기화
        self.initButton()
    }
    
    //MARK: - TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide keyboard
        textField.resignFirstResponder()
        return true
    }
}


//MARK: - TableView Delegate
extension CalAddViewController{
    //row 선택시 이벤트
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
       
        //Date row를 클릭하면
        if indexPath.section == 1 && indexPath.row == 2
        {
            //datePicker show
            if !self.datePickerFlag{
                self.toggleShowDatepicker()
            }
            //datePicker hide
            else{
                self.toggleShowDatepicker()
            }
        }
        
        //Alarm row를 클릭하면
        if indexPath.section == 1 && indexPath.row == 4
        {
            //alarm picker show
            if !self.alarmPickFlag{
                self.toggleShowAlarmPicker()
                //Alarm 설정할 때 오늘보다 이전 날짜는 알람 설정 못하게 계산
                self.compareDate()
            }
            //alarm pick hide & show date in label
            else{
                self.toggleShowAlarmPicker()
            }
        }
        
        //Genre row를 클릭하면
        if indexPath.section == 1 && indexPath.row == 6
        {
            //genre picker show
            if !genrePickerFlag{
                self.toggleShowgenrePicker()
            }
            //datePicker hide & show date in label
            else{
                self.toggleShowgenrePicker()
            }
        }
    }
    
    //row height 정하기
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Hide 되어 있어야 할 경우 date picker의 height를 0으로 줌
        if !self.datePickerFlag && indexPath.section == 1 && indexPath.row == 3 {
            return 0
        } else if !self.genrePickerFlag && indexPath.section == 1 && indexPath.row == 7{
            return 0
        } else if !self.alarmPickFlag && indexPath.section == 1 && indexPath.row == 5{
            return 0
        }
        //height를 원래 크기로
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        
    }
    
    //section height
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
}

//MARK:- Genre picker view
extension CalAddViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: Get Data
    func getGenreNameList(){
        let genreList = dataInstacne.getGenreList()
        for genre in genreList{
            self.genreNameList.append(genre.genreName)
        }
    }

    //MARK: Picker View DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genreNameList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.genreNameList[row]
    }
    
    //MARK: Picker View Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        //picker가 움직였는지 확인하는 flag
        self.genreLabelFlag = true
        self.genreLabel.text = self.genreNameList[row]
        
    }
    
    //함수를 호출하면 genre picker show
    func toggleShowgenrePicker () {
        self.genrePickerFlag = !self.genrePickerFlag
        //for first pick
        if self.genreLabelFlag == false{
            self.genreLabel.text = "뮤지컬"
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

}


//MARK: - Alarm Pick
extension CalAddViewController{
    
    
    //함수를 호출하면 alarm picker show
    func toggleShowAlarmPicker () {
        self.alarmPickFlag = !self.alarmPickFlag
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    
    //알람 설정이 가능한지 비교
    //targetDate가 현재시간 보다 전이면 불가능
    func compareDate(){
        let today = Date()
        let setDate = self.datePicker.date
        for idx in 1..<7{
            let targetDate = self.makeAlarmTrigger(setDate: setDate, index: idx) as Date
            if targetDate < today{
                self.possibleClickFlag[idx-1] = false
            } else {
                self.possibleClickFlag[idx-1] = true
            }
        }
    }
    
    
    //make alarm trigger
    func makeAlarmTrigger(setDate: Date, index: Int) -> NSDate{
        let oneDay = -24*60*60
        let days = self.alarmTimeDic[index]! * oneDay
        let setTime = NSDate(timeInterval: TimeInterval(days), since: setDate)
        return setTime
    }
    
    //버튼 초기화 -> Date 바뀔 때
    func initButton(){
        for idx in 1..<7{
            let tmpButton = self.view.viewWithTag(idx) as? UIButton
            tmpButton?.isSelected = false
            self.clickedFlag[idx-1] = false
        }
        self.alarmLabel.text = ""
        self.alarmSet.removeAll()
        
    }

    //버튼 눌렀을 때 label에 보임
    @IBAction func buttonPressed(_ sender : UIButton!){
        
        let senderTag = sender.tag
        //날짜가 클릭이 가능하고, deselect상태일 경우, button can pressed
        if self.possibleClickFlag[senderTag-1] == true, self.clickedFlag[senderTag-1] == false{
            sender.isSelected = true
            self.clickedFlag[senderTag-1] = true
            self.makeAlarmLabel(tag: senderTag, addFlag: true)
        }
        else if clickedFlag[senderTag-1] == true{
            sender.isSelected = false
            self.clickedFlag[senderTag-1] = false
            self.makeAlarmLabel(tag: senderTag, addFlag: false)
        }

    }
    
    func makeAlarmLabel(tag: Int, addFlag: Bool){
        if addFlag {
            self.alarmSet.insert(tag)
        } else{
            self.alarmSet.remove(tag)
        }
        var alarmListString = ""
        for index in self.alarmSet.sorted(){
            alarmListString += self.alarmAllDic[index]!
            alarmListString += " "
        }
        self.alarmLabel.text = alarmListString
    }
    
}



