//
//  UAPermissonController.swift
//  Permission
//
//  Created by Aneesh on 10/9/18.
//  Copyright © 2018 Aneesh. All rights reserved.
//

import Foundation
import UIKit

class UAPermissonController: UIViewController {
    
    
    
    var permissionTypeSelected:PermissionType!
    @IBOutlet weak var permissionIcon:UIImageView!
    @IBOutlet weak var permissionTitleLbl:UILabel!
    @IBOutlet weak var permissionDescriptionLbl:UILabel!
    @IBOutlet weak var permissionGrandBut:UIButton!
    @IBOutlet weak var permissionCancelBut:UIButton!
    @IBOutlet weak var permissionContainerView:UIView!
    @IBOutlet weak var popupImageView: UIImageView!
    @IBOutlet weak var permissionImageView:UIImageView!
    @IBOutlet weak var popupTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var iPhoneCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var iPhoneCenterX: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let dic =  getPermissionPlist()
            if let contentDic = dic[permissionTypeSelected.description] as? [String:Any] {
                //  permissionIcon.image = UIImage(named:permissionTypeSelected.description)
                permissionTitleLbl.text = contentDic["title"] as? String
                permissionDescriptionLbl.text = contentDic["description"] as? String
                permissionGrandBut.setTitle(contentDic["buttonTitle"] as? String, for: .normal)
                popupImageView.image = UIImage(named: contentDic["permissionPopupImage"] as! String)
                if permissionTypeSelected == PermissionType.photos{
                    let jeremyGif = UIImage.gifImageWithName("iPhone_Photos_Popup")
                    permissionImageView.image = jeremyGif
                }else{
                    permissionImageView.image = UIImage(named: contentDic["permissionImage"] as! String)
                }
                
        }
        loadPermissionLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        switch permissionTypeSelected {
        case .some(.notifications):
            animationNotification()
        case .some(.locationAlways),.some(.locationWhileUsing) :
            animationLocation()
        case .some(.camera):
            animationCamera()
        case .some(.photos):
            animationLibrary()
        default:
            break
        }
        
    }
    
    @IBAction func autharizeClicked(sender:UIButton){
        PermissionManager.shared.askUserPermission(for: permissionTypeSelected, completion: { (status) in
            print(status ?? "nil")
            switch status {
            case .none:break
            case .some(.authorized):print("authorized"); self.cancelController()
            case .some(.notDetermined):print("notDetermined")
            case .some(.restricted):print("restricted")
            case .some(.denied): self.cancelController()
            }})
        }
    
    @IBAction func cancelController(){
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
        
}
extension UAPermissonController{
//    LoadImages (set icon initial position)
    func loadPermissionLayout() {
        switch permissionTypeSelected {
        case .some(.notifications):
            permissionImageView.alpha = 0
            popupImageView.alpha = 0
            iPhoneCenterY.constant =  50
            popupTopSpacing.constant = 97
        case  .some(.locationAlways),.some(.locationWhileUsing):
            permissionImageView.alpha = 0
            popupImageView.alpha = 0
            popupImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            iPhoneCenterY.constant = 50
            popupTopSpacing.constant = 0
        case .some(.camera):
            permissionImageView.alpha = 0
            popupImageView.alpha = 0
            popupTopSpacing.constant = -(permissionImageView.center.x)
        case .some(.photos):
            permissionImageView.alpha = 0
            popupImageView.alpha = 0
            iPhoneCenterY.constant = 50
            popupTopSpacing.constant = 0
        default:
            break
        }
    }
    //Animation For Notification
    func animationNotification() {
        iPhoneCenterY.constant = 0
        popupTopSpacing.constant = -87
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseOut , animations: {
            self.permissionImageView.alpha = 1
            self.popupImageView.alpha = 1
            self.view.layoutIfNeeded()
        }) { _ in
            
        }
    }
    
    //Animation For Location
    func animationLocation() {
          iPhoneCenterY.constant = 0
        popupTopSpacing.constant = -150
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut , animations: {
            self.permissionImageView.alpha = 1
            self.popupImageView.alpha = 1
            self.view.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.autoreverse, .repeat], animations: {
                var frame: CGRect = self.popupImageView.frame
                frame.origin.y -= 8
                self.popupImageView.frame = frame
            })
        }
        
       
       
    }
    
    func animationCamera(){
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut , animations: {
            self.permissionImageView.alpha = 1
            self.popupImageView.alpha = 1
            self.view.layoutIfNeeded()
        }) { _ in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.autoreverse,], animations: {
                self.popupImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
            }){_ in
               self.popupImageView.alpha = 0
                 self.permissionImageView.animationImages = [UIImage(named: "iPhone_Camera_Flash")!, UIImage(named: "iPhone_Camera")!]
                self.permissionImageView.animationDuration = TimeInterval(1)
                self.permissionImageView.animationRepeatCount = 1
                 self.permissionImageView.startAnimating()

            
            }
        }
    }
    
    func animationLibrary(){
        iPhoneCenterY.constant = 0
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut , animations: {
            self.permissionImageView.alpha = 1
            self.view.layoutIfNeeded()
        }) { _ in

        }
        
        
        
    }
}

//Mark: ViewController Extension
extension UIViewController{
    func showNotificationController(type:PermissionType) {
        let viewController:UAPermissonController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UAPermissonController") as! UAPermissonController
        viewController.permissionTypeSelected = type
        self.modalPresentationStyle = .custom
        self.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }
    
    func showAlertSettings(type:PermissionType)  {
        let alert = UIAlertController(title: "Permission Required", message: "Permission Denied, Please go to settings for re enable the feature", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Not Now", style:.cancel, handler: nil))
        alert.addAction(UIAlertAction(title:"Open Settings",style:.destructive, handler:  { action in
            DispatchQueue.main.async {
                PermissionManager.shared.openSettings(asking: type)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getPermissionPlist() -> [String: Any]{
        if let path = Bundle.main.path(forResource: "UAPermissionList", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                return dic
            }
            return [:]}
        return [:]}
}

