//
//  TweetService.swift
//  PutMeOn!
//
//  Created by Zach mills on 11/12/20.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "reposts": 0,
                      "caption": caption] as [String : Any]
        
        let ref = REF_TWEETS.childByAutoId()
        
        ref.updateChildValues(values) { (err, ref) in
            guard let postID = ref.key else { return }
            REF_USER_TWEETS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
        }
    }
    
    func fetchPosts(completion: @escaping([Post]) -> Void) {
    var posts = [Post]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let postID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let post = Post(user: user, postID: postID, dictionary: dictionary)
                posts.append(post)
                completion(posts)
            }
            

            
        }
    }
    
    func fetchPosts(forUser user: User, completion: @escaping([Post]) -> Void) {
       var posts = [Post]()
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let postID = snapshot.key
            
            REF_TWEETS.child(postID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let post = Post(user: user, postID: postID, dictionary: dictionary)
                    posts.append(post)
                    completion(posts)
            }
        }
    }
    
}
}
