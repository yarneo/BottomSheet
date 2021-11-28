//
//  SheetView.swift
//  BottomSheet
//
//  Created by Yarden Eitan on 11/27/21.
//

import Foundation
import UIKit

class SheetView: UIView {
  var topBarViewDelegate: TopBarViewDelegate? {
    get {
      topBarView.delegate
    } set {
      topBarView.delegate = newValue
    }
  }

  var titleText: String? {
    get {
      topBarView.titleText
    }
    set {
      topBarView.titleText = newValue
    }
  }

  var subtitleText: String? {
    get {
      topBarView.titleText
    }
    set {
      topBarView.titleText = newValue
    }
  }

  var titleFont: UIFont! {
    get {
      topBarView.titleFont
    }
    set {
      topBarView.titleFont = newValue
    }
  }

  var subtitleFont: UIFont! {
    get {
      topBarView.subtitleFont
    }
    set {
      topBarView.subtitleFont = newValue
    }
  }

  var isHandleHidden: Bool {
    get {
      topBarView.isHandleHidden
    }
    set {
      topBarView.isHandleHidden = newValue
    }
  }

  var titleColor: UIColor! {
    get {
      topBarView.titleColor
    }
    set {
      topBarView.titleColor = newValue
    }
  }

  var subtitleColor: UIColor! {
    get {
      topBarView.subtitleColor
    }
    set {
      topBarView.subtitleColor = newValue
    }
  }

  var closeButtonAccessibilityLabel: String? {
    get {
      topBarView.closeButtonAccessibilityLabel
    }
    set {
      topBarView.closeButtonAccessibilityLabel = newValue
    }
  }

  enum Constants {
    static let topBarViewHeight = 80.0
  }

  private let topBarView: TopBarView
  private var contentView: UIView

  init(frame: CGRect, contentView: UIView, titleText: String? = "", subtitleText: String? = "") {
    topBarView = TopBarView(titleText: titleText, subtitleText: subtitleText)
    self.contentView = contentView

    super.init(frame: frame)

    topBarView.backgroundColor = .clear
    topBarView.autoresizingMask = [.flexibleWidth]
    topBarView.frame = self.bounds
    topBarView.frame.size.height = Constants.topBarViewHeight
    addSubview(topBarView)
    addSubview(contentView)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    contentView.frame = CGRect(x: 0, y: topBarView.frame.maxY, width: self.frame.width, height: self.frame.height - topBarView.frame.maxY)

  }
}
