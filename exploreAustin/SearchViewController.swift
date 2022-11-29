//
//  SearchViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/28/22.
//

import UIKit

var austinLocatins = ["Zilker","Mount Bonnell","Lake Austin","Bufords","Parlor and Yard","Triangle Park","Peas Park"]

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    let searchController = UISearchController()
    
    var searchId:String!
    var searchName:String!
    
    var tstData = ["austin","houston","huntington beach","dallas","dubai","amersterdam","nuuk"]
    var userEmails = [String]()
    var photos = [UIImage]()
    
    var dupTstData = [String]()
    
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
        self.dupTstData = self.tstData
    }

}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dupTstData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.searchId == "users"{
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.id, for: indexPath) as! FriendsTableViewCell
            let row = indexPath.row
            
            cell.usernameLabel.text = self.tstData[row]
            cell.friendProfImageView.image = self.photos[row]
            
            return cell
        }else{
            let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell",for: indexPath)
            let row = indexPath.row
            
            cell.textLabel?.text = self.dupTstData[row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.searchId == "users"{
            let cell = tableView.cellForRow(at: indexPath) as! FriendsTableViewCell
            let pageVC = storyboard?.instantiateViewController(withIdentifier: "pageVC") as! PageViewController
            let userIdx = self.tstData.firstIndex(of: cell.usernameLabel.text!)!
            let userEmail = self.userEmails[userIdx]
            pageVC.userPage = userEmail
            pageVC.othProfPhoto = self.photos[userIdx]
            pageVC.isModalInPresentation = true
            pageVC.modalPresentationStyle = .fullScreen
            self.present(pageVC, animated: true)
        }else{
            let cell = tableView.cellForRow(at: indexPath)!
            let labelContent = cell.textLabel?.text
            locFromSearch = labelContent ?? ""
            navigationController?.popViewController(animated: true)
        }
        
    }
}

extension SearchViewController:UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchtext \(searchText)")
        var filteredData = self.tstData
        
            if searchText.isEmpty == false {
                filteredData = tstData.filter{ $0.lowercased().hasPrefix(searchText.lowercased()) }
                self.dupTstData = filteredData
            }else{
                self.dupTstData = self.tstData
            }
        
        self.searchTableView.reloadData()
    }
}
