//
//  PermissionStatus.swift
//  PermissionManager
//
//  Created by Aneesh on 10/9/18.
//  Copyright © 2018 Aneesh. All rights reserved.
//

public enum PermissionStatus: String, CustomStringConvertible {
    case authorized     = "authorized"
    case denied         = "denied"
    case notDetermined  = "notDetermined"
    case restricted     = "restricted"
    
    public var description: String {
        switch self {
        case .authorized:
            return "User has authorized the permission request"
        case .denied:
            return "User has denied the permission request"
        case .notDetermined:
            return "Permission status is not determined"
        case .restricted:
            return "Permission is restricted by OS"
        }
    }
}
