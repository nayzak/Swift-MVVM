//
//  MainPage.swift
//
//  Created by NayZaK on 25.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

class MainPage: Page {
  typealias PMT = MainPageModel

  @IBOutlet weak var twbButton: UIButton!
  @IBOutlet weak var tvButton: UIButton!

  override func bindPageModel() {
    super.bindPageModel()
    let pm = pageModel as PMT
    twbButton >> pm.openTwoWayBindingPage
    tvButton >> pm.openTableViewPage
  }

}