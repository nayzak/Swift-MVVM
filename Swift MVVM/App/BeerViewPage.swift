//
//  BeerViewPage.swift
//
//  Created by NayZaK on 06.03.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

class BeerViewPage: Page {
  typealias PMT = BeerViewPageModel

  @IBOutlet weak var contentWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var abvLabel: UILabel!
  @IBOutlet weak var breweryLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    contentWidthConstraint.constant = UIScreen.mainScreen().bounds.width
  }

  override func bindPageModel() {
    super.bindPageModel()
    let pm = pageModel as PMT
    pm.viewModel >>> { [weak self] in self?.processViewModel($0); () }
  }

  private func processViewModel(vm: BeerViewModel) {
    abvLabel.text = vm.abv
    descriptionLabel.text = vm.description
    breweryLabel.text = vm.breweryName
  }
  
}