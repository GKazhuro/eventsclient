//
//  LikedProvider.swift
//  vkapp
//
//  Created by George Kazhuro on 21.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import Foundation

class LikedEventsProvider {
    
    fileprivate var _events = [Event]()
    
    var events: [Event] {
        return _events
    }
    
    init() {
        self._events = self.getLiked()
    }
    
    fileprivate func getLiked() -> [Event] {
        let defaults = UserDefaults.standard
        var events = [Event]()
        if let data = defaults.object(forKey: "events") as? Data {
            events = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Event]
        }
        return events
    }
    
    func checkIfFollowed(eventInfo: Event) -> Bool {
        return _events.contains( where: { $0.creationId == eventInfo.creationId })
    }
    
    func unfollowEvent(eventInfo: Event) {
        if let index = _events.index(where: { $0.creationId == eventInfo.creationId }) {
            _events.remove(at: index)
            updateEventsDefaults()
        }
    }
    
    func followEvent(eventInfo: Event) {
        _events.append(eventInfo)
        updateEventsDefaults()
    }
    
    fileprivate func updateEventsDefaults() {
        let defaults = UserDefaults.standard
        let eventsData = NSKeyedArchiver.archivedData(withRootObject: _events)
        defaults.set(eventsData, forKey: "events")
        defaults.synchronize()
    }
}
