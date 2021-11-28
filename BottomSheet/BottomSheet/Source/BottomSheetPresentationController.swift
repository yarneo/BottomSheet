//
//  BottomSheetPresentationController.swift
//  BottomSheet
//
//  Created by Yarden Eitan on 11/27/21.
//

import Foundation
import UIKit

/// The state the bottom sheet is currently in.
public enum SheetState {
  case dismissed
  case collapsed
  case expanded
}

/// A UIViewController extension to easily access the bottom sheet presentation controller and style it.
public extension UIViewController {
  var bottomSheetPresentationController: BottomSheetPresentationController? {
    get {
      if let bottomSheetPresentationController = self.presentationController as? BottomSheetPresentationController {
        return bottomSheetPresentationController
      }
      return nil
    }
  }
}

/// The protocol to track when the sheet state updates.
public protocol BottomSheetPresentationControllerDelegate: AnyObject {
  func bottomSheetPresentationControllerWillChangeState(_ bottomSheetPresentationController: BottomSheetPresentationController, sheetState: SheetState)
  func bottomSheetPresentationControllerDidChangeState(_ bottomSheetPresentationController: BottomSheetPresentationController, sheetState: SheetState)
}

/// The bottom sheet presentation controller in charge of presenting your content via a sheet that slides up and can appear in
/// 3 different visual states. See @c SheetState for the possible states.
/// You can drag the sheet between the different states and by lowering it to the bottom you will automatically dismiss it.
///
/// To access and style the sheet please access the sheet via the @c bottomSheetPresentationController
/// variable in your UIViewController instance.
public class BottomSheetPresentationController: UIPresentationController {

  /// The delegate that tracks when the sheet state has changed.
  public weak var bottomSheetPresentationControllerDelegate: BottomSheetPresentationControllerDelegate?

  /// The tracking scroll view needs to be provided if you have a scrollable view that you don't want its scrolling gesture to interfere with the dragging of the sheet.
  /// By providing a tracking scroll view, there is logic to allow scrolling of your scrollable view when relevant and dragging the sheet itself where relevant.
  public var trackingScrollView: UIScrollView?

  /// The text of the title in the top bar of the sheet.
  ///
  /// This variable can also be provided via the @c BottomSheetTransitionManager.init(titleText, subtitleText) initializer.
  public var titleText: String? {
    didSet {
      guard self.containerView != nil else {
        return
      }
      sheetView.titleText = titleText
    }
  }

  /// The text of the subtitle in the top bar of the sheet.
  ///
  /// This variable can also be provided via the @c BottomSheetTransitionManager.init(titleText, subtitleText) initializer.
  public var subtitleText: String? {
    didSet {
      guard self.containerView != nil else {
        return
      }
      sheetView.subtitleText = subtitleText
    }
  }

