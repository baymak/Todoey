//
//  ViewController.swift
//  Todoey
//
//  Created by buket aymak on 4.11.2018.
//  Copyright © 2018 buket aymak. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
    
    super.viewDidLoad()
        
        
        
        print(dataFilePath!)
        
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
        
        loadItems()
        
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
       
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
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
    
            
            let newItem  = Item()
            newItem.title = textField.text!
            
            
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
    
    //MARK - Model Manunpulation Methods
   
    func saveItems() {
    let encoder = PropertyListEncoder()
    
    do {
    let data = try encoder.encode(self.itemArray)
    try data.write(to: self.dataFilePath!)
    }
    catch{
    print("error encoding item array, \(error)")
    }
    }
    
    func loadItems() {
        
      if  let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do { itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("error detecting \(error)")
            }
        }
        
    
    
}
        
   
}

        
        



