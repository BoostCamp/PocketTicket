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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //table view에서 navibar 만큼 내려가는 간격 없애기
        automaticallyAdjustsScrollViewInsets = false
        
        createDirectory()
        //get photo array
        loadPhotoList()
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

        if totalPhotoNum != 0{
            let titleText = "\(currentPhotoIdx+1) / \(totalPhotoNum)"
            self.title = titleText
//            photoCollectionView.scrollToItem(at: IndexPath(row: currentPhotoIdx, section: 0), at: .right, animated: true)
        }
        
//        if isAddPhoto{
//            isAddPhoto = false
//            photoCollectionView.scrollToItem(at: IndexPath(row: totalPhotoNum-1, section: 0), at: .right, animated: true)
//        }
        
        photoCollectionView.reloadData()
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
            return UIImage(named: "story2")!
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
        let titleText = "\(currentPhotoIdx+1) / \(totalPhotoNum)"
        self.title = titleText
    }
    

    
    // MARK: - Share
    @IBAction func shareImage(_ sender: Any) {
//        let photoNSData = photoNameArray[currentPhotoIdx]
//        let photoUIImage = UIImage(data: photoNSData as Data)
//        let image : UIImage = photoUIImage!
//        let activityController = UIActivityViewController(activityItems:[image], applicationActivities: nil)
//        self.present(activityController, animated:true, completion: nil)
//        
//        //The completion handler to execute after the activity view controller is dismissed.
//        activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
//            
//            // Return if cancelled
//            if (!completed) {
//                print("fail save the image")
//                return
//            }
//            
//            //Activity complete
//            print("success save the image")
//        }

    }
    
    //TODO : DB에서 데이터 삭제하기, Title 바꾸기
    @IBAction func deleteImage(_ sender: Any) {
        let photoIndexPath = IndexPath(row: currentPhotoIdx-1, section: 0)
//        photoCollectionView.deleteItems(at: [photoIndexPath as IndexPath])
        photoNameArray.remove(at: currentPhotoIdx)
        totalPhotoNum = photoNameArray.count
        print(photoNameArray.count)
        photoCollectionView.scrollToItem(at: photoIndexPath, at: .left, animated: true)
        photoCollectionView.reloadData()


    }
  

    @IBAction func connectDKImagePicker(_ sender: Any) {
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            //give alert
            if assets.count > 0 {
                self.alertSavePhotos()
                self.isAddPhoto = true
            }
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
            //reload datas
            self.loadPhotoList()
        }
     
        
        self.present(pickerController, animated: true){}
    }
    
    func alertSavePhotos(){
        let alertController = UIAlertController(title: "알림", message: "사진이 저장되었습니다.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            self.photoCollectionView.reloadData()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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






