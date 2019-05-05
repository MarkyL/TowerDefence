//
//  LocationUtil.swift
//  MineSweeper
//
//  Created by Mark Lurie on 05/05/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import UIKit

protocol LocationDelegate: class {
    
    func onAuthorizedWhenInUse()
    func onDenied()
    func onNotDetermined()
    func onRestricted()
    func onAuthorizedAlways()
    func setupLocationManager()
}
