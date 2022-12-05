//
//  SearchViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 12/3/22.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchToolBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchOne: UIButton!
    @IBOutlet weak var searchTwo: UIButton!
    @IBOutlet weak var searchThree: UIButton!
    @IBOutlet weak var searchFour: UIButton!
    @IBOutlet weak var searchFive: UIButton!
    
    var data = [Dictionary<String,Any>]()
    var dupData = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchBar.delegate = self
        
        self.searchOne.setTitle("Austin", for: .normal)
        self.searchTwo.setTitle("Music", for: .normal)
        self.searchThree.setTitle("fc", for: .normal)
        self.searchFour.setTitle("football", for: .normal)
        self.searchFive.setTitle("Lake", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.data = currPosts
        self.dupData = self.data
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = UICollectionViewFlowLayout()
        let containerWidth = self.collectionView.bounds.width
        let cellWidth = (containerWidth-18) / 3
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        self.collectionView.collectionViewLayout = layout
    }
    func searchTerm(searchTerm:String) {
        var filteredData = self.data
        
        filteredData = data.filter{ term in
            let tags = (term["tags"] as! String).lowercased().contains(searchTerm.lowercased())
            let poster = (term["username"] as! String).lowercased().contains(searchTerm.lowercased())
            return tags || poster
        }
        self.dupData = filteredData
        self.collectionView.reloadData()
    }



    @IBAction func btnOneHit(_ sender: Any) {
        let title = self.searchOne.titleLabel?.text
        self.searchBar.text = title
        self.searchTerm(searchTerm: (title!))
        
    }
    
    @IBAction func btnTwoHit(_ sender: Any) {
        let title = self.searchTwo.titleLabel?.text
        self.searchBar.text = title
        self.searchTerm(searchTerm: (title!))
    }
    
    
    @IBAction func btnThreeHit(_ sender: Any) {
        let title = self.searchThree.titleLabel?.text
        self.searchBar.text = title
        self.searchTerm(searchTerm: (title!))
    }
    
    
    @IBAction func btnFourHit(_ sender: Any) {
        let title = self.searchFour.titleLabel?.text
        self.searchBar.text = title
        self.searchTerm(searchTerm: (title!))
    }
    
    @IBAction func btnFiveHit(_ sender: Any) {
        let title = self.searchFive.titleLabel?.text
        self.searchBar.text = title
        self.searchTerm(searchTerm: (title!))
    }
    
    @IBAction func feedBtnHit(_ sender: Any) {
        let feedVC = storyBoard.instantiateViewController(withIdentifier: "feedVC") as! FeedViewController
        
        feedVC.isModalInPresentation = true
        feedVC.modalPresentationStyle = .fullScreen
        self.present(feedVC, animated:true, completion:nil)
    }
    
    @IBAction func eventBtnHit(_ sender: Any) {
        let eventsVC = storyBoard.instantiateViewController(withIdentifier: "eventsNavController") as! UINavigationController
        eventsVC.isModalInPresentation = true
        eventsVC.modalPresentationStyle = .fullScreen
        self.present(eventsVC, animated:true, completion:nil)
        
    }
    
    @IBAction func pageBtnHit(_ sender: Any) {
        let pageVC = storyBoard.instantiateViewController(withIdentifier: "pageVC") as! PageViewController
        pageVC.isModalInPresentation = true
        pageVC.modalPresentationStyle = .fullScreen
        self.present(pageVC, animated:true, completion:nil)
    }
    
}

extension SearchViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        var filteredData = self.data
            if searchText.isEmpty == false {
                filteredData = data.filter{ term in
                    let tags = (term["tags"] as! String).lowercased().contains(searchText.lowercased())
                    let poster = (term["username"] as! String).lowercased().contains(searchText.lowercased())
                    return tags || poster
                }
                self.dupData = filteredData
            }else{
                self.dupData = self.data
            }
        
        self.collectionView.reloadData()
    }
}

extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dupData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCollectCell", for: indexPath) as! PagePhotoCell//new reuseable cell for table
        cell.searchImageView.image = (self.dupData[indexPath.row]["content"] as! UIImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let feedVC = storyBoard.instantiateViewController(withIdentifier: "feedVC") as! FeedViewController
        
        feedVC.data = self.dupData
        feedVC.userPage = self.dupData[0]["email"] as! String
        feedVC.scrollTo = row
        self.present(feedVC, animated:true, completion:nil)
    }
    

}
