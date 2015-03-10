//
//  BeerTableCell.swift
//
//  Created by NayZaK on 24.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

class BeerTableCell: BindableTableCell {
  
  @IBOutlet weak var titleLabel: UILabel!

  override func bindViewModel(vm: ViewModel) {
    if let vm = vm as? BeerViewModel {
      titleLabel.text = vm.name
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    if DeviceHelper.version < 8.0 {
      titleLabel.preferredMaxLayoutWidth = 300
    }
  }

  override var layoutMargins: UIEdgeInsets {
    get { return UIEdgeInsetsZero }
    set {}
  }
  
}