//
//  EventViewController.swift
//  Weekly Events
//
//  Created by James Tran on 6/10/16.
//  Copyright © 2016 James Tran. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class EventViewController: UIViewController {
    var eventName: String = "Default Name"
    var start = false
    var startTime = NSTimeInterval()
    var remainingTime = NSTimeInterval()
    var initialization = true
    var defaults = NSUserDefaults.standardUserDefaults()
    var isItToday = true
    var dayNumber = -1
    var daysOfWeek = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet var timeLabel: UILabel!
    
    /*override func viewWillAppear(animated: Bool) {
        remainingTime = NSTimeInterval(defaults.integerForKey(eventName + "RemainingTime"))
    }*/

    override func viewDidLoad() {
        /*var didEventSwitch = false
        if !didEventSwitch {
            switch eventName {
            case "Piano":
                remainingTime = 5 * 3600
            case "Studying Swift":
                remainingTime = 3 * 3600
            default:
                remainingTime = 1 * 3600
            }*/
        remainingTime = NSTimeInterval(defaults.doubleForKey(eventName + "RemainingTime" + daysOfWeek[dayNumber]))
        showTime(remainingTime)
            //didEventSwitch = true
        //}
    
    
        //eventName
        //remainingTime*/
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        defaults.setDouble(remainingTime, forKey: eventName + "RemainingTime" + daysOfWeek[dayNumber])
    }
    
    func showTime(var elapsedTime: NSTimeInterval){
        
        let hours = UInt8(elapsedTime / 3600.0)
        
        elapsedTime -= (NSTimeInterval(hours) * 3600)
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
            
        let seconds = UInt8(elapsedTime)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strHours = String(format: "%02d", hours)
        
        timeLabel.text = "\(strHours):\(strMinutes):\(strSeconds)"


    }
    
    func playSound(soundName: String)
    {
        let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "mp3")!)
        do{
            let audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }catch {
            print("Error getting the audio file")
        }
    }

    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        elapsedTime = remainingTime - elapsedTime
        remainingTime = elapsedTime
        
        if remainingTime <= 0 {
            remainingTime = 0
            timer.invalidate()
            start = false
            let state = UIControlState(rawValue: 0)
            startButton.setTitle("Start", forState: state)
            defaults.setDouble(remainingTime, forKey: eventName + "RemainingTime")
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title: "", message: "Congratulations, you have successfully completed this event!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            return
        }
        
        showTime(elapsedTime)
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }

    
    var timer = NSTimer()
    @IBAction func startButton(sender: AnyObject) {
        if (!isItToday){
            playSound("FFSound")
            let alertController = UIAlertController(title: "", message: "You cannot do events for days other than today!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            if (!start) {
                startTime = NSDate.timeIntervalSinceReferenceDate()
                timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(EventViewController.updateTime), userInfo: nil, repeats: true)
                
                let state = UIControlState(rawValue: 0)
                startButton.setTitle("Stop", forState: state)
                start = true
            } else {
                timer.invalidate()
                start = false
                let state = UIControlState(rawValue: 0)
                startButton.setTitle("Start", forState: state)
                defaults.setDouble(remainingTime, forKey: eventName + "RemainingTime" + daysOfWeek[dayNumber])
            }
        }
    }
    
    
}