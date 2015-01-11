//
//  CompaniesTableController.swift
//  EnjoyPnD
//
//  Created by Brian Vallelunga on 1/10/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class CompaniesTableController: UITableViewController {
    
    // MARK: Instance Variables
    private var user: User = User.current()
    private var companies: [Company] = []
    private var cellIdentifier = "cell"
    
    // MARK: UIViewController Overrides
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure Navigation Bar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.18, green:0.59, blue:0.87, alpha:1)
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        // Add Refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: Selector("reloadCompanies"), forControlEvents: UIControlEvents.ValueChanged)
        
        // Self Loading Title
        self.title = "Loading..."
        
        // Get Shared Posts
        self.reloadCompanies()
    }
    
    // MARK: IBActions
    @IBAction func goToMap(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("mapSegue", sender: self)
    }
    
    // MARK: Instance Methods
    func reloadCompanies() {
        self.user.getCompanies { (companies) -> Void in
            if !companies.isEmpty {
                self.title = "Companies"
            } else {
                self.title = "No Companies Found"
            }
            
            self.companies = companies
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    // UITableViewController Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companies.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var company = self.companies[indexPath.row]
        var cell: UITableViewCell! = self.tableView.cellForRowAtIndexPath(indexPath)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(cell.accessoryType == UITableViewCellAccessoryType.None) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            company.addWorker(self.user)
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
            company.removeWorker(self.user)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var company = self.companies[indexPath.row]
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: self.cellIdentifier)
            cell.textLabel?.textColor = UIColor.darkGrayColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(20)
            cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(16)
            cell.detailTextLabel?.numberOfLines = 3
            
            if(self.user.selectedCompanies.containsObject(company.parse.objectId)) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        cell.textLabel?.text = company.name
        cell.detailTextLabel?.text = company.description
        
        return cell
    }
}
