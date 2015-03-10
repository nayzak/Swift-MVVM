//
//  BeerViewPageModel.swift
//
//  Created by NayZaK on 06.03.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

final class BeerViewPageModel: PageModel {

  let viewModel: Dynamic<BeerViewModel>

  init(model: BeerModel) {
    viewModel = Dynamic(BeerViewModel(model: model))
    super.init()
    title.value = viewModel.value.name
  }

}