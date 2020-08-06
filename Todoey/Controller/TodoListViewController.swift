//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{

    var items : Results<Item>?
    var farzi_items : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            LoadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
             cell.textLabel?.text = "No Item is added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            do{
                try realm.write{
//                    realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error in upadting \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func addbutton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        var NewItem = UITextField()
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItemToAdd = Item()
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        newItemToAdd.title = NewItem.text!
                        newItemToAdd.dateCreated = Date()
                        currentCategory.items.append(newItemToAdd)
                }
                }catch{
                    print("Error in saving item \(error)")
                }
                
            }
           
            self.tableView.reloadData()
        }

        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            NewItem = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
//    func SaveItems(){
//        do {
////            try self.context.save()
//        }catch{
//            print(error)
//        }
//        tableView.reloadData()
//    }

    func LoadData(){
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

extension TodoListViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        items = items?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count == 0{
            
            LoadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }

    }
}
