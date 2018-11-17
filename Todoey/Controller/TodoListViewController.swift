//
//  ViewController.swift
//  Todoey
//
//  Created by buket aymak on 4.11.2018.
//  Copyright © 2018 buket aymak. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
         loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
    
    super.viewDidLoad()
        
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
        
//   let newItem = Item()
//
//      newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//
//        newItem2.title = "Buy eggs"
//        itemArray.append(newItem2)
//        
//        let newItem3 = Item()
//
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
       
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]  {
//            itemArray = items
//
//        }
    }

    //MARK - Tableview Datasource Methods
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //ternary operator
        // value = condition ? valueiftrue : valueiffalse
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        
//        if itemArray[indexPath.row].done == true {
//        cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        return cell
        
    }
    
    // MARK - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     //   print(itemArray[indexPath.row])
       
//         update data
//          itemArray[indexPath.row].setValue("complete", forKey: "title")
        
        
        // delete data
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
     
        
        
        
        // check data
    //    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
//        if itemArray[indexPath.row].done == true {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//        
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
        
        
       
     //   if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//             tableView.cellForRow(at: indexPath)?.accessoryType = .none
//
//        }
//
//        else {
//             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
    }
    
    //MARK - Add New Items
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks the Add item button on our UIAlert
    
           
            
            let newItem  = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
           self.itemArray.append(newItem)
            self.saveItems()
            
     //       self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
      //     self.tableView.reloadData() (saveItems() includes this method)
            
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
   
    func saveItems() {
   
    do {
    
      try   context.save()
    }
    catch{
    print("error saving context, \(error)")
    }
        self.tableView.reloadData()
        
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
  //      let request: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
            
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do {
        itemArray = try context.fetch(request)
            
        }

        catch {
            print("error reading data\(error)")
        }
        
        tableView.reloadData()
        
}
    
   
}

// MARK - SearchBar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
 
        
       
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with:request, predicate: predicate)
        
        
        
//        do {
//            itemArray = try context.fetch(request)
//
//        }
//
//        catch {
//            print("error fetching data from context\(error)")
//        }
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




