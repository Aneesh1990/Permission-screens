//
//  ViewController.swift
//  Permission
//
//  Created by Aneesh on 10/9/18.
//  Copyright © 2018 Aneesh. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {

    override func viewDidLoad() {super.viewDidLoad()}
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    @IBAction func change(sender:UIButton){
        var permission:PermissionType!
        switch sender.tag {
        case 1:  permission = .notifications
        case 2:  permission = .locationAlways
        case 3:  permission = .locationWhileUsing
        case 4:  permission = .camera
        case 5:  permission = .photos
        default: break
        }
    switch PermissionManager.shared.permissionStatus(for: permission) {
        case .authorized: print("Autharized")
        case .denied: showAlertSettings(type: permission)
        case .notDetermined: showNotificationController(type: permission)
        case .restricted:  showAlertSettings(type: permission)
        }
    }
}

@IBDesignable class BorderView : UIButton {
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}

