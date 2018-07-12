//
//  ViewController.swift
//  daneDemoPrototypeCell
//
//  Created by Jaewon Lee on 7/11/18.
//  Copyright © 2018 Jaewon Lee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var tableData: [ToDo] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addItemSegue", sender: self)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindFromAddToDo (segue: UIStoryboardSegue){
        let src = segue.source as! OtherVC
        let title = src.titleTextField.text
        let notes = src.notesTextView.text
        let date = src.dateView.date
        
        let newTodo = ToDo(context: context)
        
        newTodo.title = title
        newTodo.notes = notes
        newTodo.date = date
        
        appDelegate.saveContext()
        tableData.append(newTodo)
        tableView.reloadData()
        
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                
            }
            else{
                cell.accessoryType = .checkmark
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        
        fetchAllReviews()
    }
    
    func fetchAllReviews(){
        let todo:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        do {
            tableData = try context.fetch(todo)
            
        } catch {
            print(error)
        }

    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItem", for: indexPath) as! listItem
        let todo = tableData[indexPath.row]
        cell.titleLabel?.text = todo.title
        cell.dateLabel?.text = "\(todo.date!)"
        cell.notesView?.text = todo.notes
        
        return cell
    }
}

