//
//  BeerRestService.swift
//
//  Created by NayZaK on 03.03.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

final class BeerRestService {

  func getBeersAtPage(pageNum: Int) -> [BeerModel] {
    var beers: [BeerModel] = []
    if let data = executeRequest("/beers.json?per_page=10&page=\(pageNum)") {
      if let rawBeers = data["beers"] as? [[String:AnyObject]] {
        beers = rawBeers.map { BeerModel(json: $0) }
      }
    }
    return beers
  }

  private func executeRequest(urlPath: String) -> [String:AnyObject]? {
    var urlRequest = NSMutableURLRequest()
    urlRequest.URL = NSURL(string: "http://api.openbeerdatabase.com/v1\(urlPath)")
    urlRequest.HTTPMethod = "GET"
    if let data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: nil, error: nil) {
      if let json: [String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as? [String:AnyObject] {
        return json
      }
    }
    return nil
  }

}