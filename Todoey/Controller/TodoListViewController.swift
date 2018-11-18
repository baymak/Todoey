//
//  ViewController.swift
//  Todoey
//
//  Created by buket aymak on 4.11.2018.
//  Copyright © 2018 buket aymak. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
  
    var selectedCategory : Category? {
        didSet{
         loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
   

    override func viewDidLoad() {
    
    super.viewDidLoad()
        
       
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    searchBar.delegate = self
        
    }

    //MARK - Tableview Datasource Methods
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
       
            cell.textLabel?.text = item.title

            cell.accessoryType = item.done ?  .checkmark : .none
            
            
        }
        
        else {
            cell.textLabel?.text = "no item added"
        }
        
        return cell
        
    }
    
    // MARK - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            
            do {
            try realm.write {
    // MARK - delete item
    //        realm.delete(item)
                
 
                item.done = !item.done
            }
            }
            catch {
                print("error saving done status \(error)")
                
            }
 
            }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
      
    }
    
    //MARK - Add New Items
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
          
            //what will happen when user clicks the Add item button on our UIAlert
    
           
        if let currentCategory = self.selectedCategory {
            do{
            try self.realm.write {
                let newItem  = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                
                currentCategory.items.append(newItem)
                }
                
                } catch {
                    print("error saving new items \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
   

    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

}

}

// MARK - SearchBar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
                
            }
            
        }

}

    }




