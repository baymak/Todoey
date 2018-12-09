//
//  CategoryViewController.swift
//  Todoey
//
//  Created by buket aymak on 9.11.2018.
//  Copyright © 2018 buket aymak. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    var transferCategoryColor : String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()

      loadCategory()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatSkyBlue()]
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        
        
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6")
       
        cell.textLabel?.textColor = ContrastColorOf((cell.backgroundColor)!, returnFlat: true)
       
        return cell
        
    }
    
    
        
    //MARK: - Data Manipulation Methods
    
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
                
            }
            
            
        }
        catch { print("error saving context \(error)")}
        
      tableView.reloadData()
    }
    
    func loadCategory(){

            categories = realm.objects(Category.self)
       
            tableView.reloadData()
    }
    
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
//        super .updateModel(at: indexPath)
        
                    if let CategoryForDeletion = self.categories?[indexPath.row] {
        
       
        
                        do {
                            try self.realm.write {
                                self.realm.delete(CategoryForDeletion)
                            }
        
        
                        }
                        catch { print("error saving context \(error)")}
        
                    }
    }
    
    //MARK: - Add New Categories
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
      
            
            self.save(category: newCategory)
            
            
            
        }
        
         alert.addAction(action)
        alert.addTextField { (field) in
            
            
            textField = field
            
          textField.placeholder = "Create new category"
        }
        
       
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if   let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories? [indexPath.row]
            
        }
        
    }
    

    
}

