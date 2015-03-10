//
//  Dynamical.swift
//
//  Created by NayZaK on 23.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

protocol DynamicalObject {
  typealias DefaultDynamicPropertyType
  var defaultDynamicProperty: Dynamic<DefaultDynamicPropertyType> { get }
}