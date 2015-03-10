//
//  BeerListPage.swift
//
//  Created by NayZaK on 03.03.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

class BeerListPage: Page {
  typealias PMT = BeerListPageModel

  @IBOutlet weak var tableView: UITableView!
  private var tableViewHelper: SimpleTableViewHelper!

  override func bindPageModel() {
    super.bindPageModel()
    let pm = pageModel as PMT

    tableViewHelper =
      SimpleTableViewHelper(tableView: tableView, data: pm.beerList, cellType: BeerTableCell.self, command: pm.openBeerPage)
    tableView.pullToRefreshControl >> pm
    tableView.infiniteScrollControl >> pm
  }

}