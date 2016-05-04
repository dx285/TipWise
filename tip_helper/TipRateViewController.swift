//
//  TipRateViewController.swift
//  tip_helper
//
//  Created by Di on 1/29/16.
//  Copyright © 2016 Di. All rights reserved.
//

import UIKit
import CoreData

class TipRateViewController: UITableViewController {
    
    var tipRate = 0.0
    var tips = [TipRate]()
    var lastBtn = UIButton()
    @IBOutlet weak var selectedTipRateBtn: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //saveTipRate()
        updateTipsRateFromJSON()
        selectedTipRateBtn.enabled = false
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
//        let fetchRequest = NSFetchRequest(entityName: "Tips")
//        
//        do{
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            tips = results as! [NSManagedObject]
//        }catch let error as NSError{
//            print("Could not save \(error), \(error.userInfo)")
//        }
    }
    
    func saveTipRate(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Tips", inManagedObjectContext: manageContext)
        let tip = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: manageContext)
        
        tip.setValue("Restaurant", forKey: "category")
        tip.setValue("10%", forKey: "bad")
        tip.setValue("15%", forKey: "good")
        tip.setValue("20%", forKey: "excellent")
        
        do{
            try manageContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "tipRateViewControllerCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TipRateCell
        let tip = tips[indexPath.row]

        cell.category.text = tip.category
        cell.badTipBtn.setTitle(tip.bad, forState: UIControlState.Normal)
        cell.goodTipBtn.setTitle(tip.good, forState: UIControlState.Normal)
        cell.excTipBtn.setTitle(tip.excellent, forState: UIControlState.Normal)
        
        return cell
    }
    
    @IBAction func didBadTip(sender: UIButton) {
        
        //print("bad")
        var tt = sender.titleLabel?.text
        tt = tt!.substringWithRange(Range<String.Index>(start: (tt?.startIndex)!, end: (tt?.endIndex.advancedBy(0))!))
        //print("text bad: \(tt)")
        tipRate = (tt! as NSString).doubleValue
        //print("select bad: \(tipRate)")
        btnSelected(sender)
    }
    
    
    @IBAction func didGoodTip(sender: UIButton) {
        
        var tt = sender.titleLabel?.text
        tt = tt!.substringWithRange(Range<String.Index>(start: (tt?.startIndex)!, end: (tt?.endIndex.advancedBy(0))!))
        //print("text good: \(tt)")
        tipRate = (tt! as NSString).doubleValue
        //print("select good: \(tipRate)")
        btnSelected(sender)
    }
    
    
    @IBAction func didExlTip(sender: UIButton) {
        
        var tt = sender.titleLabel?.text
        tt = tt!.substringWithRange(Range<String.Index>(start: (tt?.startIndex)!, end: (tt?.endIndex.advancedBy(0))!))
        //print("text excellent: \(tt)")
        tipRate = (tt! as NSString).doubleValue
        //print("select excellent: \(tipRate)")
        btnSelected(sender)
    }
    
    func btnSelected(btn: UIButton){
        //print("call btn")
        if lastBtn === btn{
            lastBtn.selected = !lastBtn.selected
            selectedTipRateBtn.enabled = !selectedTipRateBtn.enabled
        }else{
            btn.selected = true
            if lastBtn.selected{
                lastBtn.selected = !lastBtn.selected
            }
            lastBtn = btn
            selectedTipRateBtn.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === selectedTipRateBtn{
            
            let vc = segue.destinationViewController as! ViewController
            vc.tip = tipRate/100
            print("tip: \(vc.tip)")
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        //print("click cancel")
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func updateTipsRateFromJSON(){
        
        let filePath = NSBundle.mainBundle().pathForResource("TipRate", ofType: "json") as String!
        let data = NSData.dataWithContentsOfMappedFile(filePath) as! NSData
        
        do{
            let jsonTipRate = try NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments) as! [Dictionary<String, String>]

            for tipRate in jsonTipRate {
                let tp = TipRate(category: tipRate["category"]!, bad: tipRate["bad"]!, good: tipRate["good"]!, excellent: tipRate["excellent"]!)
                tips += [tp]
            }
            
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}
