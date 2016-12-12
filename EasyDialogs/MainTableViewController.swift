//
//  MainTableViewController.swift
//  EasyDialogs
//
//  Created by Junior B. on 12.12.16.
//  Copyright © 2016 Bonto.ch. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Simple Dialog"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EasyDialog.Builder(self)
            .title(title: "Hello World") // tag -> 1
            .textField(placeholder: "Username") // tag -> 2
            .textField(placeholder: "Password", secure: true) // tag -> 3
            .addButton(title: "Ok") { dialog in
                
                let tfUsername = dialog.view.viewWithTag(2) as! UITextField
                let tfPassword = dialog.view.viewWithTag(3) as! UITextField
                
                print("\(tfUsername.text ?? "") \(tfPassword.text ?? "")" )
                
                dialog.dismiss(animated: true)
            }
            .addButton(title: "Cancel") { dialog in
                dialog.dismiss(animated: true)
            }
            .build()
            .show()
    }

}
