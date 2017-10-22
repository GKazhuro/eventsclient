//
//  ViewController.swift
//  vkapp
//
//  Created by George Kazhuro on 21.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import UIKit
import Kingfisher
import Moya
import SwiftyJSON
import VK_ios_sdk

class EventsListViewController: MainViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let EdgeInsetVal: CGFloat = 8
    var refresher:UIRefreshControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var downloadFinished: Bool = false
    var events = [Event]()
    var matchesJson: JSON!
    var showLiked = false
    var likedEventsProvider: LikedEventsProvider!
    var provider: MoyaProvider<VKAppService>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if showLiked == false {
            self.refresher = UIRefreshControl()
            self.refresher.layer.zPosition = -1
            self.collectionView.alwaysBounceVertical = true
        
            self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
            self.collectionView.addSubview(refresher)
        }
        
        likedEventsProvider = LikedEventsProvider()
        
        provider = MoyaProvider<VKAppService>()
    }
    
    @objc func loadData() {
        provider = MoyaProvider<VKAppService>()
        let userId = VKSdk.accessToken().userId!
        provider.request(.getEvents(limit: 10, type: "concert", userId: Int(userId)!)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let eventsJSON = JSON(data: data)
                self.events = eventsJSON.arrayValue.map( { Event(json: $0) } )
                self.provider.request(.getMatches(user: Int(userId)!)) { result in
                    switch result {
                    case let .success(moyaResponse):
                        self.matchesJson = JSON(moyaResponse.data)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.refresher.endRefreshing()
                        }
                    case .failure(_): break
                    }
                }
            case .failure(_): break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if showLiked {
            events = likedEventsProvider.events
            collectionView.reloadData()
        } else if events.count == 0 {
            loadData()
        }
    }
}

extension EventsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - EdgeInsetVal * 2, height: 205)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: EdgeInsetVal, bottom: 12, right: EdgeInsetVal)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

extension EventsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
        cell.eventTitleLabel.text = event.name
        cell.eventDescriptionLabel.text = event.eventDescription
        cell.eventTypeLabel.text = event.eventType
        cell.dateLabel.text = event.dateFormattedString
        cell.eventDescriptionLabel.text = event.timeFormattedString
        cell.delegate = self
        let mainImageUrl = URL(string: event.imageUrl)
        cell.mainImageView.kf.setImage(with: mainImageUrl, placeholder: #imageLiteral(resourceName: "oxxxymiron"))
        likedEventsProvider.checkIfFollowed(eventInfo: event) ? cell.likeButton.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal) : cell.likeButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = events[indexPath.item]
        let personListViewController = self.storyboard?.instantiateViewController(withIdentifier: "PersonListViewController") as! PersonListViewController
        personListViewController.event = event
        
        let result = event.updateSaveStatus(likedEventsProvider)
        if result == .deleted && showLiked {
            events.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        } else {
            provider.request(.subscribe(user: VKSdk.accessToken().userId, event: event.creationId)) { result in
                switch result {
                case let .success(moyaResponse):
                    let data = moyaResponse.data
                    DispatchQueue.main.async {
                        personListViewController.matchesIds = self.matchesJson[event.creationId].arrayValue.map({$0.intValue})
                        self.navigationController?.pushViewController(personListViewController, animated: true)
                    }
                case .failure(_): break
                }
            }
        }
    }
}

extension EventsListViewController: EventCollectionViewCellDelegate {
    
    func eventLikeBtnPressed (at cell: EventCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let event = events[indexPath.item]
            let result = event.updateSaveStatus(likedEventsProvider)
            if result == .deleted && showLiked {
                events.remove(at: indexPath.item)
                collectionView.deleteItems(at: [indexPath])
            } else {
                provider.request(.subscribe(user: VKSdk.accessToken().userId, event: event.creationId)) { result in
                    switch result {
                    case let .success(moyaResponse):
                        let data = moyaResponse.data
                        DispatchQueue.main.async {
                            self.collectionView.reloadItems(at: [indexPath])
                        }
                    case .failure(_): break
                    }
                 }
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
}

