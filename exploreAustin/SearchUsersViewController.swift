//
//  SearchViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/28/22.
//

import UIKit

var austinLocatins = ["Zilker","Mount Bonnell","Lake Austin","Bufords","Parlor and Yard","Triangle Park","Peas Park"]

class SearchUsersViewController: UIViewController {

    @IBOutlet weak var searchTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    let searchController = UISearchController()
    
    var searchId:String!
    var searchName:String!
    
    //var tstData = ["austin","houston","huntington beach","dallas","dubai","amersterdam","nuuk"]
    var data = [Dictionary<String,Any>]()
    var searchData = [String]()
    var dupSearchData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        
        if self.searchId == "users"{
            searchTableView.register(FriendsTableViewCell.nib(), forCellReuseIdentifier: FriendsTableViewCell.id)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchTitle.text = searchName
        for i in data {
            self.searchData.append(i["username"] as! String)
        }
        self.dupSearchData = self.searchData
    }
    

}

extension SearchUsersViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dupSearchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.id, for: indexPath) as! FriendsTableViewCell
        let row = indexPath.row
        
        let username = self.dupSearchData[row]
        let idx = searchData.firstIndex(of: username)!
        
        cell.usernameLabel.text = username
        cell.friendProfImageView.image = self.data[idx]["profilePhoto"] as? UIImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
        print("row: \(indexPath.row)")
        let username = cell.usernameLabel.text!
        let idx = self.searchData.firstIndex(of: username)!
        let userEmail = self.data[idx]["email"]
        
        let pageVC = storyboard?.instantiateViewController(withIdentifier: "othUserPage") as! OthUserPageViewController
        
        pageVC.pageFor = userEmail as? String
        self.present(pageVC, animated: true)
        
    }
}

extension SearchUsersViewController:UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var filteredData = self.searchData
            if searchText.isEmpty == false {
                filteredData = searchData.filter{ term in
                    return term.lowercased().contains(searchText.lowercased())
                }
                self.dupSearchData = filteredData
            }else{
                self.dupSearchData = self.searchData
            }
        
        self.searchTableView.reloadData()
    }
}
