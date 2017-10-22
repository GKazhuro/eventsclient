//
//  MainViewController.swift
//  vkapp
//
//  Created by George Kazhuro on 21.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favoritesItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heartIcon"), style: .plain, target: self, action: #selector(openFavorites))
        navigationItem.rightBarButtonItem = favoritesItem
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.delegate = self
        
        setupImageAtTitle()
    }
    
    func setupImageAtTitle() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "afisha"))
        
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.image = titleImageView.image!.withRenderingMode(.alwaysTemplate)
        titleImageView.tintColor = UIColor.white
        titleImageView.frame = CGRect(x: 0, y: 0, width: titleView.bounds.width, height: titleView.bounds.height)
        
        titleView.addSubview(titleImageView)
        
        self.navigationItem.titleView = titleView
    }
    
    @objc func openFavorites() {
        openEventsViewController(isLiked: true)
    }
    
    func openEventsViewController(isLiked: Bool) {
        let eventsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventsListViewController") as! EventsListViewController
        eventsListViewController.showLiked = isLiked
        self.navigationController?.pushViewController(eventsListViewController, animated: true)
    }
}

extension MainViewController: UINavigationControllerDelegate {
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
