//
//  BeerViewModel.swift
//
//  Created by NayZaK on 03.03.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

class BeerViewModel: ViewModel {

  let id: Int
  let name: String
  let description: String
  let abv: String
  let breweryName: String

  init(model: BeerModel) {
    id = model.id
    name = model.name
    description = model.description
    abv = "\(model.abv)"
    breweryName = model.brewery.name
    super.init()
  }

}