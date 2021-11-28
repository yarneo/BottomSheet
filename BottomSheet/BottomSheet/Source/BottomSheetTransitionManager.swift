//
//  BottomSheetTransitionManager.swift
//  BottomSheet
//
//  Created by Yarden Eitan on 11/27/21.
//

import Foundation
import UIKit

/// The transition manager used for transitioning and animating the bottom sheet.
/// The manager instantiates a @c BottomSheetPresentationManager in order to present the bottom sheet.
/// After setting the @c UIViewController.transitioningDelegate with an instance of
/// @c BottomSheetTransitionManager of your view controller you wish to present,
/// you can then style your sheet using the @c UIViewController.bottomSheetPresentationController property.
public class BottomSheetTransitionManager: NSObject, UIViewControllerAnimatedTransitioning {

  enum Constants {
    static let transitionDuration = 0.3
    static let animationDampening = 0.85
    static let animationInitialSpring = 0.0
    static let tempFrameHeightIncreaseForAnimation = 50.0
  }

  weak var presentationController: BottomSheetPresentationController?
  private var titleText: String?
  private var subtitleText: String?

  /// The initialization of a @c BottomSheetTransitionManager instance.
  /// Please provide a title text and an optional subtitle text to present in your sheet's top view.
  /// - Parameters:
  ///   - titleText: The text of the title of the sheet's top bar.
  ///   - subtitleText: The text of the subtitle of the sheet's top bar.
  public init(titleText: String, subtitleText: String? = "") {
    super.init()

    self.titleText = titleText
    self.subtitleText = subtitleText
  }

  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return Constants.transitionDuration
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let isPresenting = isPresenting(transitionContext: transitionContext)

    guard let viewController =
            transitionContext.viewController(forKey: isPresenting ? .to : .from)
      else { return }
    guard let view =
            transitionContext.view(forKey: isPresenting ? .to : .from)
      else { return }

    if isPresenting {
      transitionContext.containerView.addSubview(view)
    }

    let presentedFrame = isPresenting ? transitionContext.finalFrame(for: viewController) : view.frame
    var dismissedFrame = presentedFrame
    dismissedFrame.origin.y = transitionContext.containerView.frame.size.height

    let initialFrame = isPresenting ? dismissedFrame : presentedFrame
    let finalFrame = isPresenting ? presentedFrame : dismissedFrame
    let animationDuration = transitionDuration(using: transitionContext)
    view.frame = initialFrame
    UIView.animate(
      withDuration: animationDuration, delay: 0, usingSpringWithDamping: Constants.animationDampening, initialSpringVelocity: Constants.animationInitialSpring, options: [.curveEaseOut, .allowUserInteraction], animations: {
        var tempFinalFrame = finalFrame
        tempFinalFrame.size.height += Constants.tempFrameHeightIncreaseForAnimation
        view.frame = tempFinalFrame
    }, completion: { finished in
      view.frame = finalFrame
      if !isPresenting {
        view.removeFromSuperview()
      }
      transitionContext.completeTransition(finished)
    })
  }

  func isPresenting(transitionContext: UIViewControllerContextTransitioning) -> Bool {
    let fromViewController = transitionContext.viewController(forKey: .from)
    let toPresentingViewController =
        transitionContext.viewController(forKey: .to)?.presentingViewController
    return toPresentingViewController == fromViewController
  }
}

extension BottomSheetTransitionManager: UIViewControllerTransitioningDelegate {

  public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    self.presentationController = presentationController
    presentationController.titleText = titleText
    presentationController.subtitleText = subtitleText
    return presentationController
  }

  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }

  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }
}
