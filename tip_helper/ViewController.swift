//
//  ViewController.swift
//  tip_helper
//
//  Created by Di on 1/15/16.
//  Copyright © 2016 Di. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var exp: Double = 0
    var tt: Double = 0
    var ea: Double = 0
    var tax: Double = 0.1
    var taxString: String?
    var tip: Double = 0.15
    var count: Int = 5
    var amount:Double = 0
    
    @IBOutlet weak var expense: UITextField!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var each: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var splitLabel: UILabel!

    
    @IBAction func taxRate(sender: UISlider) {
        
        taxLabel.text = ("\(Int(sender.value))%")
        tax = Double(sender.value)/100
        calculate()
    }
    
    @IBAction func tipRate(sender: UISlider) {
        
        tipLabel.text = ("\(Int(sender.value))%")
        tip = Double(sender.value)/100
        calculate()
    }
    
    @IBAction func split(sender: UISlider) {
        
        splitLabel.text = ("\(Int(sender.value))")
        count = Int(sender.value)
        splitBill()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expense.delegate = self
        expense.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        calculate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidChange(textField: UITextField?){
        
        if let tmp = textField!.text {
            if tmp.characters.count != 0 {
                exp = Double(tmp)!
            }else{
                exp = 0
                //expense.text = "$0.00"
            }
        }
        calculate()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        calculate()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        expense.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if let tmp = expense.text{
            if tmp.characters.count == 0{
                exp = 0
            }else{
                exp = Double(tmp)!
            }
        }else{
            exp = 0
        }
        calculate()
        //expense.resignFirstResponder()
    }
    
    func calculate(){
        amount = exp*(1+tip)*(1+tax)
        total.text = ("$\(round(amount*100)/100)")
        //each.text = ("\(amount/count)")
        splitBill()
    }
    
    func splitBill(){
        
        each.text = ("$\( round((amount/Double(count))*100)/100 )")
        
        //print("amount: \(amount) and count: \(count) ")
    }

    @IBAction func unwindForStateRate(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? StateTaxRateViewController{
            
            taxString = sourceViewController.rr
            
            tax = (taxString! as NSString).doubleValue/100
            taxLabel.text = ("\(tax*100)%")
            calculate()
            //print("unwind")

        }else if let sourceViewController = sender.sourceViewController as? TipRateViewController{
            
            tip = sourceViewController.tipRate
            tipLabel.text = ("\(tip)%")
            tip /= 100
            calculate()
            //print("unwind from tip \(tip)")
        }
        
    }
    
}

