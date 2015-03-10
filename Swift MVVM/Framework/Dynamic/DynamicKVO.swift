//
//  DynamicKVO.swift
//
//  Created by NayZaK on 26.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

private var XXContext = 0

final class DynamicKVO<T>: Dynamic<T> {
  private var helper: DynamicKVOHelper!

  init (object: NSObject, keyPath: String) {
    if let value = object.valueForKeyPath(keyPath) as? T {
      super.init(value)
      helper = DynamicKVOHelper(
        object: object,
        keyPath: keyPath,
        listener: {[weak self] in self?.value = $0 as T; ()} )
    } else {
      fatalError("Type missmatch: \(T.self) expected, but \(object.valueForKeyPath(keyPath)?.classForCoder) returned.")
    }
  }

  func stopObserving() {
    helper.stopObserving()
  }

}

@objc
final class DynamicKVOHelper: NSObject {
  typealias Listener = AnyObject -> ()

  private weak var object: NSObject?
  private let listener: Listener
  private let keyPath: String
  private var isObserving: Bool = true

  init(object o: NSObject, keyPath kp: String, listener l: Listener) {
    object = o
    keyPath = kp
    listener = l
    super.init()
    object!.addObserver(self, forKeyPath: keyPath, options: .New, context: &XXContext)
  }

  deinit {
    stopObserving()
  }

  func stopObserving() {
    if isObserving {
      object?.removeObserver(self, forKeyPath: keyPath)
      isObserving = false
    }
  }

  override dynamic func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    if context == &XXContext {
      if let newValue: AnyObject = change[NSKeyValueChangeNewKey] {
        listener(newValue)
      }
    }
  }
}
