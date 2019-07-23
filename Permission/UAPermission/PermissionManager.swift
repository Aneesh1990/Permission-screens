//
//  PermissionManager.swift
//  PermissionManager
//
//  Created by Aneesh on 10/9/18.
//  Copyright © 2018 Aneesh. All rights reserved.
//
import UIKit
import Foundation

public final class PermissionManager {
    // MARK: PermissionManager singleton initialization
    public static let shared = PermissionManager()
    
    private lazy var locationAlwaysPermission = LocationAlwaysPermission()
    private lazy var locationWhileUsingPermission = LocationWhileUsingPermission()
    
    private init() { }
    
    public func permissionStatus(for type: PermissionType) -> PermissionStatus {
        switch type {
       case .camera:
            return getStatus(from: CameraPermission())
        case .locationAlways:
            return getStatus(from: locationAlwaysPermission)
        case .locationWhileUsing:
            return getStatus(from: locationWhileUsingPermission)
        case .notifications:
            return getStatus(from: NotificationPermission())
        case .photos:
            return getStatus(from: PhotosPermission())
        }
    }
    
    @available(iOS 8.0, *)
    public func openSettings(asking permissionType: PermissionType) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            debugPrint("🚫 \(#function) - Line \(#line): Couldn't get Bundle Identifier")
            return
        }
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString.appending(bundleIdentifier)) else {
            debugPrint("🚫 \(#function) - Line \(#line): Couldn't build Settings URL")
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(settingsURL)
        }
    }
    
    private func getStatus(from object: PermissionState) -> PermissionStatus {
        return object.status
    }
    
    
    public func askUserPermission(for type: PermissionType, completion: PermissionRequestCompletion) {
        switch type {
       case .camera:
            requestPermission(for: CameraPermission(), completion: completion)
        case .locationAlways:
            requestPermission(for: locationAlwaysPermission, completion: completion)
        case .locationWhileUsing:
            requestPermission(for: locationWhileUsingPermission, completion: completion)
        case .notifications:
            requestPermission(for: NotificationPermission(), completion: completion)
        case .photos:
            requestPermission(for: PhotosPermission(), completion: completion)
       
        }
    }
    
    private func requestPermission(for object: PermissionRequest, completion: PermissionRequestCompletion) {
        object.requestPermission(completion: completion)
    }
}
