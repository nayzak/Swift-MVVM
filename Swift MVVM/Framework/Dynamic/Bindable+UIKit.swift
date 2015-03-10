//
//  Bindable+UIKit.swift
//
//  Created by NayZaK on 23.02.15.
//  Copyright (c) 2015 Amur.net. All rights reserved.
//

import UIKit

protocol PullToRefreshHandler {
  var pullToRefreshAnimating: Dynamic<Bool> { get }
  var pullToRefreshCommand: Command<()> { get }
}

struct AnimationSettings {
  let duration: NSTimeInterval
  let options: UIViewAnimationOptions
}

// MARK: UIView

private var UIViewPropertyKeyHiddenModifier: UInt8 = 0
private var UIViewPropertyKeyAlphaModifier: UInt8 = 0

extension UIView {
  var hiddenModifier: PropertyModifier<Bool> {
    if let pm: AnyObject = objc_getAssociatedObject(self, &UIViewPropertyKeyHiddenModifier) {
      return pm as PropertyModifier<Bool>
    } else {
      let pm = PropertyModifier<Bool> {
        [weak self] v in v
        self?.hidden = v
      }
      objc_setAssociatedObject(self, &UIViewPropertyKeyHiddenModifier, pm, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return pm
    }
  }

  var alphaModifier: PropertyModifier<CGFloat> {
    if let pm: AnyObject = objc_getAssociatedObject(self, &UIViewPropertyKeyAlphaModifier) {
      return pm as PropertyModifier<CGFloat>
    } else {
      let pm = PropertyModifier<CGFloat> {
        [weak self] v in v
        self?.alpha = v
      }
      objc_setAssociatedObject(self, &UIViewPropertyKeyAlphaModifier, pm, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return pm
    }
  }
}

// MARK: UILabel

private var UILabelPropertyKeyTextModifier: UInt8 = 0
private var UILabelPropertyKeyTextModifierWithCustomAnimation: UInt8 = 0
private var UILabelPropertyKeyTextModifierWithDefaultAnimation: UInt8 = 0

extension UILabel {
  var textModifier: PropertyModifier<String?> {
    if let pm: AnyObject = objc_getAssociatedObject(self, &UILabelPropertyKeyTextModifier) {
      return pm as PropertyModifier<String?>
    } else {
      let pm = PropertyModifier<String?> {
        [weak self] v in v
        self?.text = v
      }
      objc_setAssociatedObject(self, &UILabelPropertyKeyTextModifier, pm, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return pm
    }
  }

  var textModifierWithAnimation: PropertyModifier<String?> {
    let an = AnimationSettings(duration: 0.2, options: .TransitionCrossDissolve)
    return textModifierWithCustomAnimation(animationSettings: an, propertyKey: &UILabelPropertyKeyTextModifierWithDefaultAnimation)
  }

  func textModifierWithCustomAnimation(an: AnimationSettings) -> PropertyModifier<String?> {
    return textModifierWithCustomAnimation(animationSettings: an, propertyKey: &UILabelPropertyKeyTextModifierWithCustomAnimation)
  }

  private func textModifierWithCustomAnimation(animationSettings an: AnimationSettings, propertyKey pkey: UnsafePointer<Void>) -> PropertyModifier<String?> {
    if let pm: AnyObject = objc_getAssociatedObject(self, pkey) {
      return pm as PropertyModifier<String?>
    } else {
      let pm = PropertyModifier<String?> {
        [weak self] v in
        if self != nil {
          UIView.transitionWithView(
            self!,
            duration: an.duration,
            options: an.options,
            animations: { self!.text = v },
            completion: nil)
        }
      }
      objc_setAssociatedObject(self, pkey, pm, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return pm
    }
  }

}

extension UILabel: BindableObject {
  typealias DefaultPropertyModifierTargetType = String?
  var defaulPropertytModifier: PropertyModifier<DefaultPropertyModifierTargetType> {
    return textModifier
  }
}

// MARK: UISwitch

private var UISwitchPropertyKeyOnModifier: UInt8 = 0
private var UISwitchPropertyKeyOnDynamic: UInt8 = 0

extension UISwitch {
  var onModifier: PropertyModifier<Bool> {
    if let pm: AnyObject = objc_getAssociatedObject(self, &UISwitchPropertyKeyOnModifier) {
      return pm as PropertyModifier<Bool>
    } else {
      let pm = PropertyModifier<Bool> {
        [weak self] v in v
        self?.on = v
      }
      objc_setAssociatedObject(self, &UISwitchPropertyKeyOnModifier, pm, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return pm
    }
  }

  var onDynamic: Dynamic<Bool> {
    if let pm: AnyObject = objc_getAssociatedObject(self, &UISwitchPropertyKeyOnDynamic) {
      return pm as Dynamic<Bool>
    } else {
      let pm = Dynamic<Bool>(on)
      pm >>> { [weak self] v in v; self?.on = v }
      addTarget(self, action: Selector("valueChanged:"), forControlEvents: .ValueChanged)
      objc_setAssociatedObject(self, &UISwitchPropertyKeyOnDynamic, pm, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return pm
    }
  }

  func valueChanged(control: UISwitch) {
    onDynamic.value = on
  }
}

extension UISwitch: BindableObject {
  typealias DefaultPropertyModifierTargetType = Bool
  var defaulPropertytModifier: PropertyModifier<DefaultPropertyModifierTargetType> {
    return onModifier
  }
}

extension UISwitch: DynamicalObject {
  typealias DefaultDynamicalPropertyType = Bool
  var defaultDynamicProperty: Dynamic<DefaultDynamicalPropertyType> {
    return onDynamic
  }
}

// MARK: UIButton

private var UIButtonPropertyKeyEnabledModifier: UInt8 = 0

extension UIButton {
  var enabledModifier: PropertyModifier<Bool> {
    if let pm: AnyObject = objc_getAssociatedObject(self, &UIButtonPropertyKeyEnabledModifier) {
      return pm as PropertyModifier<Bool>
    } else {
      let pm = PropertyModifier<Bool> {
        [weak self] v in v
        self?.enabled = v
      }
      objc_setAssociatedObject(self, &UIButtonPropertyKeyEnabledModifier, pm, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return pm
    }
  }
}

extension UIButton: BindableObject {
  typealias DefaultPropertyModifierTargetType = Bool
  var defaulPropertytModifier: PropertyModifier<DefaultPropertyModifierTargetType> {
    return enabledModifier
  }
}

// MARK: UIBarButtonItem

private var UIBarButtonItemPropertyKeyEnabledModifier: UInt8 = 0

extension UIBarButtonItem {
  var enabledModifier: PropertyModifier<Bool> {
    if let pm: AnyObject = objc_getAssociatedObject(self, &UIBarButtonItemPropertyKeyEnabledModifier) {
      return pm as PropertyModifier<Bool>
    } else {
      let pm = PropertyModifier<Bool> {
        [weak self] v in v
        self?.enabled = v
      }
      objc_setAssociatedObject(self, &UIBarButtonItemPropertyKeyEnabledModifier, pm, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return pm
    }
  }
}

extension UIBarButtonItem: BindableObject {
  typealias DefaultPropertyModifierTargetType = Bool
  var defaulPropertytModifier: PropertyModifier<DefaultPropertyModifierTargetType> {
    return enabledModifier
  }
}

// MARK: UIRefreshControl

private var UIRefreshControlPropertyKeyRefreshingModifier: UInt8 = 0

extension UIRefreshControl {
  var refreshingModifier: PropertyModifier<Bool> {
    if let pm: AnyObject = objc_getAssociatedObject(self, &UIRefreshControlPropertyKeyRefreshingModifier) {
      return pm as PropertyModifier<Bool>
    } else {
      let pm = PropertyModifier<Bool> {
        [weak self] v in v
        if let uSelf = self {
          if !v { uSelf.endRefreshing() }
          else {
            uSelf.beginRefreshing()
            if let tableView = uSelf.superview as? UITableView {
              tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: true)
            }
          }
        }
      }
      objc_setAssociatedObject(self, &UIRefreshControlPropertyKeyRefreshingModifier, pm, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return pm
    }
  }
}

extension UIRefreshControl: BindableObject {
  typealias DefaultPropertyModifierTargetType = Bool
  var defaulPropertytModifier: PropertyModifier<DefaultPropertyModifierTargetType> {
    return refreshingModifier
  }
}

func >> <T: PullToRefreshHandler>(left: UIRefreshControl, right: T) {
  left >> right.pullToRefreshCommand
  right.pullToRefreshAnimating >> left
}

// MARK: UITableView

private var UITableViewPrepertyKeyTopRefreshControl: UInt8 = 0
private var UITableViewPrepertyKeyInfiniteScrollControl: UInt8 = 0

extension UITableView {
  var pullToRefreshControl: UIRefreshControl {
    if let rc: AnyObject = objc_getAssociatedObject(self, &UITableViewPrepertyKeyTopRefreshControl) {
      return rc as UIRefreshControl
    } else {
      let rc = UIRefreshControl()
      addSubview(rc)
      objc_setAssociatedObject(self, &UITableViewPrepertyKeyTopRefreshControl, rc, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return rc
    }
  }

  var infiniteScrollControl: InfiniteScrollControl {
    if let infs: AnyObject = objc_getAssociatedObject(self, &UITableViewPrepertyKeyInfiniteScrollControl) {
      return infs as InfiniteScrollControl
    } else {
      let infs = InfiniteScrollControl()
      addSubview(infs)
      objc_setAssociatedObject(self, &UITableViewPrepertyKeyTopRefreshControl, infs, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return infs
    }
  }
}

// MARK: UITextField

private var UITextFieldPropertyKeyTextModifier: UInt8 = 0
private var UITextFieldPropertyKeyTextDynamic: UInt8 = 0

extension UITextField {
  var textModifier: PropertyModifier<String> {
    if let pm: AnyObject = objc_getAssociatedObject(self, &UITextFieldPropertyKeyTextModifier) {
      return pm as PropertyModifier<String>
    } else {
      let pm = PropertyModifier<String> {
        [weak self] v in v
        self?.text = v
      }
      objc_setAssociatedObject(self, &UITextFieldPropertyKeyTextModifier, pm, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return pm
    }
  }

  var textDynamic: Dynamic<String> {
    if let td: AnyObject = objc_getAssociatedObject(self, &UITextFieldPropertyKeyTextDynamic) {
      return td as Dynamic<String>
    } else {
      let td = Dynamic<String>(text)
      td >>> { [weak self] v in v; self?.text = v }
      addTarget(self, action: Selector("valueChanged:"), forControlEvents: .EditingChanged)
      objc_setAssociatedObject(self, &UITextFieldPropertyKeyTextDynamic, td, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return td
    }
  }

  func valueChanged(control: UITextField) {
    textDynamic.value = text
  }
}

extension UITextField: BindableObject {
  typealias DefaultPropertyModifierTargetType = String
  var defaulPropertytModifier: PropertyModifier<DefaultPropertyModifierTargetType> {
    return textModifier
  }
}

extension UITextField: DynamicalObject {
  typealias DefaultDynamicalPropertyType = String
  var defaultDynamicProperty: Dynamic<DefaultDynamicalPropertyType> {
    return textDynamic
  }
}

// MARK: UISlider

private var UISliderPropertyKeyValueModifier: UInt8 = 0
private var UISliderPropertyKeyValueDynamic: UInt8 = 0

extension UISlider {
  var valueModifier: PropertyModifier<Float> {
    if let pm: AnyObject = objc_getAssociatedObject(self, &UISliderPropertyKeyValueModifier) {
      return pm as PropertyModifier<Float>
    } else {
      let pm = PropertyModifier<Float> {
        [weak self] v in v
        self?.value = v
      }
      objc_setAssociatedObject(self, &UISliderPropertyKeyValueModifier, pm, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return pm
    }
  }

  var valueDynamic: Dynamic<Float> {
    if let vd: AnyObject = objc_getAssociatedObject(self, &UISliderPropertyKeyValueDynamic) {
      return vd as Dynamic<Float>
    } else {
      let vd = Dynamic<Float>(value)
      vd >>> { [weak self] v in v; self?.value = v }
      addTarget(self, action: Selector("valueChanged:"), forControlEvents: .ValueChanged)
      objc_setAssociatedObject(self, &UISliderPropertyKeyValueDynamic, vd, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
      return vd
    }
  }

  func valueChanged(control: UISwitch) {
    valueDynamic.value = value
  }
}

extension UISlider: BindableObject {
  typealias DefaultPropertyModifierTargetType = Float
  var defaulPropertytModifier: PropertyModifier<DefaultPropertyModifierTargetType> {
    return valueModifier
  }
}

extension UISlider: DynamicalObject {
  typealias DefaultDynamicalPropertyType = Float
  var defaultDynamicProperty: Dynamic<DefaultDynamicalPropertyType> {
    return valueDynamic
  }
}