//
//  Event.swift
//  vkapp
//
//  Created by George Kazhuro on 21.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import Foundation
import SwiftyJSON

enum EventSaveStatus {
    case added
    case deleted
}

class Event: NSObject, NSCoding {
    let creationId: String
    fileprivate let beginStr: String
    fileprivate let endStr: String
    let name: String
    let eventDescription: String
    let editorialComment: String
    let synopsis: String
    let imageUrl: String
    
    var timeFormattedString: String {
        var finalString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateStart = dateFormatter.date(from: beginStr)
        let dateEnd = dateFormatter.date(from: endStr)
        dateFormatter.dateFormat = "HH:mm"
        if let dateStart = dateStart {
            let dateStartFormattedString = dateFormatter.string(from: dateStart)
            finalString.append(dateStartFormattedString)
        }
        if let dateEnd = dateEnd, dateStart != dateEnd {
            let dateEndFormattedString = dateFormatter.string(from: dateEnd)
            finalString.append("- \(dateEndFormattedString)")
        }
        return finalString
    }
    
    var dateFormattedString: String {
        var finalString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateStart = dateFormatter.date(from: beginStr)
        let dateEnd = dateFormatter.date(from: endStr)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        if let dateStart = dateStart {
            let dateStartFormattedString = dateFormatter.string(from: dateStart)
            finalString.append(dateStartFormattedString)
        }
        if let dateEnd = dateEnd, dateStart != dateEnd {
            let dateEndFormattedString = dateFormatter.string(from: dateEnd)
            finalString.append("- \(dateEndFormattedString)")
        }
        return finalString
    }
    
    fileprivate var _saved = false
    
    var saved: Bool {
        return _saved
    }
    
    var eventType: String {
        if creationId.contains("Movie") {
            return "Фильм"
        } else if creationId.contains("Concert") {
            return "Концерт"
        } else {
            return "Событие"
        }
    }
    
    func updateSaveStatus(_ likedEventsProvider: LikedEventsProvider) -> EventSaveStatus {
        if likedEventsProvider.checkIfFollowed(eventInfo: self) {
            //likedEventsProvider.unfollowEvent(eventInfo: self)
            return .deleted
        } else {
            self._saved = true
            likedEventsProvider.followEvent(eventInfo: self)
            return .added
        }
    }
    
    init(json: JSON) {
        self.creationId = json["creation_id"].stringValue
        self.eventDescription = json["description"].stringValue
        self.beginStr = json["begin"].stringValue
        self.endStr = json["end"].stringValue
        self.name = json["name"].stringValue
        self.synopsis = json["synopsis"].stringValue
        self.editorialComment = json["editorial_comment"].stringValue
        self.imageUrl = json["image_url"].stringValue
    }
    
    required init(coder decoder: NSCoder) {
        self.creationId = decoder.decodeObject(forKey: "creationId") as? String ?? ""
        self.eventDescription = decoder.decodeObject(forKey: "eventDescription") as? String ?? ""
        self.beginStr = decoder.decodeObject(forKey: "beginStr") as? String ?? ""
        self.endStr = decoder.decodeObject(forKey: "endStr") as? String ?? ""
        self.editorialComment = decoder.decodeObject(forKey: "editorialComment") as? String ?? ""
        self.synopsis = decoder.decodeObject(forKey: "synopsis") as? String ?? ""
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.imageUrl = decoder.decodeObject(forKey: "imageUrl") as? String ?? ""
        self._saved = decoder.decodeBool(forKey: "saved")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(creationId, forKey: "creationId")
        coder.encode(eventDescription, forKey: "eventDescription")
        coder.encode(beginStr, forKey: "beginStr")
        coder.encode(endStr, forKey: "endStr")
        coder.encode(editorialComment, forKey: "editorialComment")
        coder.encode(synopsis, forKey: "synopsis")
        coder.encode(name, forKey: "name")
        coder.encode(imageUrl, forKey: "imageUrl")
        coder.encode(_saved, forKey: "saved")
    }
}
