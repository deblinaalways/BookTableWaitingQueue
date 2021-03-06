//
//  ActivityIndicator.swift
//  BookYourTable
//
//  Created by Deblina Das on 06/11/17.
//  Copyright © 2017 Deblinas. All rights reserved.
//

import UIKit

/** The start method shows a greyed out view that covers the whole screen with an activity indicator animating at the centre.
 
 Sets the activity indicator style, colour and the view background colour as desired, or leaves it as default. Disables user interaction during the animation re-enables it at stop.
 
 <Code>start</Code> and <Code>stop</Code> calls need not be strictly balanced.
 
 Use it with a lazy instatiation, so it is loaded only when necessary.
 
 <Code>private lazy var activityIndicator: HWActivityIndicator = HWActivityIndicator(viewController: self)</Code>
 
 */
class ActivityIndicator: NSObject {
    
    private weak var viewController: UIViewController?
    private var viewWithActivityIndicator: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    
    init(viewController: UIViewController, style: UIActivityIndicatorViewStyle = .whiteLarge, color: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.lightGray) {
        
        self.viewController = viewController
        super.init()
        
        setupViewWithActivityIndicatorWithBackgroundColor(backgroundColor: backgroundColor)
        setupActivityIndicatorWithStyle(style: style, withColor: color)
        
        viewWithActivityIndicator.addSubview(activityIndicator)
    }
    
    deinit {
        viewWithActivityIndicator.removeFromSuperview()
    }
    
    private func setupViewWithActivityIndicatorWithBackgroundColor(backgroundColor: UIColor) {
        viewWithActivityIndicator = UIView(frame: viewController!.view.frame)
        viewWithActivityIndicator.backgroundColor = backgroundColor
        viewWithActivityIndicator.alpha = 0.5
    }
    
    public func setupActivityIndicatorWithStyle(style: UIActivityIndicatorViewStyle, withColor color: UIColor) {
        activityIndicator        = UIActivityIndicatorView(activityIndicatorStyle: style)
        activityIndicator.color  = color
        activityIndicator.center = viewWithActivityIndicator.center
    }
    
    func start() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            if let tableViewController = self.viewController as? UITableViewController {
                
                self.viewWithActivityIndicator.frame = CGRect(x: tableViewController.tableView.contentOffset.x, y: tableViewController.tableView.contentOffset.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            } else {
                self.viewWithActivityIndicator.frame = self.viewController!.view.bounds
            }
            self.viewController!.view.isUserInteractionEnabled = false
            if self.viewController!.view.subviews.contains(self.viewWithActivityIndicator) {
                self.viewWithActivityIndicator.bringSubview(toFront: self.activityIndicator)
            } else {
                self.viewController!.view.addSubview(self.viewWithActivityIndicator)
            }
        }
    }
    
    func stop() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.viewController?.view?.isUserInteractionEnabled = true
            self.viewWithActivityIndicator?.removeFromSuperview()
        }
    }
    
}
