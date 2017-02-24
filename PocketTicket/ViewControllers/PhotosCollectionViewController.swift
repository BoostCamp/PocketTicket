//
//  PhotosCollectionViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 10..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit
import DKImagePickerController
import Photos

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var addPhotos: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    let dataInstance = DataController.sharedInstance()

    var showTicket : Ticket? = nil
    var photoNameArray = [String]()
    var totalPhotoNum : Int = 0
    var currentPhotoIdx : Int = 0
    var isAddPhoto = false
    
    //DKPicker
    let pickerController = DKImagePickerController()
    var imagesDirectoryPath : String!
    var imageNameArray = [String]()
    var firstShow = true
    var firstTimeAdd = true
    var addImageCount = 0
    
    //indicator
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //table view에서 navibar 만큼 내려가는 간격 없애기
        automaticallyAdjustsScrollViewInsets = false
        
        //create Directory
        createDirectory()
        
        //get photo array
        loadPhotoList()
        
        //show cancel button
        pickerController.showsCancelButton = true
        
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if totalPhotoNum == 0{
            self.title = "Photos"
            deleteButton.isEnabled = false
            shareButton.isEnabled = false
        }
        self.tabBarController?.tabBar.isHidden = true
        
 
 
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if photoNameArray.count > 0{
            
        }
        else if self.firstShow == true{
            connectDKImagePicker(addPhotos)
        }
        self.firstShow = false
    }
    
    func loadPhotoList(){
        if let photoList = showTicket?.photos{
            photoNameArray.removeAll()
            for photo in photoList{
                photoNameArray.append(photo.photoPath!)
            }
        }

        totalPhotoNum = photoNameArray.count

        
        photoCollectionView.reloadData()
        
        
        if totalPhotoNum != 0{
            let titleText = "\(currentPhotoIdx+1) / \(totalPhotoNum)"
            self.title = titleText
            deleteButton.isEnabled = true
            shareButton.isEnabled = true
            
        }
        
        //추가 된 이미지쪽으로 스크롤 움직이기
        if isAddPhoto{
                isAddPhoto = false
                let row = self.totalPhotoNum - self.addImageCount
                let indexPath = IndexPath(row: row, section:0)
                self.photoCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
                let titleText = "\(row+1) / \(totalPhotoNum)"
                self.title = titleText
            
        }
        

        
    }
    
    //MARK: - create Directory
    func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Images")
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
    }

    //image Path -> UIImage
    func getImage(_ ImageName: String) -> UIImage{
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Images")
        let getImagePath = paths.appending("/\(ImageName)")
        print(getImagePath)
        let uiImage = UIImage(contentsOfFile: getImagePath)
        print("changePath : \(ImageName)")
        if let uiImage = uiImage{
            return uiImage
        } else{
            print("conver uiimage fail")
            return #imageLiteral(resourceName: "addPhoto")
        }
    }

    // MARK: UICollectionViewDataSource

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoNameArray.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as! PhotosCollectionViewCell
  
        
        cell.frame.size.width = self.view.frame.width
  
        let certainPhotoName = photoNameArray[indexPath.row]
        cell.fullImageView.image = getImage(certainPhotoName)
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
    }
 
    // MARK: - Scroll event
    //offset을 이용해서 해당하는 카드의 위치를 잡아서 넘김
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Scroll")
        //현재 이미지 offset
        let offsetX = scrollView.contentOffset.x
        //전체 width
        let viewWidth = self.view.frame.width
        print(offsetX)
        print(viewWidth)
     
        //title
        currentPhotoIdx = Int(offsetX/viewWidth)
        print("currentPhotoIdx : \(currentPhotoIdx)")
        let titleText = "\(currentPhotoIdx+1) / \(totalPhotoNum)"
        self.title = titleText
    }
    

    
    // MARK: - Share
    @IBAction func shareImage(_ sender: Any) {
        let selectedPhotoName = photoNameArray[currentPhotoIdx]
        let selectedPhoto = getImage(selectedPhotoName)
        let activityController = UIActivityViewController(activityItems:[selectedPhoto], applicationActivities: nil)
        self.present(activityController, animated:true, completion: nil)
        
        //The completion handler to execute after the activity view controller is dismissed.
        activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            
            // Return if cancelled
            if (!completed) {
                print("fail save the image")
                return
            }
            
            //Activity complete
            //사진이 저장될 경우
            if activityType == UIActivityType.saveToCameraRoll{
                self.alertActivity("sharedSave")
            } else{ //사진을 공유할 경우
                self.alertActivity("share")
            }
            print("success save the image")
        }

    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        deleteAlert()
    }

