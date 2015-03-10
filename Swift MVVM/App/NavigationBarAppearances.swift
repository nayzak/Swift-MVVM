//
//  NavigationBarAppearances.swift
//
//  Created by NayZaK on 26.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

struct NavBarAppearanses {
  static let Gray = NavigationBarArappearance (
    backgroundColor: UIColor.grayColor(),
    textColor: UIColor.whiteColor(),
    buttonsColor: UIColor.whiteColor(),
    statusBarStyle: .LightContent,
    hasShadow: true,
    translucent: true)
  
  static let Blue = NavigationBarArappearance (
    backgroundColor: UIColor.blueColor(),
    textColor: UIColor.whiteColor(),
    buttonsColor: UIColor.whiteColor(),
    statusBarStyle: .LightContent,
    hasShadow: true,
    translucent: true)
}