//
//  EachTicketsCollectionViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 15..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit
import DKImagePickerController
import Photos


//공연 티켓에 대한 정보 보여주는 View
class EachTicketsCollectionViewController: UICollectionViewController, showphotoDelegate {

    //for data control
    let dataInstance = DataController.sharedInstance()
    var showTicket : Ticket? = nil
    
    //DkImagePickerController
    let pickerController = DKImagePickerController()
    var assets: [DKAsset]?
    
    var selectedUIImage : UIImage?
    var selectedImageNSDataArray = [NSData]()
    var selectedImagePHAssetArray = [PHAsset]()
    var photoDBCount = 0
    
    
    //MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = showTicket?.name
        
        //Collection view select 막음
        self.collectionView?.allowsSelection = false
        
        //Todo : tab bar hide
//        self.hidesBottomBarWhenPushed = true
//        self.edgesForExtendedLayout = UIRectEdge.bottom
    
        //back button : action을 걸기 위해서 원래의 back button을 지우고 새로운 Back을 만듬
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "<Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        //DB에 사진이 있는지 확인하기 위한 변수
        photoDBCount = (showTicket?.photos.count)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        collectionView?.reloadData()
        
    }

    //back button을 눌렀을 경우, 사진들을 DB에 저장
    func back(sender: UIBarButtonItem) {
        //nsdata로 convert
        if selectedImagePHAssetArray.count > 0{
            for phasset in selectedImagePHAssetArray{
                let tempUIImage = getUIImageFromPHAssset(asset: phasset)
                selectedImageNSDataArray.append(getNSDataFromUIImage(image: tempUIImage))
                print(phasset.creationDate)
            }
//            dataInstance.addPhotos(photos: selectedImageNSDataArray, id: (showTicket?.id)!)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //리뷰 작성하는 부분으로 move
        if segue.identifier == "ToWriteReviewSegue"{
            let navController = segue.destination as? UINavigationController
            let controller = navController?.viewControllers.first as! WriteReviewViewController
            controller.currentTicket = showTicket
        }
    }



}

//MARK: - Collection View
extension EachTicketsCollectionViewController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EachTicketsCollectionViewCell", for: indexPath) as! EachTicketsCollectionViewCell
        
        //set date format
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd EE a h:mm"
        let selectedDate = dateFormat.string(from: showTicket?.date as! Date)
        
        //////Todo: optional 수정
        let theaterName = showTicket?.theater?.theaterName
        let seat = showTicket?.seat
        if let theaterName = theaterName, let seat = seat{
            let theaterNameAndSeat = "\(theaterName) \(seat)"
            cell.seatLabel.text = theaterNameAndSeat
        }
        
        cell.dateLabel.text = selectedDate
        cell.oneSentenceLabel.text = showTicket?.oneSentence
        
        
        //image add
        if photoDBCount > 0 {
            let firstPhoto = showTicket?.photos.first?.photoPath
//            cell.photoImageView.image = getUIImageFromNSData(data: firstPhoto!)
        } else{
            //db에 저장된 이미지가 없을 경우
            print("There is no image in db")
            if let selectedUIImage = selectedUIImage{
                cell.photoImageView.image = selectedUIImage
                print("selectedUIImage")
                print(selectedUIImage)
                print(selectedImagePHAssetArray.count)
            }else{
                cell.photoImageView.image = UIImage(named: "story2")
            }
        }
        
        //사진 / 리뷰
        if indexPath.row == 0 {
            cell.photoImageView.isHidden = false
            cell.reviewTextView.isHidden = true
            
        }
        if indexPath.row == 1{
            if let review = showTicket?.review{
                cell.reviewTextView.text = review
            } else{
                cell.reviewTextView.text = "리뷰를 입력해주세요"
            }
            
            cell.reviewTextView.isHidden = false
            cell.photoImageView.isHidden = true
        }
        
        //set delegate
        cell.configureCell()
        cell.delegate = self
        //        cell.tag = indexPath.row
        
        return cell
    }
    

}

//MARK: - Show photo View delegate
extension EachTicketsCollectionViewController{
    func imageViewTapped(cell: EachTicketsCollectionViewCell){
        let selectedTicket = showTicket
        
        let photoViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
        
        photoViewController.showTicket = selectedTicket
        
        self.navigationController!.pushViewController(photoViewController, animated: true)
    }
    
}

//MARK: - Multiple Image Picker
//Todo : 사진 뜰 때 까지 로딩 화면 넣기
extension EachTicketsCollectionViewController{
    //select muliple image
    @IBAction func connectDkImagePicker(_ sender: Any) {
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            self.selectedUIImage = nil
            self.selectedImagePHAssetArray.removeAll()
            
            //PHAsset 배열에 저장하고, 나중에 db에 저장할 때 NSData로 Convert
            if self.photoDBCount > 0 {//메인 사진을 바꾸지 않아도 될 경우
                for asset in assets{
                    let selectedPHAsset = asset.originalAsset
                    self.selectedImagePHAssetArray.append(selectedPHAsset!)
                    print(selectedPHAsset)
                    print(selectedPHAsset?.creationDate)
                }
            }
            else{//메인 사진을 선택한 첫번째 사진으로 해야할 경우
                for asset in assets{
                    if asset == assets[0]{
                        let firstPHAsset = asset.originalAsset
                        self.selectedUIImage = self.getUIImageFromPHAssset(asset: firstPHAsset!)
                    }
                    let selectedPHAsset = asset.originalAsset
                    print("Selected PHAsset")
                    print(selectedPHAsset)

                    self.selectedImagePHAssetArray.append(selectedPHAsset!)
                }

            }
            
            self.collectionView?.reloadData()
        }
        
        self.present(pickerController, animated: true){}
        
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
    
    //UIImage -> NSData
    func getNSDataFromUIImage(image: UIImage) -> NSData{
        let imageToNSData = UIImagePNGRepresentation(image)
        return (imageToNSData as NSData?)!
    }
    
    //NSData -> UIImage
    func getUIImageFromNSData(data: NSData) -> UIImage{
        let tempImage = UIImage(data: data as Data)
        return tempImage!
    }

    
    
}














