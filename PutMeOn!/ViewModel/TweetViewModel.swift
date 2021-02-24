//
//  TweetViewModel.swift
//  PutMeOn!
//
//  Created by Zach mills on 11/12/20.
//

import UIKit


struct TweetViewModel {
    
    let post: Post
    let user: User
    
    var profileImageURL: URL? {
        return user.profileImageURL
    }
    
    
    var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        
        return formatter.string(from: post.timestamp, to: now) ?? "time unknown"
    }
    
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname,
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " ‣ \(timeStamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        
        return title
    }
    
    init (post: Post) {
    self.post = post
        self.user = post.user
    }
}
