//
//  Command+UIKit.swift
//
//  Created by NayZaK on 24.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

private var UIButtonPropertyKeyCommand: UInt8 = 0

extension UIButton: Commander {
  typealias CommandType = ()

  func setCommand(command: Command<CommandType>) {
    if let c: AnyObject = objc_getAssociatedObject(self, &UIButtonPropertyKeyCommand) {
      fatalError("Multiple assigment to command")
      return
    }
    objc_setAssociatedObject(self, &UIButtonPropertyKeyCommand, command, objc_AssociationPolicy(OBJC_ASSOCIATION_ASSIGN))
    command.enabled?.bind { [weak self] in self?.enabled = $0; () }
    addTarget(self, action: Selector("buttonTapped:"), forControlEvents: .TouchUpInside)
  }

  func buttonTapped(sender: AnyObject?) {
    if let c: Command<CommandType> = objc_getAssociatedObject(self, &UIButtonPropertyKeyCommand) as? Command<CommandType> {
      c.execute((), sender: sender)
    }
  }
}

private var UIBarButtonItemPropertyKeyCommand: UInt8 = 0

extension UIBarButtonItem: Commander {
  typealias CommandType = ()

  func setCommand(command: Command<CommandType>) {
    if let c: AnyObject = objc_getAssociatedObject(self, &UIBarButtonItemPropertyKeyCommand) {
      fatalError("Multiple assigment to command")
      return
    }
    objc_setAssociatedObject(self, &UIBarButtonItemPropertyKeyCommand, command, objc_AssociationPolicy(OBJC_ASSOCIATION_ASSIGN))
    command.enabled?.bind { [weak self] in self?.enabled = $0; () }
    target = self
    action = Selector("buttonTapped:")
  }

  func buttonTapped(sender: AnyObject?) {
    if let c: Command<CommandType> = objc_getAssociatedObject(self, &UIBarButtonItemPropertyKeyCommand) as? Command<CommandType> {
      c.execute((), sender: sender)
    }
  }
}

private var UIRefreshControlItemPropertyKeyCommand: UInt8 = 0

extension UIRefreshControl: Commander {
  typealias CommandType = ()

  func setCommand(command: Command<CommandType>) {
    if let c: AnyObject = objc_getAssociatedObject(self, &UIRefreshControlItemPropertyKeyCommand) {
      fatalError("Multiple assigment to command")
      return
    }
    objc_setAssociatedObject(self, &UIRefreshControlItemPropertyKeyCommand, command, objc_AssociationPolicy(OBJC_ASSOCIATION_ASSIGN))
    command.enabled?.bind { [weak self] in self?.enabled = $0; () }
    addTarget(self, action: Selector("beginRefresh:"), forControlEvents: .ValueChanged)
  }

  func beginRefresh(sender: AnyObject?) {
    if let c: Command<CommandType> = objc_getAssociatedObject(self, &UIRefreshControlItemPropertyKeyCommand) as? Command<CommandType> {
      c.execute((), sender: sender)
    }
  }
}
