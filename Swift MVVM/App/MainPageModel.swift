//
//  MainPageModel.swift
//
//  Created by NayZaK on 25.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

final class MainPageModel: PageModel {

  override init() {
    super.init()
    title.value = "Main page"
    backButtonTitle = "Main"
    navBarAppearance = NavBarAppearanses.Gray
  }

  // MARK: Commands

  lazy var openTwoWayBindingPage: Command<()> = Command {
    [weak self] v,s in s
    self?.pushPage(TwoWayBindingPage(pageModel: TwoWayBindingPageModel()))
  }

  lazy var openTableViewPage: Command<()> = Command {
    [weak self] v,s in s
    self?.pushPage(BeerListPage(pageModel: BeerListPageModel()))
  }

}