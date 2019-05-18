//
//  LocationUtils.swift
//  MineSweeper
//
//  Created by Mark Lurie on 05/05/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationUtils {
    
    static let regionInMeters: Double = 1000
    
    class func checkLocationServices(checkLocationAuthorization : CLLocationManager, listener : LocationDelegate) {
        if CLLocationManager.locationServicesEnabled() {
            listener.setupLocationManager()
            LocationUtils.checkLocationAuthorization(checkLocationAuthorization: checkLocationAuthorization, listener: listener)
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }

    class func checkLocationAuthorization(checkLocationAuthorization : CLLocationManager, listener : LocationDelegate) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            listener.onAuthorizedWhenInUse()
            break
        case .denied:
            listener.onDenied()
            break
        case .notDetermined:
            listener.onNotDetermined()
        case .restricted:
            listener.onRestricted()
            break
        case .authorizedAlways:
            listener.onAuthorizedAlways()
            break
        }
    }
    
    class func handleDeniedLocationAuthorizationState(controller : UINavigationController) {
        let alertController = UIAlertController(title: NSLocalizedString("Location authorization", comment: ""), message: NSLocalizedString("For full functionality, please enable location access.", comment: ""), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (cancelAction) in
            //_ = controller.popViewController(animated: true)
        }
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
            UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func centerViewOnUserLocation(locationManager : CLLocationManager, mapView: MKMapView) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(location, regionInMeters, regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
}


