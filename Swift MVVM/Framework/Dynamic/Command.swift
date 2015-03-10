//
//  Command.swift
//
//  Created by NayZaK on 24.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

final class Command<T> {
  typealias CommandType = (value: T, sender: AnyObject?) -> ()

  weak var enabled: Dynamic<Bool>?
  private let command: CommandType

  init (enabled: Dynamic<Bool>, command: CommandType) {
    self.enabled = enabled
    self.command = command
  }

  init (command: CommandType) {
    self.command = command
  }

  func execute(value: T) {
    execute(value, sender: nil)
  }

  func execute(value: T, sender: AnyObject?) {
    var enabled = true
    if let en = self.enabled?.value { enabled = en }
    if enabled { command(value: value, sender: sender) }
  }
}

protocol Commander {
  typealias CommandType
  func setCommand(command: Command<CommandType>)
}

func >> <T, B: Commander where B.CommandType == T>(left: B, right: Command<T>) {
  left.setCommand(right)
}