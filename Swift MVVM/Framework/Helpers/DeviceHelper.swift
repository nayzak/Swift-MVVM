//
//  DeviceHelper.swift
//
//  Created by NayZaK on 24.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

struct DeviceHelper {
  private static var _version: Float?
  static var version: Float {
    get {
      if _version == nil {
        _version = (UIDevice.currentDevice().systemVersion as NSString).floatValue
      }
      return _version!
    }
  }

}