//
//  DayTableViewController.swift
//  Weekly Events
//
//  Created by James Tran on 6/10/16.
//  Copyright © 2016 James Tran. All rights reserved.
//

import Foundation
import UIKit

class DayTableViewController: UITableViewController {
    var events = [String]()
    var dayNumber = -1
    var daysOfWeek = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var defaults = NSUserDefaults.standardUserDefaults()
    var eventsStored = [NSObject : AnyObject]()
    
    override func viewWillAppear(animated: Bool) {
        events = []
        if defaults.dictionaryForKey(daysOfWeek[dayNumber]) != nil {
            eventsStored = defaults.dictionaryForKey(daysOfWeek[dayNumber])!
            for (key, _) in eventsStored {
                events.append(key as! String)
            }
        }
        self.tableView.reloadData()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            eventsStored.removeValueForKey(events[indexPath.row] as NSObject)
            events.removeAtIndex(indexPath.row)
            defaults.setObject(eventsStored, forKey: daysOfWeek[dayNumber])
            
            let sections = NSIndexSet(index: 0)
            tableView.reloadSections(sections, withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Basic")!
        cell.textLabel?.text = events[indexPath.row]
        let remainingTime = NSTimeInterval(defaults.doubleForKey(events[indexPath.row] + "RemainingTime" + daysOfWeek[dayNumber]))
        if remainingTime == 0 {
            cell.contentView.alpha = 0.2
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "eventSegue"){
            let selectedRow = tableView.indexPathForSelectedRow?.row
            
            if let dest = segue.destinationViewController as? EventViewController{
                dest.title = events[selectedRow!]
                dest.eventName = events[selectedRow!]
                let key = events[selectedRow!] as NSObject
                let time : NSTimeInterval = 3600 * Double(eventsStored[key] as! NSNumber)
                dest.remainingTime = time
                if self.title == "TODAY" {
                    dest.isItToday = true
                } else {
                    dest.isItToday = false
                }
                dest.dayNumber = dayNumber
            }
        }
        
        if (segue.identifier == "addSegue"){
            //let selectedRow = tableView.indexPathForSelectedRow?.row
            
            if let dest = segue.destinationViewController as? AddEventViewController{
                dest.title = "Add"
            }
        }
    }
}