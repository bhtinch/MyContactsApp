//
//  ContactListTableViewController.swift
//  MyContactsApp
//
//  Created by Benjamin Tincher on 2/5/21.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ContactController.shared.fetchAllContacts { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let contact = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let contact = ContactController.shared.contacts[indexPath.row]
            ContactController.shared.delete(contact: contact, index: indexPath.row) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response)
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? ContactDetailViewController else { return }
            destination.contact = ContactController.shared.contacts[indexPath.row]
        }
    }
}   //  End of Class
