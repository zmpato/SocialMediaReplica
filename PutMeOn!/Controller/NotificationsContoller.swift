//
//  NotificationsContoller.swift
//  PutMeOn!
//
//  Created by Zach mills on 10/13/20.
//

import UIKit

class NotificationsController: UIViewController {
    
    //    MARK: - Properties
        
    //    MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

            configureUI()
            
            
        }
        
    //    MARK: - Helper Functions


    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"


    }

}

