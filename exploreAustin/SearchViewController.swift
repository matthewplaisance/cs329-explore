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
    
    private lazy var zzldfData: Array = {
        return [
            ["infokey": ["Over the years, people have come to this 1,000 foot long natural limestone pool, fed by several underground springs, for everything from fishing and swimming to baptisms and beauty pageants.","Beautiful park looming almost 800 feet over Austin.","Austin's original and iconic hotel features beautiful Romanesque architecture from the late 1800's. With a grand entrance into the opulent lobby, you will be transported to an historic era, with its marble floors, stained-glass dome, and corridors filled with museum-quality artwork. Head up the grand staircase to the most authentic Texas bar in downtown Austin, with daily live music and happy hour.","The Austin bridge is where nearly 1.5 million bats live.","The Lady Bird Johnson Wildflower Center in Austin, Texas, is dedicated to inspiring the conservation of native plants. Located a quick but quiet ten miles from downtown, we are a botanical garden open to the public year-round and have become a favored venue for everything from conservation-focused conventions to beautiful weddings. We carry out our mission to inspire the conservation and application of native plants through our gardens, campus, research, education and outreach programs. In doing so, we improve water quality, provide habitat for wildlife and enhance human health and happiness. Visit, learn and make a better world with us. The Wildflower Center was founded by Lady Bird Johnson and Helen Hayes in 1982 and became a part of The University of Texas at Austin in 2006","Street lined with lots of great restaurants.","The Lyndon Baines Johnson Library and Museum, also known as the LBJ Presidential Library, is the presidential library and museum of Lyndon Baines Johnson, the 36th President of the United States. It is one of fourteen presidential libraries administered by the National Archives and Records Administration (NARA) and located on the campus of The University of Texas at Austin. We are open daily (except for Thanksgiving, Christmas, and New Year's Day) from 9 a.m.-5 p.m., with the last admission at 4:00 p.m. Admission is $3-$13 per person, with free admission given to children 12 and under, active military, student groups, and UT Austin students, faculty, and staff with valid ID. Free parking is available in visitor lot #38. Learn more at lbjlibrary.org.","The Bullock Texas State History Museum is the state's official history museum and features three floors of exhibition galleries, IMAX® Theatre, Texas Spirit Theater, Story of Texas Cafe, and Bullock Museum Store.","If it's in Texas, it must be bigger and better. That is the motto that architects followed with the Capitol Building in Austin. At one time, it was the tallest capitol building in the nation. Others might be taller now, but this is still a beautiful building that shows off many of the natural resources which are so prevalent in Texas, such as limestone and the landscapes.","Scenic trail through lush green parks and peaceful lakes: a great place to bike, hike and run."],"timezone":"America/New_York  ","cityImg":["picture1","picture2","picture3","picture4","picture5","picture6","picture7","picture8","picture9","picture10"],"theme":["Barton Springs Pool","Mount Bonnell","The Driskill","Congress Avenue Bridge Bat Watching","Lady Bird Johnson Wildflower Center","South Congress Avenue","LBJ Presidential Library","Photos of Bullock Texas State History Museum","Photos of Texas State Capitol","Photos of Lady Bird Lake Hike-and-Bike Trail"]]
                ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchBar.delegate = self
        
        self.searchOne.setTitle("Austin", for: .normal)
        self.searchTwo.setTitle("Music", for: .normal)
        self.searchThree.setTitle("New Years", for: .normal)
        self.searchFour.setTitle("Christmas", for: .normal)
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
    
    @IBAction func searchVCToPicVC(_ sender: Any) {
let picscenceVC = picscenceVC()
//        self.navigationController?.pushViewController(List, animated: true)
let dicsdffgt: [String: Any] = zzldfData[0]
picscenceVC.infozklgdic = dicsdffgt
picscenceVC.cityImgData = (dicsdffgt["cityImg"] as! [String])
picscenceVC.dscTxtData = (dicsdffgt["infokey"] as! [String])
picscenceVC.themeTxtData = (dicsdffgt["theme"] as! [String])

self.present(picscenceVC, animated:true, completion:nil)
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
