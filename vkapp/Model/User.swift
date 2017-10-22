//
//  User.swift
//  vkapp
//
//  Created by George Kazhuro on 21.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class User {
    
    enum Gender {
        case male
        case female
    }
    
    let id: Int
    let firstName: String?
    let lastName: String?
    let photo: String?
    var photoUrl: URL? {
        guard let photo = photo else { return nil }
        return URL(string: photo)
    }
    var age: Int? {
        return 18
    }
    var fullName: String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }
    let genderString: String?
    let bdate: String?
    var gender: Gender {
        return .male
    }
    
    var userInfo: String {
        var finalString = fullName
        if let age = age {
            finalString.append(", \(age)")
        }
        return finalString
    }
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.genderString = json["sex"].stringValue
        self.bdate = json["bdate"].string
        self.photo = json["photo_max_orig"].string
    }
    
}