  /// The font of the title in the top bar of the sheet.
  ///
  /// Defaults to a system bold font of size 20.
  public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 20) {
    didSet {
      guard self.containerView != nil else {
        return
      }
      sheetView.titleFont = titleFont
    }
  }

  /// The font of the subtitle in the top bar of the sheet.
  ///
  /// Defaults to a system bold font of size 14.
  public var subtitleFont: UIFont = UIFont.boldSystemFont(ofSize: 14) {
    didSet {
      guard self.containerView != nil else {
        return
      }
      sheetView.subtitleFont = subtitleFont
    }
  }

  /// The visibility of the handle in the top bar of the sheet.
  ///
  /// Defults to false.
  public var isHandleHidden: Bool! = false {
    didSet {
      guard self.containerView != nil else {
        return
      }
      sheetView.isHandleHidden = isHandleHidden
    }
  }

  /// The color of the title in the top bar of the sheet.
  ///
  /// Defaults to UIColor.label
  public var titleColor: UIColor = .label {
    didSet {
      guard self.containerView != nil else {
        return
      }
      sheetView.titleColor = titleColor
    }
  }

  /// The color of the subtitle in the top bar of the sheet.
  ///
  /// Defaults to UIColor.secondaryLabel
  public var subtitleColor: UIColor = .secondaryLabel {
    didSet {
      guard self.containerView != nil else {
        return
      }
      sheetView.subtitleColor = subtitleColor
    }
  }

  /// The accessibility label of the top bar's close button.
  ///
  /// Defaults to "Dismiss Sheet".
  public var closeButtonAccessibilityLabel: String = "Dismiss Sheet" {
    didSet {
      guard self.containerView != nil else {
        return
      }
      sheetView.closeButtonAccessibilityLabel = closeButtonAccessibilityLabel
    }
  }

  /// The color of the scrim behind the presented sheet.
  ///
  /// Defaults to black with different opacities (Light: 0.12, Dark: 0.29) depending on the user interface style.
  public var scrimColor: UIColor = UIColor {
        (traitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .dark ?
        .black.withAlphaComponent(0.29) : .black.withAlphaComponent(0.12) } {
    didSet {
      guard self.containerView != nil else {
        return
      }
      scrimView.backgroundColor = scrimColor
    }
  }

  /// The background color of the top bar view of the sheet.
  public var topBarViewColor: UIColor = .systemBackground {
    didSet {
      guard self.containerView != nil else {
        return
      }
      sheetView.backgroundColor = topBarViewColor
    }
  }

  /// The accessibility label of the scrim behind the presented sheet.
  /// This view can be focused by accessibility users in order to dismiss the sheet.
  ///
  /// Defaults to "Dismiss Sheet"
  public var scrimAccessibilityLabel: String = "Dismiss Sheet" {
    didSet {
      guard self.containerView != nil else {
        return
      }
      scrimView.accessibilityLabel = scrimAccessibilityLabel
    }
  }

  /// Sets the top corner radii of the sheet for the provided state.
  ///
  /// If there is differences in values between the corner radii of the states,
  /// the corner radii will animate to the new value as the state changes.
  ///
  /// - Parameters:
  ///   - cornerRadii: The top corners' radius.
  ///   - state: The sheet state in which to update the corner radius value.
  public func setTopCornerRadii(_ cornerRadii: CGFloat, for state: SheetState) {
    topCornerRadii[state] = cornerRadii
    guard self.containerView != nil else {
      return
    }
    if sheetState == state {
      presentedView?.layer.cornerRadius = cornerRadii
    }
  }

  /// Returns the corner radius values for the given state.
  ///
  /// Defaults to 16 for all states.
  /// - Parameter state: The sheet's state.
  /// - Returns: The value of the top corners' radius for the given state.
  public func topCornerRadii(for state: SheetState) -> CGFloat {
    topCornerRadii[state] ?? 16
  }

  /// A read-only presentation of the current sheet state (collapsed, expanded, dismissed).
  public var sheetState: SheetState {
    get {
      return _sheetState
    }
  }

  private var topCornerRadii: [SheetState: CGFloat] = [.dismissed: 16, .collapsed: 16, .expanded: 16]

  private var _sheetState: SheetState = .dismissed {
    didSet {
      bottomSheetPresentationControllerDelegate?.bottomSheetPresentationControllerDidChangeState(self, sheetState: sheetState)
    }
  }

  enum Constants {
    static let expandedSheetTopInset: CGFloat = 50.0
    static let sheetToStateAnimationDuration = 0.25
    static let sheetToStateAnimationDampening = 0.7
    static let sheetToStateAnimationInitialSpring = 0.0
  }

  private lazy var scrimView: UIView = { () -> UIView in
    guard let containerView = containerView else {
      return UIView()
    }
    let view = UIView(frame: containerView.bounds)
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.backgroundColor = scrimColor
    view.accessibilityLabel = scrimAccessibilityLabel
    view.accessibilityTraits = [.button]
    view.alpha = 0

    let recognizer = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTap(recognizer:)))
    view.addGestureRecognizer(recognizer)
    return view
  }()

  private lazy var sheetView: SheetView = { () -> SheetView in
    guard let containerView = containerView else {
      return SheetView(frame: .zero, contentView: self.presentedViewController.view)
    }
    let sheetView = SheetView(frame: containerView.bounds, contentView: self.presentedViewController.view, titleText: titleText, subtitleText: subtitleText)
    configureSheetView(sheetView: sheetView)
    return sheetView
  }()

  private lazy var panGesture: UIPanGestureRecognizer = {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(recognizer:)))
    gestureRecognizer.delegate = self
    return gestureRecognizer
  }()

  func configureSheetView(sheetView: SheetView) {
    sheetView.titleFont = titleFont
    sheetView.titleColor = titleColor
    sheetView.subtitleFont = subtitleFont
    sheetView.subtitleColor = subtitleColor
    sheetView.isHandleHidden = isHandleHidden
    sheetView.closeButtonAccessibilityLabel = closeButtonAccessibilityLabel
    sheetView.backgroundColor = topBarViewColor
    sheetView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  // MARK: - Superclass overrides.

  public override var frameOfPresentedViewInContainerView: CGRect {
    return sheetAtTopFrame()
  }

  public override var presentedView: UIView? {
    return self.sheetView
  }

  public override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()

    presentedView?.addGestureRecognizer(panGesture)
    sheetView.topBarViewDelegate = self
  }

  public override func presentationTransitionWillBegin() {
    containerView?.addSubview(scrimView)
    containerView?.addSubview(sheetView)

    bottomSheetPresentationControllerDelegate?.bottomSheetPresentationControllerWillChangeState(self, sheetState: .expanded)

    guard let coordinator = presentedViewController.transitionCoordinator else {
      scrimView.alpha = 1
      presentedView?.layer.cornerRadius = topCornerRadii(for: .expanded)
      return
    }

    coordinator.animate(alongsideTransition: { _ in
      self.scrimView.alpha = 1
      self.presentedView?.layer.cornerRadius = self.topCornerRadii(for: .expanded)
    })

  }

  public override func presentationTransitionDidEnd(_ completed: Bool) {
    if completed {
      _sheetState = .expanded
    }
  }

  public override func dismissalTransitionWillBegin() {
    bottomSheetPresentationControllerDelegate?.bottomSheetPresentationControllerWillChangeState(self, sheetState: .dismissed)

    guard let coordinator = presentedViewController.transitionCoordinator else {
      scrimView.alpha = 0
      presentedView?.layer.cornerRadius = topCornerRadii(for: .dismissed)
      return
    }

    coordinator.animate(alongsideTransition: { _ in
      self.scrimView.alpha = 0
      self.presentedView?.layer.cornerRadius = self.topCornerRadii(for: .dismissed)
    })
  }

  public override func dismissalTransitionDidEnd(_ completed: Bool) {
    if completed {
      _sheetState = .dismissed
    }
  }

  public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    coordinator.animate(alongsideTransition: { _ in
      switch self.sheetState {
      case .dismissed:
        return
      case .collapsed:
        self.presentedView?.frame = self.sheetAtMidFrame()
      case .expanded:
        self.presentedView?.frame = self.sheetAtTopFrame()
      }
    }, completion: nil)
    self.presentedView?.layoutIfNeeded()
  }

  public override func accessibilityPerformEscape() -> Bool {
    presentingViewController.dismiss(animated: true)
    return true
  }

  // MARK: - Helper frame adjustment.

  func sheetAtTopFrame() -> CGRect {
    guard let containerView = containerView else {
      return .zero
    }
    return CGRect(x: 0.0, y: Constants.expandedSheetTopInset, width: containerView.bounds.width, height: containerView.bounds.height - Constants.expandedSheetTopInset)
  }

  func sheetAtMidFrame() -> CGRect {
    guard let containerView = containerView, let presentedView = presentedView else {
      return .zero
    }
    return CGRect(x: 0.0, y: Constants.expandedSheetTopInset + (presentedView.frame.height / 2), width: containerView.bounds.width, height: containerView.bounds.height - Constants.expandedSheetTopInset)
  }
}

