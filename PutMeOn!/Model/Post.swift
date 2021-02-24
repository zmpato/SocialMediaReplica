//
//  Post.swift
//  PutMeOn!
//
//  Created by Zach mills on 11/12/20.
//

import Foundation


struct Post {
    let caption: String
    let postID: String
    let uid: String
    let likes: Int
    var timestamp: Date!
    let repostCount: Int
    let user: User
    
    
    init(user: User, postID: String, dictionary: [String: Any]) {
        self.postID = postID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.repostCount = dictionary["repostCount"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
