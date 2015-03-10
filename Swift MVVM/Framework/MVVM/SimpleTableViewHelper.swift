//
//  TableViewHelper.swift
//
//  Created by NayZaK on 24.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

class SimpleTableViewHelper: NSObject, UITableViewDataSource, UITableViewDelegate {

  private weak var tableView: UITableView?
  private weak var data: Dynamic<[ViewModel]>?
  private weak var command: Command<Int>?

  private let cellId: String
  private var offscreenCell: BindableTableCell?

  init<C: BindableTableCell>(tableView tv: UITableView, data d: Dynamic<[ViewModel]>, cellType: C.Type, command c: Command<Int>? = nil) {
    tableView = tv
    data = d
    command = c
    cellId = className(cellType)

    super.init()

    let nib = UINib(nibName: cellId, bundle: nil)
    tableView!.registerNib(nib, forCellReuseIdentifier: cellId)
    tableView!.estimatedRowHeight = tableView!.rowHeight

    tableView!.delegate = self
    tableView!.dataSource = self

    data! >> { [weak self] v in
      if let tableView = self?.tableView {
        Async.main { tableView.reloadData() }
      }
    }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data != nil ? data!.value.count : 0
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? BindableTableCell {
      if let vm = data?.value[indexPath.row] {
        cell.bindViewModel(vm)
        if DeviceHelper.version < 8.0 {
          cell.setNeedsUpdateConstraints()
          cell.updateConstraintsIfNeeded()
        }
        return cell
      }
    }
    return UITableViewCell()
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    command?.execute(indexPath.row)
  }

  private var estimatedRowHeightCache = [NSIndexPath:CGFloat]()
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    var height = tableView.estimatedRowHeight
    if DeviceHelper.version >= 8.0 {
      height = UITableViewAutomaticDimension
      estimatedRowHeightCache[indexPath] = height
    } else {
      if let h = estimatedRowHeightCache[indexPath] { height = h }
      else if let h = cellHeight(tableView, indexPath: indexPath) {
        height = h
        estimatedRowHeightCache[indexPath] = height
      }
    }
    return height
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    var height = tableView.estimatedRowHeight
    if DeviceHelper.version >= 8.0 {
      height = estimatedRowHeightCache[indexPath] ?? height
    } else {
      if let h = estimatedRowHeightCache[indexPath] { height = h }
      else if let h = cellHeight(tableView, indexPath: indexPath) {
        height = h
        estimatedRowHeightCache[indexPath] = height
      }
    }
    return height
  }

  private func cellHeight(tableView: UITableView, indexPath: NSIndexPath) -> CGFloat? {
    var height: CGFloat? = nil
    if offscreenCell == nil {
      offscreenCell = tableView.dequeueReusableCellWithIdentifier(cellId) as? BindableTableCell
    }
    if let vm = data?.value[indexPath.row] {
      if let cell = offscreenCell {
        cell.bounds = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: tableView.estimatedRowHeight)
        cell.bindViewModel(vm)
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        height = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        if tableView.separatorStyle != .None { height! += 1.0 }
      }
    }
    return height
  }

}