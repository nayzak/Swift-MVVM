//
//  TwoWayBindingPageModel.swift
//
//  Created by NayZaK on 26.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

final class TwoWayBindingPageModel: PageModel {

  let somethingEnabled = Dynamic<Bool>(true)
  let userName = Dynamic<String>("Initial")
  let accuracy = Dynamic<Float>(0.7)

  override init() {
    super.init()
    title.value = "Two way bindings"
    navBarAppearance = NavBarAppearanses.Blue
  }

  //MARK: Commands

  lazy var changeSomethingEnabled: Command<()> = Command {
    [weak self] v,s in s
    self?.somethingEnabled.value = !self!.somethingEnabled.value
  }

  lazy var changeUserName: Command<()> = Command (
    enabled: self.somethingEnabled,
    command: {
      [weak self] v,s in s
      self?.userName.value = "\(rand())"
    })

  lazy var changeAccuracy: Command<()> = Command {
    [weak self] v,s in s
    self?.accuracy.value = Float(arc4random()) / Float(UINT32_MAX)
  }

}