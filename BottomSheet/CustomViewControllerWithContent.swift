//
//  CustomViewControllerWithContent.swift
//  BottomSheet
//
//  Created by Yarden Eitan on 11/27/21.
//

import Foundation
import UIKit

class CustomViewControllerWithContent: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    generateRandomSquares(number: 20, size: view.frame.size)
  }

  func generateRandomSquares(number: Int, size: CGSize) {
    for _ in 0..<number {
      let randomSize = CGFloat.random(in: 30..<100)
      let square = UIView(frame: CGRect(x: CGFloat.random(in: 0..<size.width), y: CGFloat.random(in: 0..<size.height), width: randomSize, height: randomSize))
      square.backgroundColor = .random()
      view.addSubview(square)
    }
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    for v in view.subviews {
      v.removeFromSuperview()
    }
    generateRandomSquares(number: 20, size: size)
  }
}

extension UIColor {
  static func random() -> UIColor {
    return UIColor(
      red: CGFloat.random(in: 0..<1),
      green: CGFloat.random(in: 0..<1),
      blue: CGFloat.random(in: 0..<1),
      alpha: 1.0
    )
  }
}
