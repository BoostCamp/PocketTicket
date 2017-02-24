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
    
    //Properites for Alarm Picker
    var alarmPickFlag = false
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var Button3Week: UIButton!
    @IBOutlet weak var Button2Week: UIButton!
    @IBOutlet weak var Button1Week: UIButton!
    @IBOutlet weak var Button5Day: UIButton!
    @IBOutlet weak var Button3Day: UIButton!
    @IBOutlet weak var Button1Day: UIButton!
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
    
    //Label
    
    //Properties for theater
    @IBOutlet weak var theaterNameLabel: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var routeButton: UIButton!
    
    //get theater data from map view by tuple
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
        
        titleTextField.delegate = self
        seatTextField.delegate = self
        actorTextField.delegate = self
    
        //Make genre name list
        getGenreNameList()
        
        routeButton.isHidden = true

        
        if let currentDate = currentDate{
//            let tempDate = DateComponents()
            var calendarUnitFlags : Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]

            
            var dateComponent = Calendar.current.dateComponents(calendarUnitFlags, from: currentDate)
            dateComponent.hour = 20
            dateComponent.minute = 0
            dateComponent.second = 0
            let newDate = dateComponent.date
            print(newDate)
            dateLabel.text = dateFormat.string(from: datePicker.date)
        }
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        

        //Map에서 받아 온 theater 정보 설정 : 이미지, 위치이름
        if let theaterData = theaterData{
            mapImageView.image = theaterData.mapSelectedImage
            theaterNameLabel.text = theaterData.theaterName
            locationDetail = theaterData.locationDetail
            print(locationDetail)
        } else{
            print("fail")
        }
        
        //show data
        if showFlag {
            showSelectedTicket()
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            self.tabBarController?.tabBar.isHidden = true
            routeButton.isHidden = false
            showFlag = false
            self.title = showTicket?.name
            //tableview 선택 안됨
            tableView.allowsSelection = false
            //textField 수정 안됨
            titleTextField.isUserInteractionEnabled = false
            seatTextField.isUserInteractionEnabled = false
            actorTextField.isUserInteractionEnabled = false
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
        let setDate = datePicker.date
//        let threeDayBefore = NSDate(timeInterval: -24*60*60*7, since: setDate)
         self.dateLabel.text = dateFormat.string(from: setDate)
    }

    //MARK: - Actions
    //for unwind
    @IBAction func unwindToCalAddViewController(segue: UIStoryboardSegue){
        print("unwind")
    }
    @IBAction func findRoute(_ sender: Any) {
        print("find route button tapped")
        var urlString = "https://m.map.naver.com/search2/search.nhn?query="
        print("location Detial : \(locationDetail)")
        let escapedString = locationDetail.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        urlString += escapedString!

        let sfViewController = SFSafariViewController(url: NSURL(string: urlString)! as URL, entersReaderIfAvailable: false)
        self.present(sfViewController, animated: true, completion: nil)
     
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Save datas
    @IBAction func saveAction(_ sender: Any) {
        var theaterId : Int = 0
        var ticketId : Int = 0
        var alarmObjectArray = [Alarm]()
        //save theater
        if let theaterData = theaterData{
            theaterId = dataInstacne.addTheaterData(name: theaterData.theaterName, latitude: theaterData.latitude, longtitude: theaterData.longtitude, mapImage: theaterData.mapSelectedImage, locationDetail: theaterData.locationDetail)
        }
        
        //save alarm 
        for index in alarmSet{
            let timeTrigger = makeAlarmTrigger(setDate: datePicker.date, index: index)
            let contentTitle = self.titleTextField.text
            let remain = alarmAllDic[index]!
            let contentBody = "공연 \(remain) 입니다!"
            let alarmObject = dataInstacne.addAlarmData(setTime: timeTrigger, contentTitle: contentTitle!, contentBody: contentBody)
            alarmObjectArray.append(alarmObject)
        }
        
        //save ticket
        if theaterId != 0{
            let theaterObject = dataInstacne.getTheaterById(theaterId)
            ticketId = dataInstacne.addBasicContents(name: self.titleTextField.text!, seat: self.seatTextField.text, date: self.datePicker.date as NSDate, genre: self.genreLabel.text!, theater: theaterObject, actor: self.actorTextField.text, alarmLabel: self.alarmLabel.text)
        }
        
        //save alarm objects in ticket
        if alarmObjectArray.count > 0{
            dataInstacne.addAlarmObjectInTicket(alarms: alarmObjectArray, id: ticketId)
        }
        
        //save in notification 
        for alarm in alarmObjectArray{
            ticketNotfication.setNotification(identifier: "\(alarm.id)", title: alarm.contentTitle, body: alarm.contentBody, setTime: alarm.triggerTime)
        }
        
        ticketNotfication.showList()
//        notficationManager.title = titleTextField.text!
//        notficationManager.body = "공연 \(alarmAllDic[1]!)입니다!"
//        notficationManager.setNotification()
//        notficationManager.showList()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Show Ticket
    func showSelectedTicket(){
        if let showTicket = showTicket{
            
            dateFormat.dateFormat = "yyyy.MM.dd ah:mm"
//            if let currentDate = currentDate{
//                dateLabel.text = dateFormat.string(from: currentDate)
//                datePicker.date = currentDate
//            }

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
            if let alarmLabel = showTicket.alarmLabel{
                self.alarmLabel.text = alarmLabel
            } else{
                self.alarmLabel.text = "알람없음"
            }
        }
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
            if !datePickerFlag{
                toggleShowDatepicker()
            }
                //datePicker hide & show date in label
            else{
                toggleShowDatepicker()
            }
        }
        
        
        //Alarm row를 클릭하면
        if indexPath.section == 1 && indexPath.row == 4
        {
            //alarm picker show
            if !alarmPickFlag{
                toggleShowAlarmPicker()
            }
                //alarm pick hide & show date in label
            else{
                toggleShowAlarmPicker()
            }
        }
        
        //Genre row를 클릭하면
        if indexPath.section == 1 && indexPath.row == 6
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
        if !datePickerFlag && indexPath.section == 1 && indexPath.row == 3 {
            return 0
        } else if !genrePickerFlag && indexPath.section == 1 && indexPath.row == 7{
            return 0
        } else if !alarmPickFlag && indexPath.section == 1 && indexPath.row == 5{
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
        genreLabel.text = genreNameList[row]
        
    }
    
    //함수를 호출하면 genre picker show
    func toggleShowgenrePicker () {
        genrePickerFlag = !genrePickerFlag
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}


//MARK: - Alarm Pick
extension CalAddViewController{
    
    //함수를 호출하면 genre picker show
    func toggleShowAlarmPicker () {
        alarmPickFlag = !alarmPickFlag
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    //버튼 눌렀을 때 label에 보임
    @IBAction func buttonPressed(_ sender : UIButton!){
        print("button pressed")
        let senderTag = sender.tag
        if clickedFlag[senderTag-1] == false{
            sender.isSelected = true
            clickedFlag[senderTag-1] = true
            let alarmListString = addAlarmLabel(senderTag)
            alarmLabel.text = alarmListString
        }
        else if clickedFlag[senderTag-1] == true{
            sender.isSelected = false
            clickedFlag[senderTag-1] = false
            let alarmListString = removeAlarmLabel(senderTag)
            alarmLabel.text = alarmListString
        }

    }
    
    //버튼이 select될 때 add
    func addAlarmLabel(_ tag: Int) -> String{
        self.alarmSet.insert(tag)
        var alarmListString = ""
        for index in self.alarmSet.sorted(){
            alarmListString += alarmAllDic[index]!
            alarmListString += " "
        }
        return alarmListString
    }
    
    //버튼이 deselect될 때 remove
    func removeAlarmLabel(_ tag: Int) -> String{
        self.alarmSet.remove(tag)
        var alarmListString = ""
        for index in self.alarmSet.sorted(){
            alarmListString += alarmAllDic[index]!
            alarmListString += " "
        }
        return alarmListString
    }
    
    //make alarm db
    func makeAlarmTrigger(setDate: Date, index: Int) -> NSDate{
        let oneDay = -24*60*60
        let days = alarmTimeDic[index]! * oneDay
        let setTime = NSDate(timeInterval: TimeInterval(days), since: setDate)
        return setTime
    }
    
}

//MARK: - TextField
extension CalAddViewController{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide keyboard
        textField.resignFirstResponder()
        return true
    }



}


