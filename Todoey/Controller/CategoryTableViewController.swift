//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Yash  on 28/07/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    var Categories : Results<Category>?
     let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = Categories?[indexPath.row].name ?? "No Categories added yet"
        return cell
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        var NewCategory = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let NewCat = Category()
            NewCat.name = NewCategory.text!
            self.Save(category: NewCat)
        }
        alert.addAction(action)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add new Category"
            NewCategory = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = Categories?[indexPath.row]
        }
    }
    func Save(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error in saving in context \(error)")
        }
        tableView.reloadData()
    }
    
    func LoadData(){
        Categories = realm.objects(Category.self)
     
        tableView.reloadData()
    }
    
}
