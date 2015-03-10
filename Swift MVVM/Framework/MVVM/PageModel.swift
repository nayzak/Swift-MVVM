//
//  PageModel.swift
//
//  Created by NayZaK on 25.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

class PageModel {
  let title: Dynamic<String> = Dynamic("Default page title")
  var backButtonTitle: String = ""
  var navBarAppearance: NavigationBarArappearance?
  let isBusy: Dynamic<Bool> = Dynamic(false)

  init() { }

  // MARK: Commands

  lazy var toggleSideMenu: Command<()> = Command {
    [weak self] v,s in
    // Code to show/hide side menu
  }

  // MARK: Methods

  func initAfterAppear() { }

  func didAppear() { }

  func pushPage(page: Page) {
    ApplicationController.instance.pushPage(page)
  }

  func popPage() {
    ApplicationController.instance.popPage()
  }

  func beginNetworkActivity() {
    ApplicationController.instance.beginNetworkActivity()
  }

  func endNetworkActivity() {
    ApplicationController.instance.endNetworkActivity()
  }

}