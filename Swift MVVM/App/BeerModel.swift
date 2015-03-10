//
//  BeerModel.swift
//
//  Created by NayZaK on 03.03.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

struct BreweryModel {
  let id: Int
  let name: String
}

struct BeerModel {
  let id: Int
  let name: String
  let description: String
  let abv: Float
  let createdAt: NSDate
  let updatedAt: NSDate
  let brewery: BreweryModel

  init (json: [String:AnyObject]) {
    id = (json["id"] as NSNumber).integerValue
    name = json["name"] as String
    description = json["description"] as String
    abv = (json["abv"] as NSNumber).floatValue
    let b = json["brewery"] as [String:AnyObject]
    let bname = b["name"] as String
    let bid = (b["id"] as NSNumber).integerValue
    brewery = BreweryModel(id: bid, name: bname)
    createdAt = NSDate()
    updatedAt = NSDate()
  }
}
