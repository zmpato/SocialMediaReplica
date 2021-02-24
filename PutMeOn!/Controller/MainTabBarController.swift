//
//  MainTabBarController.swift
//  PutMeOn!
//
//  Created by Zach mills on 10/13/20.
//

import UIKit
import Firebase


class MainTabBarController: UITabBarController {
    
    
//    MARK: - Properties
    
    
    
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .amColor
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
//    MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = .amColor
        self.tabBar.isTranslucent = false
        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.tintColor = .white
        

//        Log User Out
        view.backgroundColor = .amColor
//        logUserOut()
        authenticateUserAndConfigureUI()
        
        
    }
    
    
//    MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) {
            user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LogInController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
                
            }
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
        
    }
    func logUserOut() {
        do {
            try Auth.auth().signOut()
            print("DEBUG: Did log user out")
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    
//    MARK: - Selectors
    
    @objc func actionButtonTapped() {
        guard let user = user else { return }
        let controller = UploadTweetController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        // nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    
//    MARK: - Helper Functions
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    
    func configureViewControllers() {
        
//        Use templateNavigatonController function to assign View Controllers to tabs, assign icons to tabs, and store in navigation controllers
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "feed_unselected"), rootViewController: feed)
        let discover = DiscoverController()
        let nav2 = templateNavigationController(image: UIImage(named: "discover_unselected"), rootViewController: discover)
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        let conversations = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "message_unselected"), rootViewController: conversations)
        
        viewControllers = [nav1, nav2, nav3, nav4]
        
    }
//    Function storing the views into navigation controllers and creating nav bars
    
    func templateNavigationController(image: UIImage? , rootViewController: UIViewController) ->
    UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        
//        nav.navigationBar.tintColor = .white
        nav.navigationBar.barTintColor = .amColor
        nav.navigationBar.backgroundColor = .amColor
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        nav.navigationBar.isTranslucent = false
        return nav
    }
    

   

}
