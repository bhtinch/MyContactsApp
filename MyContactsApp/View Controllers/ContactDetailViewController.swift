//
//  ContactDetailViewController.swift
//  MyContactsApp
//
//  Created by Benjamin Tincher on 2/5/21.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    //  MARK: OUTLETS
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //  MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //  MARK: PROPERTIES
    var contact: Contact?
    
    //  MARK: ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if let contact = contact {
            updateContact(contact: contact)
        } else {
            saveNewContact()
        }
    }
    
    //  MARK: METHODS
    func updateViews() {
        
        guard let contact = contact else { return }
        
        nameTextField.text = contact.name
        numberTextField.text = contact.phoneNumber
        emailTextField.text = contact.emailAddress
    }
    
    func saveNewContact() {
        
        guard let name = nameTextField.text, !name.isEmpty else { return }
        
        ContactController.shared.createContactWith(name: name, phoneNumber: numberTextField.text, emailAddress: emailTextField.text) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateContact(contact: Contact) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        
        contact.name = name
        contact.phoneNumber = numberTextField.text
        contact.emailAddress = emailTextField.text
        
        ContactController.shared.update(contact: contact) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}   //  End of Class
