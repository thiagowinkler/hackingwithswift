//
//  ViewController.swift
//  Project4
//
//  Created by Thiago Alves on 7/10/19.
//  Copyright © 2019 Thiago Alves. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var websites = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Website Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        websites += ["apple.com", "hackingwithswift.com"]
        
        print(websites)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.websites = websites
            vc.selectedWebsite = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

