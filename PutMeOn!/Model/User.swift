//
//  User.swift
//  PutMeOn!
//
//  Created by Zach mills on 11/10/20.
//

import UIKit
import Firebase

struct User {
    let fullname: String
    let username: String
    let email: String
    var profileImageURL: URL?
    let uid: String
    var isFollowed = false
    var stats: UserRelationStats?
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid}


init(uid: String, dictionary: [String: AnyObject]) {
    self.uid = uid
    
    self.fullname = dictionary["fullname"] as? String ?? ""
    self.username = dictionary["username"] as? String ?? ""
    self.email = dictionary["email"] as? String ?? ""
    
    if let profileImageURLString = dictionary["profileImageURL"] as? String {
        guard let url = URL(string: profileImageURLString) else { return }
        self.profileImageURL = url
    }
}
}

struct UserRelationStats {
    var following: Int
    var followers: Int
}
