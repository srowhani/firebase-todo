//
//  TodoTableViewController.swift
//  firebase-todo
//
//  Created by admin on 2018-05-05.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TaskTableViewController: UITableViewController {
    var todos: [TaskItem]? = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! LoginViewController;
            self.present(loginViewController, animated: true, completion: nil)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(performLogout))
        
    }
    
    @IBAction func performLogout () {
        try! Auth.auth().signOut()
        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
        
          self.present(loginVc, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos != nil ? todos!.count : 0
    }

}
