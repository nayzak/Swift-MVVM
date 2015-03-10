//
//  Page.swift
//
//  Created by NayZaK on 25.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

struct NavigationBarArappearance {
  let backgroundColor: UIColor
  let textColor: UIColor
  let buttonsColor: UIColor
  let statusBarStyle: UIStatusBarStyle
  let hasShadow: Bool
  let translucent: Bool
}

class Page: UIViewController {

  let pageModel: PageModel
  var hamburgerButton: UIBarButtonItem?

  init(pageModel pm: PageModel) {
    pageModel = pm
    super.init(nibName: nil, bundle: nil)
  }

  func bindPageModel() {
    pageModel.title >>> { [weak self] in self?.title = $0; () }
    if let hb = hamburgerButton {
      hb >> pageModel.toggleSideMenu
    }
  }

  override func viewDidLoad() {
    bindPageModel()
    super.viewDidLoad()
  }

  override func viewWillAppear(animated: Bool) {
    setupNavigationBarAppearance()
    setupBackButton()
    super.viewWillAppear(animated)
  }

  private var didAppearAtFirstTime: Bool = true
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    if didAppearAtFirstTime {
      pageModel.initAfterAppear()
      didAppearAtFirstTime = false
    } else {
      pageModel.didAppear()
    }
  }

  func addBarButtonItemWithSystemStyle(style: UIBarButtonSystemItem) -> UIBarButtonItem {
    let button = UIBarButtonItem(barButtonSystemItem: style, target: nil, action: nil)
    addButtonToRightItems(button)
    return button
  }

  func addBarButtonItemWithImage(image: String) -> UIBarButtonItem {
    let button = UIBarButtonItem(image: UIImage(named: image), style: .Plain, target: nil, action: nil)
    addButtonToRightItems(button)
    return button
  }

  func addBarButtonItemWithTitle(title: String) -> UIBarButtonItem {
    let button = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
    addButtonToRightItems(button)
    return button
  }

  func setupHamburgerButton() {
    if hamburgerButton == nil {
      hamburgerButton = UIBarButtonItem(image: UIImage(named: "hamburger-button"), style: .Plain, target: self, action: nil)
      if navigationItem.leftBarButtonItems?.append(hamburgerButton!) == nil {
        navigationItem.leftBarButtonItem = hamburgerButton!
      }
    }
  }

  private func addButtonToRightItems(button: UIBarButtonItem) {
    if navigationItem.rightBarButtonItems?.append(button) == nil {
      navigationItem.rightBarButtonItems = [button]
    }
  }

  private func setupBackButton() {
    navigationItem.backBarButtonItem =
      UIBarButtonItem(title: pageModel.backButtonTitle, style: .Plain, target: self, action: nil)
  }

  private func setupNavigationBarAppearance() {
    if let nb = navigationController?.navigationBar {
      if let ap = pageModel.navBarAppearance {
        nb.barTintColor = ap.backgroundColor
        nb.tintColor = ap.buttonsColor
        nb.titleTextAttributes = [NSForegroundColorAttributeName : ap.textColor]
        UIApplication.sharedApplication().setStatusBarStyle(ap.statusBarStyle, animated: false)
        nb.translucent = ap.translucent
        let shadow: UIImage? = ap.hasShadow ? nil : UIImage()
        nb.setBackgroundImage(shadow, forBarMetrics: UIBarMetrics.Default)
        nb.shadowImage = shadow
        if nb.translucent && !(view.subviews.first is UITableView) {
          edgesForExtendedLayout = UIRectEdge.None
        }
      }
    }
  }

  override func loadView() {
    let nibName = self.dynamicType.description().componentsSeparatedByString(".").last!
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: nibName, bundle: bundle)
    view = nib.instantiateWithOwner(self, options: nil)[0] as UIView
  }

  // MARK: Useless initializers

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

}