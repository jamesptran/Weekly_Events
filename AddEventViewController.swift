//
//  AddEventViewController.swift
//  Weekly Events
//
//  Created by James Tran on 6/28/16.
//  Copyright © 2016 James Tran. All rights reserved.
//

import Foundation
import UIKit

class AddEventViewController: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var titleOfEvents : String = ""
    var numberOfHours : Double = 0
    
    @IBOutlet weak var Stepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    @IBOutlet weak var textFieldTitle: UITextField!
    
    @IBOutlet weak var sunSwitch: UISwitch!
    @IBOutlet weak var monSwitch: UISwitch!
    @IBOutlet weak var tueSwitch: UISwitch!
    @IBOutlet weak var wedSwitch: UISwitch!
    @IBOutlet weak var thuSwitch: UISwitch!
    @IBOutlet weak var friSwitch: UISwitch!
    @IBOutlet weak var satSwitch: UISwitch!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    @IBAction func stepperButtonPressed(sender: UIStepper) {
        var nameHours: String = " hours"
        if Int(sender.value) == 0 || Int(sender.value) == 1 {
            nameHours = " hour"
        }
        stepperLabel.text = (Double(sender.value * 0.5).description) + nameHours
        numberOfHours = Double(sender.value * 0.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Stepper.wraps = true
        Stepper.autorepeat = true
        Stepper.maximumValue = 48;
        //textFieldTitle.delegate = self
        
    }
    
    
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        titleOfEvents = textFieldTitle.text!
        if titleOfEvents == "" {
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title: "", message: "Event name cannot be empty!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            return
        }
        
        if numberOfHours == 0 {
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title: "", message: "Time taken cannot be zero!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            return
        }
        
        var daysOfWeek : [String] = []
        
        if sunSwitch.on == true {
            daysOfWeek.append("Sunday")
        }
        if monSwitch.on == true {
            daysOfWeek.append("Monday")
        }
        if tueSwitch.on == true {
            daysOfWeek.append("Tuesday")
        }
        if wedSwitch.on == true {
            daysOfWeek.append("Wednesday")
        }
        if thuSwitch.on == true {
            daysOfWeek.append("Thursday")
        }
        if friSwitch.on == true {
            daysOfWeek.append("Friday")
        }
        if satSwitch.on == true {
            daysOfWeek.append("Saturday")
        }
        
        if daysOfWeek == [] {
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title: "", message: "No day selected!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            return
        }
        
        
        var addedDict = [NSObject: AnyObject]()
        
        for days in daysOfWeek {
            if defaults.dictionaryForKey(days) != nil {
                addedDict = defaults.dictionaryForKey(days)!
                addedDict[titleOfEvents] = numberOfHours
                defaults.setObject(addedDict, forKey: days)
                defaults.setDouble(Double(numberOfHours * 3600), forKey: titleOfEvents + "RemainingTime" + days)
            } else {
                addedDict[titleOfEvents] = numberOfHours
                defaults.setObject(addedDict, forKey: days)
                defaults.setDouble(Double(numberOfHours * 3600), forKey: titleOfEvents + "RemainingTime" + days)
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
}