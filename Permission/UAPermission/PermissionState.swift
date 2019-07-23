//
//  PermissionState.swift
//  PermissionManager
//
//  Created by Aneesh on 10/9/18.
//  Copyright © 2018 Aneesh. All rights reserved.
//


import AVFoundation
import CoreLocation
import Photos
import UserNotifications

protocol PermissionState {
    var status: PermissionStatus { get }
}

extension CameraPermission: PermissionState {
    var status: PermissionStatus {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:       return .authorized
        case .denied:           return .denied
        case .notDetermined:    return .notDetermined
        case .restricted:       return .restricted
        }
    }
}

extension LocationAlwaysPermission: PermissionState {
    var status: PermissionStatus {
        guard CLLocationManager.locationServicesEnabled() else { return .restricted }
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:     return .authorized
        case .authorizedWhenInUse,
             .denied:               return .denied
        case .notDetermined:        return .notDetermined
        case .restricted:           return .restricted
        }
    }
}

extension LocationWhileUsingPermission: PermissionState {
    var status: PermissionStatus {
        guard CLLocationManager.locationServicesEnabled() else { return .restricted }
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways,
             .authorizedWhenInUse:  return .authorized
        case .denied:               return .denied
        case .notDetermined:        return .notDetermined
        case .restricted:           return .restricted
        }
    }
}

extension NotificationPermission: PermissionState {
    var status: PermissionStatus {
        
        if #available(iOS 10.0, *) {
            return getState()
            
        } else {
            let types = UIApplication.shared.enabledRemoteNotificationTypes()
            if types == UIRemoteNotificationType.alert {
                return .authorized
            } else {
                return .denied
            }
        }
    }
    
    func getState() -> PermissionStatus{
        var notificationSettings: UNNotificationSettings?
        let semasphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            UNUserNotificationCenter.current().getNotificationSettings { setttings in
                notificationSettings = setttings
                semasphore.signal()
            }
        }
        semasphore.wait()
        guard let authorizationStatus = notificationSettings?.authorizationStatus else { return .denied }
        return stateIdentify(status: authorizationStatus)
    }
    
    func stateIdentify(status:UNAuthorizationStatus) -> PermissionStatus {
        if status == .authorized{
            return .authorized
        }else if status == .denied{
            return .denied
        }else if status == .notDetermined{
            return .notDetermined
        }else{
            return .denied
        }
    }
}

extension PhotosPermission: PermissionState {
    var status: PermissionStatus {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:       return .authorized
        case .denied:           return .denied
        case .notDetermined:    return .notDetermined
        case .restricted:       return .restricted
        }
    }
}


