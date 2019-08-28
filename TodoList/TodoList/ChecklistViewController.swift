//
//  ViewController.swift
//  TodoList
//
//  Created by Mercia Maguerroski on 23/08/19.
//  Copyright © 2019 Mércia. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    var todoList: TodoList
    var tableData: [[ChecklistItem?]?]!
    
    @IBAction func additem(_ sender: Any) {
        let newRowIndex = todoList.todos.count
        _ = todoList.newTodo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            var items = [ChecklistItem]()
            for indexPath in selectedRows {
                items.append(todoList.todos[indexPath.row])
            }
            
            todoList.remove(items: items)
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        todoList = TodoList()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
        let sectionTitleCount = UILocalizedIndexedCollation.current().sectionTitles.count
        var allSections = [[ChecklistItem?]?](repeating: nil, count: sectionTitleCount)
        var sectionNumber = 0
        let collation = UILocalizedIndexedCollation.current()
        for item in todoList.todos {
            sectionNumber = collation.section(for: item, collationStringSelector: #selector(getter:ChecklistItem.text))
            if allSections[sectionNumber] == nil {
                allSections[sectionNumber] = [ChecklistItem?]()
            }
            allSections[sectionNumber]!.append(item)
        }
        tableData = allSections
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }

    //this method says how many rolls to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section] == nil ? 0 : tableData[section]!.count
    }
    
    //this method is called everytime a table view needs a cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        //let item = todoList.todos[indexPath.row]
        if let item = tableData[indexPath.section]?[indexPath.row] {
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath){
            let item = todoList.todos[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todoList.todos.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        todoList.move(item: todoList.todos[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        if let checkmarkCell = cell as? ChecklistTableViewCell {
            checkmarkCell.todoTextLabel.text = item.text
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        guard let checkmark = cell as? ChecklistTableViewCell else{
            return
        }
        if item.checked {
            checkmark.checkmarkLabel.text = "√"
        }else{
            checkmark.checkmarkLabel.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue"{
            if let addItemViewController = segue.destination as? AddItemTableViewController{
                addItemViewController.delegate = self
                addItemViewController.todoList = todoList
            }
        }else if segue.identifier == "EditItemSegue"{
            if let addItemViewController = segue.destination as? AddItemTableViewController{
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    
                    let item = todoList.todos[indexPath.row]
                    addItemViewController.itemToEdit = item
                    addItemViewController.delegate = self
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.current().sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return UILocalizedIndexedCollation.current().sectionTitles[section]
    }
}

// MARK: - UIPickerViewDelegate

extension ChecklistViewController: AddItemViewControllerDelegate {
    func addItemViewControllerDidCancel(_ controller: AddItemTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = todoList.todos.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishEditing item: ChecklistItem) {
        if let index = todoList.todos.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}

