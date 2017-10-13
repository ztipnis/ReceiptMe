//
//  TableViewDelegate.swift
//  TableTest
//
//  Created by Zachary Tipnis on 7/20/16.
//  Copyright © 2016 Zachal LLC. All rights reserved.
//

import Foundation
import UIKit
import StringScore_Swift
import CoreData

class tableDelegate: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate
{
    private var shouldDisplaySearchResults = false
    private var filteredArray = [Reciept]()
    private lazy var tableData = [Reciept]()
    private lazy var selected:Reciept = Reciept()
    var searchController: UISearchController!

    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
        
    }
    
    
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        if(shouldDisplaySearchResults){
            return filteredArray.count
        }
        return tableData.count
    }
    
    func filterReciepts(data: [Reciept], filterText: String) -> [Reciept]?{
        var out:[Reciept] = []
        for n in data {
            print(n.text?.score(filterText,fuzziness: 1.0))
            if (n.text?.score(filterText,fuzziness: 1.0) >= 0.1){
                out.append(n)
            }
            print(out)
            //return out
        }
        return out
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableData = {
            
            
            var people = [Reciept]()
            let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            //2
            let fetchRequest = NSFetchRequest(entityName: "Reciept")
            
            //3
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                people = results as! [Reciept]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            //implement data selection here
            return people
            
        }()
        tableView.reloadData()
        navigationController?.toolbarHidden = false
    }
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if(cell == nil){
            let newcell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            cell = newcell
        }else{
            let newcell = cell!
            cell = newcell
        }
        cell?.separatorInset = UIEdgeInsetsZero
        var reciept:Reciept
        if shouldDisplaySearchResults{
            reciept = filteredArray[indexPath.row]
        }else{
            reciept = tableData[indexPath.row]
        }
        //print(reciept.title)
        cell?.textLabel?.text = reciept.title
        return cell!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !shouldDisplaySearchResults
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appdelegaten = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appdelegaten.managedObjectContext
        moc.deleteObject(tableData[indexPath.row] as NSManagedObject)
        tableData.removeAtIndex(indexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        if(shouldDisplaySearchResults){
            selected = filteredArray[indexPath.row] as Reciept
        }else{
            selected = tableData[indexPath.row]
        }
        
        performSegueWithIdentifier("CellClick", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem();
        //self.tableView.style = UITableViewStyle.Plain
        configureSearchController()
        self.tableView.separatorStyle = .SingleLine
        self.tableView.separatorColor = UIColor.blackColor()
        
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldDisplaySearchResults = true
        self.tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldDisplaySearchResults = false
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldDisplaySearchResults {
            shouldDisplaySearchResults = true
            self.tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = filterReciepts(tableData, filterText: searchString!)!
        print(filteredArray)
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if(segue.destinationViewController.isKindOfClass(ScanViewController)){
            let receiver = segue.destinationViewController as! ScanViewController
            receiver.RVC = self
        }
        if (segue.destinationViewController.isKindOfClass(DetailViewController)){
            
            let reciever = segue.destinationViewController as! DetailViewController
            reciever.selected.getUnmanagedFor(self.selected)
            reciever.hidesBottomBarWhenPushed = true
        }
    }
    
    
    
}