//
//  EventDescriptionViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 12/1/22.
//

import UIKit
import CoreData

class EventDescriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    var data = NSManagedObject()
    var attendees = [Substring]()
    var memsCount:Int!
    var section = [Int]()
    
    @IBOutlet weak var halfView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.halfView.addSubview(tableView
        )
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let mems = self.data.value(forKey: "participantsNames") as! Substring
        self.attendees = mems.split(separator: "//")
        self.memsCount = self.attendees.count
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.halfView.bounds
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.numberOfLines=0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            cell.textLabel?.text = ""
        }
        if section == 1 {
            cell.textLabel?.text = "\(self.attendees[0])"//owner's name , substring! so \()
        }else if section == 2{
            cell.textLabel?.text = "\(self.attendees[row])"
        }else if section == 3 {
            cell.textLabel?.text = self.data.value(forKey: "descript") as? String
        }else if section == 4 {
            cell.textLabel?.text = self.data.value(forKey: "location") as? String
        } else {
            cell.textLabel?.text = self.data.value(forKey: "date") as? String
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            
            return self.memsCount - 1//less owner
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Host"
        }else if section == 2 {
            return "members"
        }else {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        print(section)
        if section == 0 {
            
            return 0
        }else if section == 1 || section == 2 {
            return 10
        }else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {//index path restarts for each section
        if indexPath.section == 0 {
            return 0
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

}
