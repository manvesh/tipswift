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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    BillAmount.text = ""
    TipInfoLabel.text = "Tip @ \(lroundf(TipSlider.value))%"
    TipInfoLabel.sizeToFit()
  }
  
  func getTipAmount(amount: Double, perc: Double = 0.15) -> (tip: Double, total: Double){
    let tip = amount * perc
    return (tip, tip + amount)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBAction func onBillAmountEditingChanged(sender: AnyObject) {
    let amount = NSString(string: BillAmount.text).doubleValue
    let (tip, total) = getTipAmount(amount)
    let tipString = String(format: "$%.2f", tip)
    let totalString = String(format: "$%.2f", total)
    TipLabel.text = tipString
    TotalLabel.text = totalString
  }

  @IBAction func onTapOutside(sender: UITapGestureRecognizer) {
    BillAmount.resignFirstResponder()
  }

  @IBAction func onSliderValueChanged(sender: AnyObject) {
    let sliderValue = lroundf(TipSlider.value)
    TipSlider.setValue(Float(sliderValue), animated: false)
    TipInfoLabel.text = "Tip @ \(sliderValue)%"
  }
}

