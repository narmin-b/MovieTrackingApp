//
//  Router.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 08.02.25.
//

import Foundation
import UIKit.UIViewController

public protocol Router: AnyObject {
  var navigation: UINavigationController { get }
  var last: UIViewController { get }
  func present(_ viewController: UIViewController, animated: Bool)
  func present(_ viewController: UIViewController, animated: Bool,
               onDismissed: (() -> Void)?)
  func presentModally(_ viewController: UIViewController, animated: Bool,
                      onDismissed: (() -> Void)?)
  func pop(animated: Bool)
  func clear()
}

extension Router {
  public func present(_ viewController: UIViewController, animated: Bool) {
    present(viewController, animated: animated, onDismissed: nil)
  }
  
  public func presentModally(_ viewController: UIViewController, animated: Bool,
                             onDismissed: (() -> Void)?) {}
  public func pop(animated: Bool) {}
  public func clear() {}
}
