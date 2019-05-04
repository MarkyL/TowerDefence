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

class ScoreScreenViewController: UIViewController, UITableViewDataSource{


    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    
    var scoreData : [String] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthorization()
        
        tableView.dataSource = self
        
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
    
    //location region
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(location, regionInMeters, regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            handleDeniedLocationAuthorizationState()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func handleDeniedLocationAuthorizationState() {
        let alertController = UIAlertController(title: NSLocalizedString("Enter your title here", comment: ""), message: NSLocalizedString("Enter your message here.", comment: ""), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (cancelAction) in
                _ = self.navigationController?.popViewController(animated: true)
        }
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
            UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ScoreScreenViewController: CLLocationManagerDelegate {
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
