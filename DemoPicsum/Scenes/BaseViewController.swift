//
//  BaseViewController.swift
//  DemoPicsum
//
//  Created by Nguyen Kiem on 4/21/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var itemLeftNavBar = [UIBarButtonItem]()
    var itemRightNavBar = [UIBarButtonItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
        self.setUpView()
        self.setupIndicator()
        self.navigationItem.leftBarButtonItems = itemLeftNavBar
        self.navigationItem.rightBarButtonItems = itemRightNavBar
    }
    
    func setUpView() {
        self.view.frame = UIScreen.main.bounds
        self.view.layoutIfNeeded()
        self.setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = .systemGray
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    // MARK: - indicator zone
    let indicator = UIActivityIndicatorView()
    let indicatorContainer = UIView()
    
    func setupIndicator() {
        self.indicatorContainer.isHidden = true
        
        let navBarHidden = self.navigationController?.navigationBar.isHidden ?? true
        if !navBarHidden {
            self.navigationController?.view.addSubview(indicatorContainer)
        } else {
            self.view.addSubview(indicatorContainer)
        }
        
        self.indicatorContainer.addSubview(indicator)
        indicatorContainer.centerInSuperview(size: CGSize(width: screenWidth, height: screenHeight))
        indicator.centerInSuperview(size: CGSize(width: 48, height: 48))
        indicatorContainer.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.7)
        indicator.style = .whiteLarge
        indicator.color = .lightGray
    }
    
    func showIndicator( _ isShow : Bool? = true) {
        indicatorContainer.isHidden = !isShow!
        if isShow! {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
    
    // MARK: - Alert
    func displayAlert(title: String? = nil, message: String? = nil, callback: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default, handler: callback)
        )
            
        present(alertController, animated: true, completion: nil)
    }
}
