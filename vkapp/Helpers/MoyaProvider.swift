//
//  MoyaProvider.swift
//  vkapp
//
//  Created by George Kazhuro on 21.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import Foundation
import Moya

enum VKAppService {
    case getEvents(limit: Int, type: String, userId: Int)
    case subscribe(user: String, event: String)
    case like(user: Int, subject: Int, event: String, like: Bool)
    case getSubscribers(event: String, user: Int, filter: Bool)
    case getMatches(user: Int)
}

extension VKAppService: TargetType {
    var baseURL: URL { return URL(string: "https://rvaleev.ru:8000")! }
    var path: String {
        switch self {
        case .getEvents:
            return "/get_events"
        case .subscribe:
            return "/matching/subscribe"
        case .getSubscribers:
            return "/matching/get_subscribers"
        case .like:
            return "/matching/like"
        case .getMatches:
            return "/matching/get_matches"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getEvents, .getSubscribers, .getMatches:
            return .get
        case .subscribe, .like:
            return .post
        }
    }
    var task: Task {
        switch self {
        case .getEvents(let limit, let type, let userId):
            return .requestParameters(parameters: ["limit": limit, "type": type, "user_id": userId], encoding: URLEncoding.queryString)
        case .getSubscribers(let event, let user, let filter):
            return .requestParameters(parameters: ["event_id": event, "user_id": user, "filter": "\(filter)"], encoding: URLEncoding.queryString)
        case .subscribe(let user, let event):
            let userId = Int(user)
            return .requestParameters(parameters: ["user_id": userId, "event_id": event], encoding: URLEncoding.default)
        case .like(let user, let subject, let event, let like):
            return .requestParameters(parameters: ["user_id": user, "subject_id": subject, "event_id": event, "like": "\(like)"], encoding: URLEncoding.default)
        case .getMatches(let user):
            return .requestParameters(parameters: ["user_id": user], encoding: URLEncoding.queryString)
        }
    }
    var sampleData: Data {
        switch self {
        case .getEvents, .subscribe, .getSubscribers, .like, .getMatches:
            return "get events".utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/x-www-form-urlencoded; charset=UTF-8"]
    }
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
