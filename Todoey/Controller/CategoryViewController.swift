//
//  CategoryViewController.swift
//  Todoey
//
//  Created by buket aymak on 9.11.2018.
//  Copyright © 2018 buket aymak. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      loadCategory()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItemCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }
    
        
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
            
        }
        catch { print("error saving context \(error)")}
        
      tableView.reloadData()
    }
    
    func loadCategory(){
       let request: NSFetchRequest<Category> = Category.fetchRequest()
       
        
        
        do{
            categories = try context.fetch(request)
        }
        
        catch {
            print("error reading data\(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Categories
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
    self.saveCategories()
            
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
            destinationVC.selectedCategory = categories[indexPath.row]
            
        }
        
    }
    
    
}