extension BottomSheetPresentationController: UIGestureRecognizerDelegate, TopBarViewDelegate {
  // MARK: - Touch handling.

  @objc func handleTap(recognizer: UITapGestureRecognizer) {
    presentingViewController.dismiss(animated: true)
  }

  @objc func handleDrag(recognizer: UIPanGestureRecognizer) {
    guard let presentedView = presentedView, let containerView = containerView else {
      return
    }

    let sheetHeight = presentedView.frame.height
    let position = presentedView.convert(containerView.frame, to: nil).origin.y - Constants.expandedSheetTopInset
    let positionPercentage = position / sheetHeight
    switch recognizer.state {
    case .changed:
      scrimView.alpha = 1 - positionPercentage
      let translation = recognizer.translation(in: containerView).y
      let newY = presentedView.center.y + translation
      if presentedView.frame.maxY + translation <= containerView.frame.height && translation <= 0 {
        let resistantTranslation = sqrt(abs(translation))
        let translationSign: CGFloat = translation < 0 ? -1 : 1
        presentedView.frame = CGRect(x: 0, y: presentedView.frame.origin.y + (resistantTranslation * translationSign), width: containerView.frame.width, height: presentedView.frame.height - (resistantTranslation * translationSign))
      } else {
        presentedView.center = CGPoint(x: presentedView.center.x, y: newY)
      }
      recognizer.setTranslation(.zero, in: presentedView)
    case .ended:
      if positionPercentage < 0 || positionPercentage < 0.25 {
        bottomSheetPresentationControllerDelegate?.bottomSheetPresentationControllerWillChangeState(self, sheetState: .expanded)
        UIView.animate(
          withDuration: Constants.sheetToStateAnimationDuration, delay: 0, usingSpringWithDamping: Constants.sheetToStateAnimationDampening, initialSpringVelocity: Constants.sheetToStateAnimationInitialSpring, options: [.curveEaseInOut], animations: {
            presentedView.frame = self.sheetAtTopFrame()
            presentedView.frame.size.height += BottomSheetTransitionManager.Constants.tempFrameHeightIncreaseForAnimation
            presentedView.layoutIfNeeded()
            self.scrimView.alpha = 1
            presentedView.layer.cornerRadius = self.topCornerRadii(for: .expanded)
        }, completion: { completed in
          if completed {
            presentedView.frame = self.sheetAtTopFrame()
            self._sheetState = .expanded
          }
        })
      } else if positionPercentage < 0.5 || (positionPercentage > 0.5 && positionPercentage < 0.67) {
        bottomSheetPresentationControllerDelegate?.bottomSheetPresentationControllerWillChangeState(self, sheetState: .collapsed)
        UIView.animate(
          withDuration: Constants.sheetToStateAnimationDuration, delay: 0, usingSpringWithDamping: Constants.sheetToStateAnimationDampening, initialSpringVelocity: Constants.sheetToStateAnimationInitialSpring, options: [.curveEaseInOut], animations: {
            presentedView.frame = self.sheetAtMidFrame()
            presentedView.layoutIfNeeded()
            self.scrimView.alpha = 0.5
            presentedView.layer.cornerRadius = self.topCornerRadii(for: .collapsed)
        }, completion: { completed in
          if completed {
            self._sheetState = .collapsed
          }
        })
      } else {
        presentingViewController.dismiss(animated: true)
      }
    default:
      return
    }
  }

  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if otherGestureRecognizer == trackingScrollView?.panGestureRecognizer {
      return true
    }
    return false
  }

  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let trackingScrollView = trackingScrollView, let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
      return true
    }
    let velocity = panRecognizer.velocity(in: containerView)

    switch sheetState {
    case .expanded:
      if trackingScrollView.contentOffset.y <= trackingScrollView.contentInset.top && velocity.y > 0 {
        // cancel the ongoing gesture.
        trackingScrollView.panGestureRecognizer.isEnabled = false
        trackingScrollView.panGestureRecognizer.isEnabled = true
        return true
      }
      return false
    case .collapsed:
      // cancel the ongoing gesture.
      trackingScrollView.panGestureRecognizer.isEnabled = false
      trackingScrollView.panGestureRecognizer.isEnabled = true
      return true
    case .dismissed:
      return false
    }
  }

  func closeButtonTapped(_ topBarView: TopBarView) {
    presentingViewController.dismiss(animated: true)
  }
}
