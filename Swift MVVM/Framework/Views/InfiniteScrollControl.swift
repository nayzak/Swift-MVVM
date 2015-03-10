//
//  InfiniteScrollControl.swift
//
//  Created by NayZaK on 25.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

final class InfiniteScrollControl: UIActivityIndicatorView, Commander, BindableObject {

  private let visibleHeight: CGFloat = 46.0
  private var heightConstraint: NSLayoutConstraint!
  private weak var tableView: UITableView?
  private var tableViewOffset: DynamicKVO<NSValue>?
  private var originalContentInset: UIEdgeInsets?
  private var refreshing: Bool = false

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  override init() {
    super.init()
  }

  override init(frame: CGRect) {
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    activityIndicatorViewStyle = .Gray
    hidesWhenStopped = true
    setTranslatesAutoresizingMaskIntoConstraints(false)
    addConstraint(al_height == visibleHeight)
  }

  override func willMoveToSuperview(newSuperview: UIView?) {
    if let tv = newSuperview as? UITableView {
      self.tableView = tv
      bindToTableView()
    } else if newSuperview == nil && !(superview is UITableView) && tableView != nil {
      tableViewOffset?.stopObserving()
    }
  }

  override func didMoveToSuperview() {
    if let tableView = superview as? UITableView {
      if let newSuperView = tableView.superview {
        removeFromSuperview()
        newSuperView.insertSubview(self, aboveSubview: tableView)
      }
    } else if superview != nil {
      if let tableView = self.tableView {
        superview!.addConstraint(tableView.al_bottom == al_bottom + originalContentInset!.bottom)
        superview!.addConstraint(al_centerX == tableView.al_centerX)
      }
    }
  }

  private func bindToTableView() {
    if let tv = tableView {
      originalContentInset = tv.contentInset
      tv.addBottomContentInset(visibleHeight)
      tableViewOffset = DynamicKVO<NSValue>(object: tv, keyPath: "contentOffset")
      tableViewOffset! >>> { [weak self] in self?.contentOffsetDidChange($0.CGPointValue().y); () }
    }
  }

  private var prevOffset: CGFloat = 0.0

  private func contentOffsetDidChange(offset: CGFloat) {
    if let tv = tableView {
      let contentHeight = tv.contentSize.height
      let offsetThreshold = contentHeight - tv.bounds.size.height
      if offset > offsetThreshold && prevOffset < offset && tv.dragging && !refreshing {
        beginRefreshing()
      }
      prevOffset = offset
    }
  }

  private func beginRefreshing(executeCommand: Bool = true) {
    refreshing = true
    tableView?.addBottomContentInset(visibleHeight)
    startAnimating()
    if executeCommand {
      command?.execute((), sender: self)
    }
  }

  private func endRefreshing() {
    stopAnimating()
    refreshing = false
    UIView.animateWithDuration(0.3, delay: 0, options: .AllowUserInteraction | .BeginFromCurrentState,
      animations: { self.tableView?.setBottomContentInset(self.originalContentInset!.bottom); () }, completion: nil)
  }

  // MARK: Commander

  typealias CommandType = ()

  private weak var command: Command<CommandType>?

  func setCommand(command: Command<CommandType>) {
    self.command = command
    self.command!.enabled?.bind { [weak self] in self?.hidden = $0; () }
  }

  // MARK: BindableObject

  lazy var refreshingModifier: PropertyModifier<Bool> = PropertyModifier<Bool> {
      [weak self] v in v
      if let uSelf = self {
        Async.main {
          if !v { uSelf.endRefreshing() }
          else {
            uSelf.beginRefreshing(executeCommand: false)
            uSelf.tableView?.scrollToBottom()
          }
        }
      }
    }

  typealias DefaultPropertyModifierTargetType = Bool
  
  var defaulPropertytModifier: PropertyModifier<DefaultPropertyModifierTargetType> {
    return refreshingModifier
  }

}

protocol InfiniteScrollHandler {
  var infiniteScrollAnimating: Dynamic<Bool> { get }
  var infiniteScrollCommand: Command<()> { get }
}

func >> <T: InfiniteScrollHandler>(left: InfiniteScrollControl, right: T) {
  left >> right.infiniteScrollCommand
  right.infiniteScrollAnimating >> left
}