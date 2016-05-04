//
//  StateTaxRateViewController.swift
//  tip_helper
//
//  Created by Di on 1/28/16.
//  Copyright © 2016 Di. All rights reserved.
//

import UIKit
import CoreData

class StateTaxRateViewController: UITableViewController {
    
    @IBOutlet weak var selectedRate: UIBarButtonItem!
    
    //var states = [NSManagedObject]()
    var states = [StateTaxRate]()
    var rr: String?
    var lastCheckCell: StateRateCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updateStateTaxRateFromJSON()
        selectedRate.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        
//        let fetchRequest2 = NSFetchRequest(entityName: "States")
//        
//        do{
//            let results = try managedContext.executeFetchRequest(fetchRequest2)
//            states = results as! [NSManagedObject]
//        }catch let error as NSError{
//            print("Could not save \(error), \(error.userInfo)")
//        }
        
        
//        let predicate = NSPredicate(format: "name == %@", "NY")
//        
//        let fetchRequest = NSFetchRequest(entityName: "States")
//        fetchRequest.predicate = predicate
//        
//        do {
//            let fetchedEntities = try managedContext.executeFetchRequest(fetchRequest)
//            if let entityToDelete = fetchedEntities.first {
//                managedContext.deleteObject(entityToDelete as! NSManagedObject)
//            }
//        } catch {
//            // Do something in response to error condition
//        }
//        
//        do {
//            try managedContext.save()
//        } catch {
//            // Do something in response to error condition
//        }
        
    }
    
    func saveStateRate(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("States", inManagedObjectContext: manageContext)
        let state = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: manageContext)
        
        state.setValue("NY", forKey: "name")
        state.setValue("8.875", forKey: "rate")
        
        do{
            try manageContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StateRateCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StateRateCell
        let state = states[indexPath.row]
 
        
//        cell.stateName.text = state.valueForKey("name") as? String
//        let rat = state.valueForKey("rate") as? String
        cell.stateName.text = state.name
        let rat = state.rate
        cell.stateRate.text = rat! + "%"
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if lastCheckCell === tableView.cellForRowAtIndexPath(indexPath){
            //print("last the same")
            if lastCheckCell?.accessoryType == UITableViewCellAccessoryType.None{
                lastCheckCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                //print("none to check")
            }else if lastCheckCell?.accessoryType == UITableViewCellAccessoryType.Checkmark{
                lastCheckCell?.accessoryType = UITableViewCellAccessoryType.None
                //print("check to none")
            }
            selectedRate.enabled = !selectedRate.enabled
        }else if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark{
                cell.accessoryType = .None
            }else{
                cell.accessoryType = .Checkmark
            }
            lastCheckCell?.accessoryType = .None
            lastCheckCell = cell as? StateRateCell
            rr = lastCheckCell!.stateRate.text
            rr = rr!.substringWithRange(Range<String.Index>(start: (rr?.startIndex)!, end: (rr?.endIndex.advancedBy(-1))!))
            //print("rate: \(rr)")
            selectedRate.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === selectedRate{
            
            let vc = segue.destinationViewController as! ViewController
            vc.taxString = rr
        }
    }

    @IBAction func cancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func updateStateTaxRateDB(){
        
        let filePath = NSBundle.mainBundle().pathForResource("StatesTaxRate", ofType: "json") as String!
        let data = NSData.dataWithContentsOfMappedFile(filePath) as! NSData
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("States", inManagedObjectContext: manageContext)
        
        do{
            let jsonStateTaxRate = try NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments) as! [Dictionary<String, String>]
            
            for taxRate in jsonStateTaxRate {
                let state = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: manageContext)
                
                state.setValue(taxRate["name"], forKey: "name")
                state.setValue(taxRate["rate"], forKey: "rate")
                try manageContext.save()
            }
            
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func updateStateTaxRateFromJSON(){
        
        let filePath = NSBundle.mainBundle().pathForResource("StatesTaxRate", ofType: "json") as String!
        let data = NSData.dataWithContentsOfMappedFile(filePath) as! NSData
        
        do{
            let jsonStateTaxRate = try NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments) as! [Dictionary<String, String>]
            //var index = 0
            for taxRate in jsonStateTaxRate {
                let str = StateTaxRate(name: taxRate["name"]!, rate: taxRate["rate"]!)
                states += [str]
                //index++
            }
            
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
