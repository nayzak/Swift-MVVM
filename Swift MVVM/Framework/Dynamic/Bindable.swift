//
//  Bindable.swift
//
//  Created by NayZaK on 23.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

protocol BindableObject {
  typealias DefaultPropertyModifierTargetType
  var defaulPropertytModifier: PropertyModifier<DefaultPropertyModifierTargetType> { get }
}

final class PropertyModifier<T> {
  typealias Modifier = (T) -> ()
  var modifier: Modifier

  init (_ l: Modifier) {
    self.modifier = l
  }
}