//    func startIndicator(){
//        self.activityIndicator.center = self.view.center
//        self.activityIndicator.hidesWhenStopped = true
//        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        self.view.addSubview(self.activityIndicator)
//        
//        self.activityIndicator.startAnimating()
//    }
//    
//    func stopIndicator(){
//        self.activityIndicator.stopAnimating()
//    }

    @IBAction func connectDKImagePicker(_ sender: Any) {
        pickerController.didSelectAssets = { (assets: [DKAsset]) in

            print("didSelectAssets")
            print(assets)
            //asset count
            self.addImageCount = assets.count
            print("here")
//            self.startIndicator()
         
            self.imageNameArray.removeAll()
            //save photos
            for asset in assets{
                let phassetPhoto = asset.originalAsset
                let UIImagePhoto = self.getUIImageFromPHAssset(asset: phassetPhoto!)
                let photoName = self.saveImageDocumentDirectory(UIImagePhoto)
                self.imageNameArray.append(photoName)
            }
            //save photos in realm
            self.dataInstance.addPhotos(photos: self.imageNameArray, id: (self.showTicket?.id)!)
    
            //give alert
            if assets.count > 0 {
                self.alertActivity("save")
                self.isAddPhoto = true
            }
            //reload datas
            self.loadPhotoList()
        }
     
        
        self.present(pickerController, animated: true){}
    }
    
    func alertActivity(_ alertType: String){
        var alertMessage = ""
        switch(alertType){
            case "save":
                alertMessage = "사진이 저장되었습니다."
            case "sharedSave" :
                alertMessage = "사진이 저장되었습니다."
            case "share" :
                alertMessage = "사진이 공유되었습니다."
        default:
            break

        }

        let alertController = UIAlertController(title: "알림", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            self.photoCollectionView.reloadData()
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAlert(){
        let alertController = UIAlertController(title: "알림", message: "삭제하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            self.deleteImage()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed cancel")
            
        }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteImage(){
        
        //delete in Realm
        let currentPhotoName = photoNameArray[self.currentPhotoIdx]
        let ticketId = showTicket?.id
        dataInstance.deletePhoto(id: ticketId!, photoName: currentPhotoName)
        
        //delete in directory
        deleteImageInDirectory(currentPhotoName)

        //delete image in array & change title
        self.photoNameArray.remove(at: self.currentPhotoIdx)
        self.totalPhotoNum = self.photoNameArray.count
        
        if self.totalPhotoNum > 0 {
            if self.currentPhotoIdx == self.totalPhotoNum{
                self.currentPhotoIdx -= 1
            }
            let titleText = "\(self.currentPhotoIdx+1) / \(self.totalPhotoNum)"
            
            self.title = titleText
        }
        else {
            self.title = "Photos"
            self.deleteButton.isEnabled = false
            self.shareButton.isEnabled = false
            
        }
        self.photoCollectionView.reloadData()
    }
    
    func deleteImageInDirectory(_ imageName: String){
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Images")
        
        // create a name for your image
        let fileURL = documentsDirectoryURL.appendingPathComponent(imageName)
        print(fileURL)
        
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Image delete Successfully")
            } catch {
                print(error)
            }
        } else {
            print("Image Not deleted")
        }
    }
    
    
    
}


extension PhotosViewController{
    
    func saveImageDocumentDirectory(_ image: UIImage) -> String{

        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Images")

        // create a name for your image
        let imageName = makeImageName()
        let fileURL = documentsDirectoryURL.appendingPathComponent(imageName)

        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try UIImagePNGRepresentation(image)?.write(to: fileURL)
                print("Image Added Successfully")
            } catch {
                print(error)
            }
        } else {
            print("Image Not Added")
        }
 
        return imageName
    }
    
    //make image name using timeStamp
    func makeImageName() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    
    //PHAseet -> UIImage
    func getUIImageFromPHAssset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var selectedImages = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            selectedImages = result!
        })
        
        return selectedImages
    }
    
    

    


}






