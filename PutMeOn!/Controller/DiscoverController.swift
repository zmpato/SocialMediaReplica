//
//  DiscoverController.swift
//  PutMeOn!
//
//  Created by Zach mills on 10/13/20.
//

import UIKit

private let reuseIdentifier = "UserCell"

class DiscoverController: UITableViewController {
    
    //    MARK: - Properties
    
    private var users = [User]()
    {
        didSet { tableView.reloadData() }
    }
    
    private var filteredUsers = [User]() {
        didSet { tableView.reloadData() }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive &&
            !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    //    MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

            configureUI()
            fetchUsers()
            configureSearchController()
            
            
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
    }
        
    
    //    MARK: - API
    
    func fetchUsers() {
        UserService.shared.fetchUsers { users in
            self.users = users
            
        }
    }
    
    
    //    MARK: - Helper Functions

    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Discover"

        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorInset = .zero
//        tableView.separatorStyle = .none
//        ^^if u dont want the lines separating the cells, uncomment above line.

    }

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search here"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
}

// MARK: - UICollectionViewDelegate/DataSource

extension DiscoverController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}



extension DiscoverController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredUsers = users.filter({ $0.username.contains(searchText) || $0.fullname.contains(searchText)})
    }
    
    
}
