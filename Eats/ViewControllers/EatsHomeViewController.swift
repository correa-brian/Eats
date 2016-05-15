//
//  EatsHomeViewController.swift
//  Eats
//
//  Created by Brian Correa on 5/15/16.
//  Copyright © 2016 milkshake-systems. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class EatsHomeViewController: EatsViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var eatsTable: UITableView!
    var locationManager: CLLocationManager!
    var venuesArray = Array<EatsVenue>()
    
    //MARK: Lifecyle Methods
    
    override func loadView() {
        
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.blueColor()
        
        self.eatsTable = UITableView(frame: frame, style: .Plain)
        self.eatsTable.delegate = self
        self.eatsTable.dataSource = self
        
        self.eatsTable.autoresizingMask = .FlexibleTopMargin
        self.eatsTable.separatorStyle = .None
        
        view.addSubview(self.eatsTable)
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    //MARK - LocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        
        if (status == .AuthorizedWhenInUse){ //user said 'YES'
            print("Authorized When In Use")
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        print("didUpdateLocations: \(locations)")
        if(locations.count == 0){
            return
        }
        
        let loc = locations[0]
        let now = NSDate().timeIntervalSince1970
        let locationTime = loc.timestamp.timeIntervalSince1970
        let delta = now-locationTime
        
        print("NOW = \(now)")
        print("Location Time = \(locationTime)")
        print("DELTA = \(delta)")
        
        if (delta > 10){
            return
        }
        
        if (loc.horizontalAccuracy > 100){
            return
        }
        
        self.locationManager.stopUpdatingLocation()
        print("Found Current Location: \(loc.description)")
        
        let latLng = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"

        let url = "https://api.foursquare.com/v2/venues/search?v=20140806&ll=\(latLng)&client_id=VZZ1EUDOT0JYITGFDKVVMCLYHB3NURAYK3OHB5SK5N453NFD&client_secret=UAA15MIFIWVKZQRH22KPSYVWREIF2EMMH0GQ0ZKIQZC322NZ"
        
        Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, AnyObject>{
//                print("\(JSON)")
                
                if let resp = JSON["response"] as? Dictionary<String, AnyObject>{
//                    print("\(resp)")
                    if let venues = resp["venues"] as? Array<Dictionary<String, AnyObject>>{
//                        print("New Venue--------------\(venues)")
                        
                        for venueInfo in venues {
                            let venue = EatsVenue()
                            venue.populate(venueInfo)
                            self.venuesArray.append(venue)
                        }
                        
                        self.eatsTable.reloadData()
                    }
                }
            }
        }
        
    }
    
    //MARK: Table Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.venuesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "cellId"
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId){
            return self.configureCell(cell, indexPath: indexPath)
        }
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        return self.configureCell(cell, indexPath: indexPath)
        
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        
        let venue = self.venuesArray[indexPath.row]
        
        cell.textLabel?.text = venue.name
        
        var details = venue.address
        
        if(venue.address.characters.count > 0 && venue.phone.characters.count > 0){
            details = "\(venue.address), \(venue.phone)"
        }
        else {
            details = "\(venue.address)\(venue.phone)"
        }
        
        cell.detailTextLabel?.text = details
        
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
