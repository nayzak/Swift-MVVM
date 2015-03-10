//
//  Dynamic.swift
//
//  Created by NayZaK on 23.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import Foundation

class Dynamic<T> {
  typealias Listener = T -> ()

  private var listeners = [Listener]()
  private var retainedObjects = [AnyObject]()
  private var canFireToExternal = true
  private weak var externalDynamic: Dynamic<T>?
  lazy var listenerForExternalDynamic: Listener = {
    [weak self] v in
    self?.canFireToExternal = false
    self?.value = v
    self?.canFireToExternal = true
  }

  init(_ v: T) {
    value = v
  }

  var value: T {
    didSet {
      for l in listeners { l(value) }
      if canFireToExternal { externalDynamic?.listenerForExternalDynamic(value) }
    }
  }

  func bind(l: Listener) {
    listeners.append(l)
    l(value)
  }

  func addListener(l: Listener) {
    listeners.append(l)
  }

  func setExternalDynamic(dyn: Dynamic<T>) {
    externalDynamic = dyn
  }

  func retain(object: AnyObject) {
    retainedObjects.append(object)
  }

}

func map<T, U>(dyn: Dynamic<T>, f: T -> U) -> Dynamic<U> {
  let newDyn = Dynamic<U>(f(dyn.value))
  dyn >> { [weak newDyn] v in v; newDyn?.value = f(v) }
  dyn.retain(newDyn)
  return newDyn
}

func | <T, U>(left: Dynamic<T>, right: T -> U) -> Dynamic<U> {
  return map(left, right)
}

func filter<T>(dyn: Dynamic<T>, f: T -> Bool) -> Dynamic<T> {
  let newDyn = Dynamic<T>(dyn.value)
  dyn.addListener { [weak newDyn] v in if f(v) { newDyn?.value = v } }
  dyn.retain(newDyn)
  return newDyn
}

func & <T>(left: Dynamic<T>, right: T -> Bool) -> Dynamic<T> {
  return filter(left, right)
}

func reduce<A, B, T>(dA: Dynamic<A>, dB: Dynamic<B>, initVal: T, f: (A, B) -> T) -> Dynamic<T> {
  let dyn = Dynamic<T>(initVal)
  dA.addListener { [weak dyn, weak dB] v in if dB != nil { dyn?.value = f(v, dB!.value) } }
  dB.addListener { [weak dyn, weak dA] v in if dA != nil { dyn?.value = f(dA!.value, v) } }
  dA.retain(dyn)
  dB.retain(dyn)
  return dyn
}

func >> <T>(left: Dynamic<T>, right: T -> Void) {
  return left.addListener(right)
}

func >> <T>(left: Dynamic<T>, right: PropertyModifier<T>) {
  left.addListener(right.modifier)
}

func >> <T, B: BindableObject where B.DefaultPropertyModifierTargetType == T>(left: Dynamic<T>, right: B) {
  left.addListener(right.defaulPropertytModifier.modifier)
}

infix operator >>> {}

func >>> <T>(left: Dynamic<T>, right: T -> Void) {
  left.bind(right)
}

func >>> <T>(left: Dynamic<T>, right: PropertyModifier<T>) {
  left.bind(right.modifier)
}

func >>> <T, B: BindableObject where B.DefaultPropertyModifierTargetType == T>(left: Dynamic<T>, right: B) {
  left.bind(right.defaulPropertytModifier.modifier)
}

infix operator <<>>> {}

func <<>>> <T>(left: Dynamic<T>, right: Dynamic<T>) {
  left.setExternalDynamic(right)
  right.setExternalDynamic(left)
  right.value = left.value
}

func <<>>> <T, O: DynamicalObject where O.DefaultDynamicPropertyType == T>(left: Dynamic<T>, right: O) {
  left.setExternalDynamic(right.defaultDynamicProperty)
  right.defaultDynamicProperty.setExternalDynamic(left)
  right.defaultDynamicProperty.value = left.value
}
