//
//  ViewController.swift
//  Project7
//
//  Created by Thiago Alves on 7/17/19.
//  Copyright © 2019 Thiago Alves. All rights reserved.
//

// swiftlint:disable identifier_name

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var filterButtonTitle = "Filter"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: filterButtonTitle, style: .plain, target: self,
                                                            action: #selector(filterPetitions))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self,
                                                           action: #selector(showCredits))

        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }

    @objc func fetchJSON() {
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            // urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            // urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }

        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Enter filter", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let clearAction = UIAlertAction(title: "Clear", style: .default) { [weak self] _ in
            self?.submit()
        }

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        ac.addAction(clearAction)
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(_ filter: String = String()) {
        if filter.isEmpty {
            filteredPetitions = petitions
            navigationItem.leftBarButtonItem?.title = filterButtonTitle
            tableView.reloadData()
        } else {
            DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
                let lowerFilter = filter.lowercased()

                self.filteredPetitions = self.petitions.filter { petition in
                    return petition.title.lowercased().contains(lowerFilter)
                        || petition.body.lowercased().contains(lowerFilter)
                }

                DispatchQueue.main.async { [unowned self] in
                    self.navigationItem.leftBarButtonItem?.title = self.filterButtonTitle + ": " + filter
                    self.tableView.reloadData()
                }
            }
        }
    }

    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits",
                                   message: "Data provided by the We The People API of the Whitehouse.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @objc func showError() {
        let ac = UIAlertController(
                 title: "Loading error",
                 message: "There was a problem loading the feed; please check your connection and try again.",
                 preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}
