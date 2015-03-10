//
//  BeerListPageModel.swift
//
//  Created by NayZaK on 03.03.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

final class BeerListPageModel: PageModel, PullToRefreshHandler, InfiniteScrollHandler {

  private let restService: BeerRestService = BeerRestService()
  private var lastPage: Int = 0
  private var beersModel: [BeerModel] = []
  let beerList: Dynamic<[ViewModel]> = Dynamic([])

  override init() {
    super.init()
    title.value = "Beers"
    backButtonTitle = title.value
  }

  override func initAfterAppear() {
    isBusy.value = true
    beginNetworkActivity()
    Async
      .background {
        self.lastPage++
        self.beersModel = self.restService.getBeersAtPage(self.lastPage)
        self.beerList.value = self.beersModel.map { BeerViewModel(model: $0) }
      }
      .main {
        self.isBusy.value = false
        self.endNetworkActivity()
      }
  }

  // MARK: Commands

  lazy var openBeerPage: Command<Int> = Command {
    [weak self] index, s in
    if let slf = self {
      let model = slf.beersModel[index]
      let page = BeerViewPage(pageModel: BeerViewPageModel(model: model))
      slf.pushPage(page)
    }
  }

  // MARK: PullToRefreshHandler

  var pullToRefreshAnimating: Dynamic<Bool> = Dynamic(false)
  lazy var pullToRefreshCommand: Command<()> = Command {
    [weak self] v,s in
    if let slf = self {
      if slf.isBusy.value {
        slf.pullToRefreshAnimating.value = false
        return
      }
      Async
        .background { slf.updateList() }
        .main { slf.pullToRefreshAnimating.value = false }
    }
  }

  // MARK: InfiniteScrollHandler
  
  var infiniteScrollAnimating: Dynamic<Bool> = Dynamic(false)
  lazy var infiniteScrollCommand: Command<()> = Command {
    [weak self] v,s in
    if let slf = self {
      if slf.isBusy.value {
        slf.infiniteScrollAnimating.value = false
        return
      }
      Async
        .background { slf.appendToList() }
        .main { slf.infiniteScrollAnimating.value = false }
    }
  }

  // MARK: Methods

  private func updateList() {
    isBusy.value = true
    beginNetworkActivity()
    lastPage = 1
    beersModel = restService.getBeersAtPage(lastPage)
    beerList.value = beersModel.map { BeerViewModel(model: $0) }
    isBusy.value = false
    endNetworkActivity()
  }

  private func appendToList() {
    isBusy.value = true
    beginNetworkActivity()
    lastPage++
    let newItems = restService.getBeersAtPage(lastPage)
    if newItems.count > 0 {
      beersModel += newItems
      beerList.value = beersModel.map { BeerViewModel(model: $0) }
    }
    isBusy.value = false
    endNetworkActivity()
  }

}