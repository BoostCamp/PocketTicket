//
//  SearchMapViewController.swift
//  PocketTicket
//
//  Created by 하연 on 2017. 2. 14..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit
import MapKit


class SearchMapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MKMapViewDelegate{
    
    //Data model
    let dataInstance = DataController.sharedInstance()
    var mapImageArray = [UIImage]()
    
    //for map
    var mapView = MKMapView()
    var matchingItems: [MKMapItem] = []
    
    @IBOutlet weak var tableView: UITableView!
    var searchController = UISearchController()
    
    var naverMapView: NMapView?
    var longtitude : Double = 0.0
    var latitude : Double = 0.0
    var locationTitle : String = ""
    var locationDetail : String = ""
    
    var superViewFlag = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        //Set delegate
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        //Add to top of table view
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.reloadData()
        
        
//        self.automaticallyAdjustsScrollViewInsets = false
        

        self.searchController.searchBar.barTintColor = UIColor(red: 235/255, green: 72/255, blue: 79/255, alpha: 1.0)
        
        self.searchController.searchBar.tintColor = UIColor.white
        


        
    }
    
    
    //MARK: - SearchBar Delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    

    
    
    //MARK: - Table view DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        print(selectedItem)
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = selectedItem.title!
        
        return cell
    }
    
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        let selectedName = selectedItem.name
        let selectedLatitude = selectedItem.coordinate.latitude
        let selectedLongitude = selectedItem.coordinate.longitude
        let selectedDetail = selectedItem.title
        

        self.latitude = selectedLatitude
        self.longtitude = selectedLongitude
        self.locationTitle = selectedName!
        self.locationDetail = selectedDetail!
        
//        self.searchController.searchBar.isHidden = true
        //hide keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        
        showNaverMap()
        showMarkers()
        
    }
    
    func showNaverMap(){
        naverMapView = NMapView(frame: self.view.frame)
        if let naverMapView = naverMapView {
            
            // set the delegate for map view
            naverMapView.delegate = self
            
            // set the application api key for Open MapViewer Library
            naverMapView.setClientId("0SZHuD47gj6FUnx0xO_q")
            naverMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            //            mapViewContainer.advarbview(mapView)
            view.addSubview(naverMapView)
            superViewFlag = true
            
        }
    }
    func captureImage() -> UIImage{
        //Screenshot
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let mapImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return mapImage
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapDone"{
            print("hi")
            let mapCaputerImage = captureImage()
//            dataInstance.addTheaterData(name: locationTitle, latitude: latitude, longtitude: longtitude, mapImage: mapImage)
            let controller = segue.destination as! CalAddViewController
            let theaterTuple = (locationTitle, self.longtitude, self.latitude, mapCaputerImage, self.locationDetail)
            controller.theaterData = theaterTuple
            print(theaterTuple.0)
        }
    }
    
   
    

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if superViewFlag {
            view.addSubview(tableView)
            superViewFlag = false
        }
    }
    
}

extension SearchMapViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else{
            print("fail")
            return
            
        }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension SearchMapViewController: NMapViewDelegate, NMapPOIdataOverlayDelegate {
    
    
    // MARK: - NMapViewDelegate Methods
    
    open func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            print("latitude : \(latitude)")
            print("longtitude : \(longtitude)")
            mapView.setMapCenter(NGeoPoint(longitude:longtitude, latitude:latitude
            ), atLevel:11)
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
            // set map mode : vector/satelite/hybrid
            mapView.mapViewMode = .vector
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    
    // MARK: - NMapPOIdataOverlayDelegate Methods
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected);
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0.5, y: 0.0)
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    //marker title 보여줌
//    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView! {
//        calloutLabel.text = poiItem.title
//        calloutPosition.pointee.x = round(calloutView.bounds.size.width / 2) + 1
//        return calloutView
//    }
    
    // MARK : Marker
    
    func showMarkers() {
        
        if let mapOverlayManager = naverMapView?.mapOverlayManager {
            
            // create POI data overlay
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                
                poiDataOverlay.initPOIdata(1)
                
                
                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: longtitude, latitude: latitude), title: locationTitle, type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)
                print(longtitude)
                print(latitude)
                
                poiDataOverlay.endPOIdata()
                
                // show all POI data
                //                poiDataOverlay.showAllPOIdata()
                poiDataOverlay.showAllPOIdata(atLevel: 12)
                poiDataOverlay.selectPOIitem(at: 0, moveToCenter: true, focusedBySelectItem: true)
               
                
                
            }
        }
    }
    
    func clearOverlays() {
        if let mapOverlayManager = naverMapView?.mapOverlayManager {
            mapOverlayManager.clearOverlays()
        }
    }
    
    
}

