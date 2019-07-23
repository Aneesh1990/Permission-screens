//
//  PermissionClasses.swift
//  PermissionManager
//
//  Created by Aneesh on 10/9/18.
//  Copyright © 2018 Aneesh. All rights reserved.
//


import CoreLocation



final class LocationAlwaysPermission: NSObject {
    var completion: PermissionRequestCompletion = nil
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
}

final class LocationWhileUsingPermission: NSObject {
    var completion: PermissionRequestCompletion = nil
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
}

final class NotificationPermission {}

final class PhotosPermission {}

final class CameraPermission {}

