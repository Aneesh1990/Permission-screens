//
//  PermissionType.swift
//  PermissionManager
//
//  Created by Aneesh on 10/9/18.
//  Copyright © 2018 Aneesh. All rights reserved.
//

public enum PermissionType: CustomStringConvertible {
   case camera
    case locationAlways
    case locationWhileUsing
    case notifications
    case photos
   
    public var description: String {
        switch self {
        case .camera:
            return "Camera"
       case .locationAlways:
            return "Location Always"
        case .locationWhileUsing:
            return "Location While Using"
        case .notifications:
            return "Notification"
        case .photos:
            return "Photos"
        
        }
    }
}
