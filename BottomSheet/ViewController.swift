//
//  ViewController.swift
//  BottomSheet
//
//  Created by Yarden Eitan on 11/27/21.
//

import UIKit

class ViewController: UIViewController, BottomSheetPresentationControllerDelegate {
  let topButton = UIButton(type: .system)
  let midButton = UIButton(type: .system)
  let bottomButton = UIButton(type: .system)

  override func viewDidLoad() {
    super.viewDidLoad()

    topButton.setTitle("Bottom sheet with a collection view", for: .normal)
    topButton.addTarget(self, action: #selector(didTapTop), for: .touchUpInside)
    topButton.sizeToFit()
    view.addSubview(topButton)

    midButton.setTitle("Bottom sheet with a scroll view", for: .normal)
    midButton.addTarget(self, action: #selector(didTapMid), for: .touchUpInside)
    midButton.sizeToFit()
    view.addSubview(midButton)

    bottomButton.setTitle("Bottom sheet with a view", for: .normal)
    bottomButton.addTarget(self, action: #selector(didTapBottom), for: .touchUpInside)
    bottomButton.sizeToFit()
    view.addSubview(bottomButton)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    topButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 50)
    midButton.center = self.view.center
    bottomButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 50)

  }

  @objc func didTapTop() {
    let transitioningDelegate = BottomSheetTransitionManager(titleText: "Scrollable List", subtitleText: "Custom CollectionView example")
    let vc = CustomViewControllerWithCollectionView()
    vc.modalPresentationStyle = .custom
    vc.transitioningDelegate = transitioningDelegate
    if let bottomSheet = vc.bottomSheetPresentationController {
      bottomSheet.bottomSheetPresentationControllerDelegate = self
      bottomSheet.trackingScrollView = vc.collectionView
    }
    present(vc, animated: true)
  }

  @objc func didTapMid() {
    let transitioningDelegate = BottomSheetTransitionManager(titleText: "Scrollable Text", subtitleText: "Custom ScrollView example")
    let vc = CustomViewControllerWithScrollView()
    vc.modalPresentationStyle = .custom
    vc.transitioningDelegate = transitioningDelegate
    if let bottomSheet = vc.bottomSheetPresentationController {
      bottomSheet.bottomSheetPresentationControllerDelegate = self
      bottomSheet.trackingScrollView = vc.scrollView
    }
    present(vc, animated: true, completion: nil)
  }

  @objc func didTapBottom() {
    let transitioningDelegate = BottomSheetTransitionManager(titleText: "Non Scrollable Content", subtitleText: "Custom content example")
    let vc = CustomViewControllerWithContent()
    vc.modalPresentationStyle = .custom
    vc.transitioningDelegate = transitioningDelegate
    if let bottomSheet = vc.bottomSheetPresentationController {
      bottomSheet.bottomSheetPresentationControllerDelegate = self
    }
    present(vc, animated: true, completion: nil)
  }

  func bottomSheetPresentationControllerWillChangeState(_ bottomSheetPresentationController: BottomSheetPresentationController, sheetState: SheetState) {
    print("Bottom sheet will change state to: \(sheetState)")
  }

  func bottomSheetPresentationControllerDidChangeState(_ bottomSheetPresentationController: BottomSheetPresentationController, sheetState: SheetState) {
    print("Bottom sheet did change state to: \(sheetState)")
  }
}
