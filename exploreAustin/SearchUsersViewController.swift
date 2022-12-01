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
    var checkedUsers = [Dictionary<String,Any>]()
    var searchData = [String]()
    var dupSearchData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        
        searchTableView.register(FriendsTableViewCell.nib(), forCellReuseIdentifier: FriendsTableViewCell.id)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchTitle.text = searchName
        
        for i in data {
            self.searchData.append(i["username"] as! String)
        }
        self.dupSearchData = self.searchData
        print("data \(self.dupSearchData)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.searchId == "friends"{
            friendsInvited = self.checkedUsers
        }
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
        let userEmail = self.data[idx]["email"] as! String

        
        
        if self.searchId == "users"{
            let pageVC = storyboard?.instantiateViewController(withIdentifier: "othUserPage") as! OthUserPageViewController
            
            pageVC.pageFor = userEmail
            
            self.present(pageVC, animated: true)
        }else if self.searchId == "friends"{
            if cell.checkImageView.image == UIImage(systemName: "checkmark"){
                cell.checkImageView.image = nil
                let idxRemove = self.checkedUsers.firstIndex { i in
                    i["email"] as! String == userEmail
                }
                self.checkedUsers.remove(at: idxRemove!)
                
            }else{
                cell.checkImageView.image = UIImage(systemName: "checkmark")
                var temp = Dictionary<String,Any>()
                temp["username"] = username
                temp["email"] = userEmail
    
                self.checkedUsers.append(temp)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
