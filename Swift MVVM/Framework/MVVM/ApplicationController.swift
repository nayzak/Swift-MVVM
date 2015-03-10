//
//  ApplicationController.swift
//
//  Created by NayZaK on 26.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

private var _appController = ApplicationController()

class ApplicationController {

  class var instance: ApplicationController {
    return _appController
  }

  private let window = UIWindow(frame: UIScreen.mainScreen().bounds)
  private let navigationController = UINavigationController()

  func setup() {
    window.rootViewController = navigationController

    let page = MainPage(pageModel: MainPageModel())
    navigationController.pushViewController(page, animated: false)
  }

  func show() {
    window.makeKeyAndVisible()
  }

  func pushPage(page: Page) {
    navigationController.pushViewController(page, animated: true)
  }

  func popPage() {
    navigationController.popViewControllerAnimated(true)
  }

  func beginNetworkActivity() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
  }
  
  func endNetworkActivity() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }

}