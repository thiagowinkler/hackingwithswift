//
//  ViewController.swift
//  Milestone2
//
//  Created by Thiago Alves on 7/16/19.
//  Copyright © 2019 Thiago Alves. All rights reserved.
//

// swiftlint:disable identifier_name

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self,
                                                            action: #selector(shareTapped))

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let clear = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForItem))

        toolbarItems = [clear, spacer, add]
        navigationController?.isToolbarHidden = false

        clearList()
    }

    @objc func clearList() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItem", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Shopping item deleted")

            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    @objc func shareTapped() {
        if shoppingList.isEmpty {
            print("Shopping list empty")
            return
        }

        let list = shoppingList.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    @objc func promptForItem() {
        let ac = UIAlertController(title: "Enter item", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(_ item: String) {
        if item.isEmpty { return }

        let lowerItem = item.lowercased()

        if isOriginal(item: lowerItem) {
            let position = shoppingList.count
            shoppingList.insert(item, at: position)

            let indexPath = IndexPath(row: position, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)

            return
        } else {
            showErrorMessage("Be more original!", withTitle: "Item already on the list")
        }
    }

    func isOriginal(item: String) -> Bool {
        return !shoppingList.contains(item)
    }

    func showErrorMessage(_ message: String, withTitle title: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}
