//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yarden Katz on 21/04/2021.

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let app = UINavigationBarAppearance()
        guard let kNavBarColor = UIColor(hexString: "#9CE0FF") else { return }
        app.backgroundColor = kNavBarColor
        navigationController?.navigationBar.scrollEdgeAppearance = app
        navigationController?.navigationBar.tintColor = ContrastColorOf(kNavBarColor, returnFlat: true)
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let safeCateogries = categories, !safeCateogries.isEmpty {
//            return safeCateogries.count
//        }
//        return1
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        var text = ""
        if let safeCategories = categories, !safeCategories.isEmpty {
            let category = safeCategories[indexPath.row]
            text = category.name
            cell.isUserInteractionEnabled = true
            
            guard let categoryColor = UIColor(hexString: category.hexColor) else {
                fatalError("No color found")
            }
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            cell.backgroundColor = categoryColor
        } else {
            text = "No Categories Added Yet"
            cell.textLabel?.textColor = .lightGray
            cell.isUserInteractionEnabled = false
        }
        cell.textLabel?.text = text
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    fileprivate func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories, \(error)")
        }
        
        tableView.reloadData()
    }
    
    fileprivate func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            guard let text = textField.text, text != "" else { return }
            
            let newCategory = Category()
            newCategory.name = text
            newCategory.hexColor = UIColor.randomFlat().hexValue()
            self.tableView.reloadData()
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            alertTextField.autocapitalizationType = .words
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
