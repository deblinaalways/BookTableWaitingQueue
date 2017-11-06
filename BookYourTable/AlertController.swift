//
//  AlertController.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import Foundation
import UIKit

class AlertController {
    
    class func present(title: String, message: String, from presentingViewController: UIViewController? = nil, okAction: (()->Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in okAction?() }))
        (presentingViewController ?? UIWindow.visibleViewController())?.present(alertController, animated: true, completion: nil)
    }
    
    class func present(title: String, message: String, okTitle: String, cancelTitle: String, from presentingViewController: UIViewController? = nil, okAction: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: { _ in okAction() } )
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        (presentingViewController ?? UIWindow.visibleViewController())?.present(alertController, animated: true, completion: nil)
    }
    
    class func present(title: String, message: String, okTitle: String, cancelTitle: String, from presentingViewController: UIViewController? = nil, okAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: { _ in okAction() } )
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in cancelAction() })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        (presentingViewController ?? UIWindow.visibleViewController())?.present(alertController, animated: true, completion: nil)
    }
    
}

