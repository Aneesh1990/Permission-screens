//
//  PermissionRequest.swift
//  PermissionManager
//
//  Created by Aneesh on 10/9/18.
//  Copyright © 2018 Aneesh. All rights reserved.
//


import AVFoundation
import CoreLocation
import Photos
import UserNotifications

public typealias PermissionRequestCompletion = ((_ status: PermissionStatus?) -> Void)?

protocol PermissionRequest {
    func requestPermission(completion: PermissionRequestCompletion)
}

extension CameraPermission: PermissionRequest {
    func requestPermission(completion: PermissionRequestCompletion) {
        guard status == .notDetermined else {
            completion?(status)
            return
        }
        
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            let status: PermissionStatus = granted ? .authorized : .denied
            completion?(status)
        }
    }
}

extension LocationAlwaysPermission: PermissionRequest, CLLocationManagerDelegate {
    func requestPermission(completion: PermissionRequestCompletion) {
        guard status == .notDetermined else {
            completion?(status)
            return
        }
        
        self.locationManager.requestAlwaysAuthorization()
        
        // A simple hack to stop calling completion twice.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            self?.completion = completion
        }
    }
    
func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            completion?(.authorized)
        case .authorizedWhenInUse,
             .denied:
            completion?(.denied)
        case .notDetermined:
            completion?(.notDetermined)
        case .restricted:
            completion?(.restricted)
        }
        
        completion = nil
    }
}

extension LocationWhileUsingPermission: PermissionRequest, CLLocationManagerDelegate {
    func requestPermission(completion: PermissionRequestCompletion) {
        guard status == .notDetermined else {
            completion?(status)
            return
        }
        
        self.locationManager.requestWhenInUseAuthorization()
        
        // A simple hack to stop calling completion twice.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            self?.completion = completion
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse:
            completion?(.authorized)
        case .denied:
            completion?(.denied)
        case .notDetermined:
            completion?(.notDetermined)
        case .restricted:
            completion?(.restricted)
        }
        
        completion = nil
    }
}



extension NotificationPermission: PermissionRequest {
    func requestPermission(completion: PermissionRequestCompletion) {
        if #available(iOS 10.0, *) {
            let authorizationOptions: UNAuthorizationOptions = [ .alert, .badge, .sound ]
            
            UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions) { (granted, error) in
                guard error == nil else {
                    completion?(.restricted)
                    return
                }
                
                let requestStatus: PermissionStatus = granted ? .authorized : .denied
                completion?(requestStatus)
            }
        } else {
            let notificationTypes: UIUserNotificationType = [ .alert, .badge, .sound ]
            let settings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            completion?(nil) // Still has issue, no callback to know status
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
}

extension PhotosPermission: PermissionRequest {
    func requestPermission(completion: PermissionRequestCompletion) {
        guard status == .notDetermined else {
            completion?(status)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:       completion?(.authorized)
            case .denied:           completion?(.denied)
            case .notDetermined:    completion?(.notDetermined)
            case .restricted:       completion?(.restricted)
            }
        }
    }
}


