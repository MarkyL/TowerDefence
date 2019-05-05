//
//  ScoreScreenViewController.swift
//  MineSweeper
//
//  Created by Omri Ohayon on 11/04/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ScoreScreenViewController: UIViewController, UITableViewDataSource {
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    
    var scoreData : [String] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationUtils.checkLocationServices(checkLocationAuthorization: locationManager, listener: self)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let arr = UserDefaults.standard.array(forKey: "scoreData") as? [String] else { return }
        self.scoreData = arr
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scoreData.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyTableCell
        
        let scoreStr = self.scoreData[indexPath.row]
        let scoreArr = scoreStr.components(separatedBy: "_")
        if scoreArr.count == 4 {
            cell.difficultylbl.text = scoreArr[0]
            cell.userNamelbl.text = scoreArr[1]
            cell.scorelbl.text = scoreArr[2]
            cell.datelbl.text = scoreArr[3]
        }
        
        return cell
    }
    
}

extension ScoreScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
    }
}

extension ScoreScreenViewController: CLLocationManagerDelegate {
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        LocationUtils.checkLocationAuthorization(checkLocationAuthorization: locationManager, listener: self)
    }
}

extension ScoreScreenViewController: LocationDelegate {
    func onAuthorizedWhenInUse() {
        mapView.showsUserLocation = true
        LocationUtils.centerViewOnUserLocation(locationManager: locationManager, mapView: mapView)
    }
    
    func onDenied() {
        LocationUtils.handleDeniedLocationAuthorizationState(controller: self.navigationController!)
    }
    
    func onNotDetermined() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func onRestricted() {
        //Stub!
    }
    
    func onAuthorizedAlways() {
        //Stub!
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}
