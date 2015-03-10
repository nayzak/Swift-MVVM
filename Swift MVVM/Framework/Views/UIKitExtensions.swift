//
//  Views+UITableView.swift
//
//  Created by NayZaK on 26.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

extension UIScrollView {

  func setTopContentInset(inset: CGFloat) {
    contentInset = UIEdgeInsets(
      top: inset,
      left: contentInset.left,
      bottom: contentInset.bottom,
      right: contentInset.right)
  }

  func addTopContentInset(inset: CGFloat) {
    contentInset = UIEdgeInsets(
      top: contentInset.top + inset,
      left: contentInset.left,
      bottom: contentInset.bottom,
      right: contentInset.right)
  }

  func setBottomContentInset(inset: CGFloat) {
    contentInset = UIEdgeInsets(
      top: contentInset.top,
      left: contentInset.left,
      bottom: inset,
      right: contentInset.right)
  }

  func addBottomContentInset(inset: CGFloat) {
    contentInset = UIEdgeInsets(
      top: contentInset.top,
      left: contentInset.left,
      bottom: contentInset.bottom + inset,
      right: contentInset.right)
  }

}

extension UITableView {

  func scrollToBottom(animated: Bool = false) {
    let lastSection = numberOfSections() - 1
    if lastSection == -1 { return }
    let lastRow = numberOfRowsInSection(lastSection) - 1
    if lastRow == -1 { return }
    let lastIndex = NSIndexPath(forRow: lastRow, inSection: lastSection)
    scrollToRowAtIndexPath(lastIndex, atScrollPosition: .Bottom, animated: animated)
  }

  func scrollToTop(animated: Bool = false) {
    if numberOfSections() > 0 && numberOfRowsInSection(0) > 0 {
      scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: animated)
    }
  }

}