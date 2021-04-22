//
//  ViewController.swift
//  Todoey
//
//  Created by Yarden Katz on 19/04/2021.


import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    //MARK: - Tableview Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let safeItems = todoItems, !safeItems.isEmpty {
            return safeItems.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        var text = ""
        if let safeItems = todoItems, !safeItems.isEmpty {
            let item = safeItems[indexPath.row]
            text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            cell.textLabel?.textColor = .black
            cell.isUserInteractionEnabled = true
        } else {
            text = "No Items Added Yet"
            cell.textLabel?.textColor = .lightGray
            cell.isUserInteractionEnabled = false
        }
        cell.textLabel?.text = text
        
        return cell
    }
    
    //MARK: - Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("error saving done status, \(error)")
            }
        }

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            guard let text = textField.text, text != "" else { return }
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = text
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }

            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            alertTextField.autocapitalizationType = .words
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Code
    
    fileprivate func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
}
    
//MARK: - SearchBar methods

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if 0 == searchBar.text?.count {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
