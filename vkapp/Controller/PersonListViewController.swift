//
//  PersonViewController.swift
//  vkapp
//
//  Created by George Kazhuro on 21.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import UIKit
import Koloda
import VK_ios_sdk
import SwiftyJSON
import Kingfisher
import Moya

class PersonListViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var event: Event!
    var provider: MoyaProvider<VKAppService>!
    var matchesIds = [1]
    var usersArr = [User]()
    var matchesArr = [User]()
    var allUsersArr = [User]()
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var emptyCardView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var matchesHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = event.name
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if matchesIds.count == 0 {
            matchesHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
        loadData()
    }
    
    func loadData() {
        provider = MoyaProvider<VKAppService>()
        let userId = VKSdk.accessToken().userId!
        matchesArr = []
        allUsersArr = []
        usersArr = []
        provider.request(.getSubscribers(event: event.creationId, user: Int(userId)!, filter: true)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                let personIds = json["users"].arrayValue.map({$0.intValue})
                let allUsersIds = personIds + self.matchesIds
                let personIdsStr = (allUsersIds as NSArray).componentsJoined(by: ",")
                let getUsersRequest = VKApi.users().get(["user_ids": personIdsStr, "fields":"photo_max_orig, sex, bdate"])
                getUsersRequest?.execute(resultBlock: { (response) in
                    let usersJson = JSON(response?.json as Any)
                    self.allUsersArr = usersJson.arrayValue.map({User(json: $0)})
                    DispatchQueue.main.async {
                        for user in self.allUsersArr {
                            if self.matchesIds.contains(user.id) {
                                self.matchesArr.append(user)
                            } else if personIds.contains(user.id) && "\(user.id)" != VKSdk.accessToken().userId {
                                self.usersArr.append(user)
                            }
                        }
                        self.kolodaView.reloadData()
                        self.collectionView.reloadData()
                    }
                    print(self.allUsersArr.count)
                }, errorBlock: nil)
            case .failure(_): break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let emptyCardViewSubview = Bundle.main.loadNibNamed("EmptyCardView", owner: self, options: nil)![0] as! EmptyCardView
        emptyCardViewSubview.delegate = self
        emptyCardViewSubview.frame = self.view.bounds
        emptyCardView.addSubview(emptyCardViewSubview)
    }
    
    @IBAction func likeBtnPressed(sender: UIButton) {
        kolodaView.swipe(.right)
    }
    
    @IBAction func dislikeBtnPressed(sender: UIButton) {
        kolodaView.swipe(.left)
    }
}

extension PersonListViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        emptyCardView.isHidden = false
        mainView.isHidden = true
        usersArr = []
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("selected card")
    }
}

extension PersonListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let match = matchesArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCollectionViewCell", for: indexPath) as! MatchCollectionViewCell
        cell.matchImageView.kf.setImage(with: match.photoUrl)
        cell.matchLabel.text = match.firstName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchesArr.count
    }
}

extension PersonListViewController: KolodaViewDataSource {
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .left, .bottomLeft, .topLeft:
            like(false, index: index)
        case .right, .topRight, .bottomRight:
            like(true, index: index)
        default: break
        }
    }
    
    func like(_ likeVal: Bool, index: Int) {
        let subject = usersArr[index]
        let userId = VKSdk.accessToken().userId!
        provider.request(.like(user: Int(userId)!, subject: subject.id, event: event.creationId, like: likeVal), completion: { (result) in
            switch result {
            case let .success(moyaResponse):
                let matchCreated = JSON(moyaResponse.data)["match_created"].boolValue
                print(matchCreated)
                if matchCreated == true {
                    self.matchesArr.append(subject)
                    self.matchesHeightConstraint.constant = 80
                    self.collectionView.reloadData()
                    self.view.layoutIfNeeded()
                }
            case .failure(_): break
            }
        })
    }
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        if usersArr.count > 0 {
            emptyCardView.isHidden = true
            mainView.isHidden = false
        } else {
            emptyCardView.isHidden = false
            mainView.isHidden = true
        }
        return usersArr.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let user = usersArr[index]
        let cardView = Bundle.main.loadNibNamed("CardView", owner: self, options: nil)![0] as! CardView
        cardView.frame = koloda.bounds
        cardView.imageView.kf.setImage(with: user.photoUrl)
        cardView.infoLabel.text = user.userInfo
        return cardView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)![0] as? OverlayView
    }
}

extension PersonListViewController: EmptyDelegate {
    func updateBtnPressed() {
        kolodaView.resetCurrentCardIndex()
        loadData()
    }
}
