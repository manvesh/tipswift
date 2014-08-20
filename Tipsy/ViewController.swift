//
//  ViewController.swift
//  Tipsy
//
//  Created by Manvesh on 8/19/14.
//  Copyright (c) 2014 Manvesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
  @IBOutlet weak var TipInfoLabel: UILabel!
  
  @IBOutlet weak var TipLabel: UILabel!
  
  @IBOutlet weak var TotalLabel: UILabel!
  
  @IBOutlet weak var BillAmount: UITextField!

  @IBOutlet weak var TipSlider: UISlider!
  
  let billAmountKey = "BillAmount_text"
  let tipSliderKey = "TipSlider_value"
  let appCloseTimeKey = "AppCloseTime"

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    var defaults = NSUserDefaults.standardUserDefaults()
    if let lastAppCloseTime: AnyObject = defaults.valueForKey(appCloseTimeKey) {
      if (NSDate.timeIntervalSinceReferenceDate() - (lastAppCloseTime as NSNumber) < 3600.0) {
        let tipValue = defaults.floatForKey(tipSliderKey)
        if (tipValue != TipSlider.value) { TipSlider.setValue(tipValue, animated: false) }
        
        if let billAmount = defaults.stringForKey(billAmountKey) {
          BillAmount.text = billAmount as String
        }
        self.updateTips()
      }
    }
    TipInfoLabel.text = "Tip @ \(lroundf(TipSlider.value))%"
    TipInfoLabel.sizeToFit()
  }
  
  override func viewWillDisappear(animated: Bool) {
    storeCurrentValues()
  }
  
  func storeCurrentValues() {
    var defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(BillAmount.text, forKey: billAmountKey)
    defaults.setFloat(TipSlider.value, forKey: tipSliderKey)
    let currentDate = NSDate.timeIntervalSinceReferenceDate()
    defaults.setObject(currentDate, forKey: appCloseTimeKey)
    defaults.synchronize()
    println("Completed UserDefaults synchronization")
  }
  
  func getTipAmount(amount: Double, perc: Double = 0.15) -> (tip: Double, total: Double){
    let tip = amount * perc
    return (tip, tip + amount)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func updateTips() {
    let amount = NSString(string: BillAmount.text).doubleValue
    let (tip, total) = getTipAmount(amount, perc: Double(TipSlider.value * 0.01))
    let tipString = String(format: "$%.2f", tip)
    let totalString = String(format: "$%.2f", total)
    TipLabel.text = tipString
    TotalLabel.text = totalString
    storeCurrentValues()
  }
  
  @IBAction func onBillAmountEditingChanged(sender: AnyObject) {
    updateTips()
  }

  @IBAction func onTapOutside(sender: UITapGestureRecognizer) {
    BillAmount.resignFirstResponder()
  }

  @IBAction func onSliderValueChanged(sender: AnyObject) {
    BillAmount.resignFirstResponder()
    let sliderValue = lroundf(TipSlider.value)
    TipSlider.setValue(Float(sliderValue), animated: false)
    TipInfoLabel.text = "Tip @ \(sliderValue)%"
    updateTips()
  }
}

