//
//  TwoWayBindingPage.swift
//
//  Created by NayZaK on 26.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

class TwoWayBindingPage: Page {
  typealias PMT = TwoWayBindingPageModel

  @IBOutlet weak var switchLabel: UILabel!
  @IBOutlet weak var switchControl: UISwitch!
  @IBOutlet weak var switchButton: UIButton!
  @IBOutlet weak var textFieldLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var textFieldButton: UIButton!
  @IBOutlet weak var sliderLabel: UILabel!
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var sliderButton: UIButton!

  override func bindPageModel() {
    super.bindPageModel()
    let pm = pageModel as PMT

    switchButton >> pm.changeSomethingEnabled
    textFieldButton >> pm.changeUserName
    sliderButton >> pm.changeAccuracy

    pm.somethingEnabled | { "Current dynamic value: \($0)" } >>> switchLabel
    pm.userName | { "Current dynamic value: \($0)" } >>> textFieldLabel
    pm.accuracy | { "Current dynamic value: \($0)" } >>> sliderLabel

    pm.somethingEnabled <<>>> switchControl
    pm.userName <<>>> textField
    pm.accuracy <<>>> slider
  }
  
}