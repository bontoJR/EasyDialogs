//
//  MainTableViewController.swift
//  EasyDialogs
//
//  Created by Junior B. on 12.12.16.
//  Copyright © 2016 Bonto.ch. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    let customTheme = EasyDialog.Theme(
        textColor: colorFromDecimalRGB(229, green: 231, blue: 218),
        titleColor: colorFromDecimalRGB(229, green: 231, blue: 218),
        alertBackgroudColor: colorFromDecimalRGB(38, green: 39, blue: 41),
        cornerRadius: 2.0,
        regularButtonBackgroundColor: colorFromDecimalRGB(38, green: 39, blue: 41),
        regularButtonSelectedBackgroundColor: UIColor.darkGray,
        regularButtonTextColor: colorFromDecimalRGB(229, green: 231, blue: 218))
    
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
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Classic"
        case 1:
            cell.textLabel?.text = "Simple Dialog"
        case 2:
            cell.textLabel?.text = "Username and Password"
        case 3:
            cell.textLabel?.text = "Rating"
        case 4:
            cell.textLabel?.text = "Custom Theme"
        default:
            cell.textLabel?.text = "Unknown"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "Default AlertController", message: "A standard alert", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Cancel button");
            }
            alertController.addAction(cancelAction)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("you have pressed OK button");
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:nil)
        } else if indexPath.row == 1 {
            EasyDialog.Builder(self)
                .title(title: "Hello World") // tag -> 1
                .text(content: "This is a basic dialog")
                .addButton(title: "Ok") { dialog in
                    dialog.dismiss(animated: true)
                }
                .build()
                .show()
        } else if indexPath.row == 2 {
            EasyDialog.Builder(self)
                .title(title: "User and Pass") // tag -> 1
                .textField(placeholder: "Username") // tag -> 2
                .textField(placeholder: "Password", secure: true) // tag -> 3
                .positiveButton(title: "Login") { dialog in
                    
                    let tfUsername = dialog.view.viewWithTag(2) as! UITextField
                    let tfPassword = dialog.view.viewWithTag(3) as! UITextField
                    
                    print("\(tfUsername.text ?? "") \(tfPassword.text ?? "")" )
                    
                    dialog.dismiss(animated: true)
                }
                .destructiveButton(title: "Cancel")
                .build()
                .show()
        } else if indexPath.row == 3 {
            EasyDialog.Builder(self)
                .title(title: "Rating") // tag -> 1
                .label(text: "If you like this app, please consider rate us.", textAlignment: .center)
                .positiveButton(title: "Yes") { dialog in
                    
                    print("process now")
                    
                    dialog.dismiss(animated: true)
                }
                .addButton(title: "Remind me later") { dialog in
                    
                    print("remind later")
                    
                    dialog.dismiss(animated: true)
                }
                .destructiveButton(title: "Not now")
                .build()
                .show()
        } else if indexPath.row == 4 {
            EasyDialog.Builder(self, theme: customTheme)
                .title(title: "Hello World") // tag -> 1
                .text(content: "This is a basic dialog")
                .addButton(title: "Ok") { dialog in
                    dialog.dismiss(animated: true)
                }
                .build()
                .show()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

fileprivate func colorFromDecimalRGB(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(
        red: red / 255.0,
        green: green / 255.0,
        blue: blue / 255.0,
        alpha: alpha
    )
}
