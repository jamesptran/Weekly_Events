//
//  WeekTableViewController.swift
//  Weekly Events
//
//  Created by James Tran on 6/10/16.
//  Copyright © 2016 James Tran. All rights reserved.
//

import Foundation
import UIKit

class WeekTableViewController: UITableViewController {
    var daysOfWeek = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    
    func getDayOfWeek()->Int? {
        let todayDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Weekday, fromDate: todayDate)
        let day = components.weekday
        return day
    }
    
    override func viewWillAppear(animated: Bool) {
        daysOfWeek[getDayOfWeek()! - 1] = "TODAY"
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Basic")!
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DaySegue"){
            let selectedRow = tableView.indexPathForSelectedRow?.row
            
            if let dest = segue.destinationViewController as? DayTableViewController{
                dest.title = daysOfWeek[selectedRow!]
                dest.dayNumber = selectedRow!
                
            }
        }
    }
}