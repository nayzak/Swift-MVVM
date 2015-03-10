//
//  ReflectionHelper.swift
//
//  Created by NayZaK on 25.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

func className<T: NSObject>(type: T.Type) -> String {
  let name = NSStringFromClass(T.classForCoder())
  return name.componentsSeparatedByString(".").last!
}