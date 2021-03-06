//
//  AddItemTableViewController.swift
//  TodoList
//
//  Created by Mercia Maguerroski on 23/08/19.
//  Copyright © 2019 Mércia. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    
    func addItemViewControllerDidCancel(_ controller: AddItemTableViewController)
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem)
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishEditing: ChecklistItem)
}

class AddItemTableViewController: UITableViewController {
    
    // // MARK: Properties
    
    weak var delegate: AddItemViewControllerDelegate?
    weak var todoList:TodoList?
    weak var itemToEdit: ChecklistItem?

    // MARK: - IBOutlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit, let text = textField.text {
            item.text = text
            delegate?.addItemViewController(self, didFinishEditing: item)
        }else{
            if let item = todoList?.newTodo(){
                if let textFieldText = textField.text {
                    item.text = textFieldText
                }
                item.checked = false
                delegate?.addItemViewController(self, didFinishAdding: item)
            }
        }
        
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            addBarButton.isEnabled = true
        }

        navigationItem.largeTitleDisplayMode = .never
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

}

// MARK: - UIPickerViewDelegate

extension AddItemTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText) else{
                return false
        }
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty{
            addBarButton.isEnabled = false
        }else{
            addBarButton.isEnabled = true
        }
        
        return true
    }
}
