//
//  TopBarView.swift
//  BottomSheet
//
//  Created by Yarden Eitan on 11/27/21.
//

import Foundation
import UIKit

protocol TopBarViewDelegate: AnyObject {
  func closeButtonTapped(_ topBarView: TopBarView)
}

class TopBarView: UIView {

  enum Constants {
    static let topHandleFrame = CGRect(x: 0, y: 0, width: 50, height: 4)
    static let topHandleTopInset = 10.0
    static let topHandleColor = UIColor.systemGray5
    static let titleLabelTopInset = 35.0
    static let subtitleLabelTopPadding = 10.0
    static let buttonImageSystemName = "xmark"
    static let buttonImageFont = UIFont.boldSystemFont(ofSize: 14)
  }

  private var topHandle = UIView(frame: Constants.topHandleFrame)
  private var titleLabel = UILabel()
  private var subtitleLabel = UILabel()
  private var closeButton = UIButton(type: .system)

  weak var delegate: TopBarViewDelegate?

  var titleText: String? {
    get {
      titleLabel.text
    }
    set {
      titleLabel.text = newValue
    }
  }

  var subtitleText: String? {
    get {
      subtitleLabel.text
    }
    set {
      subtitleLabel.text = newValue
    }
  }

  var titleFont: UIFont! {
    get {
      titleLabel.font
    }
    set {
      titleLabel.font = newValue
      titleLabel.sizeToFit()
    }
  }

  var subtitleFont: UIFont! {
    get {
      subtitleLabel.font
    }
    set {
      subtitleLabel.font = newValue
      subtitleLabel.sizeToFit()
    }
  }

  var isHandleHidden: Bool {
    get {
      topHandle.isHidden
    }
    set {
      topHandle.isHidden = newValue
    }
  }

  var titleColor: UIColor! {
    get {
      titleLabel.textColor
    }
    set {
      titleLabel.textColor = newValue
    }
  }

  var subtitleColor: UIColor! {
    get {
      subtitleLabel.textColor
    }
    set {
      subtitleLabel.textColor = newValue
    }
  }

  var closeButtonAccessibilityLabel: String? {
    get {
      closeButton.accessibilityLabel
    }
    set {
      closeButton.accessibilityLabel = newValue
    }
  }

  init(titleText: String?, subtitleText: String?) {
    super.init(frame: .zero)

    titleLabel.text = titleText
    subtitleLabel.text = subtitleText
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupSubviews() {
    topHandle.layer.cornerRadius = topHandle.frame.height / 2
    topHandle.backgroundColor = Constants.topHandleColor
    addSubview(topHandle)
    addSubview(titleLabel)
    addSubview(subtitleLabel)

    let closeButtonImage = UIImage(systemName: Constants.buttonImageSystemName, withConfiguration: UIImage.SymbolConfiguration.init(font: Constants.buttonImageFont))
    closeButton.setImage(closeButtonImage, for: .normal)
    closeButton.tintColor = .label
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    addSubview(closeButton)
  }

  override func layoutSubviews() {
    topHandle.center = CGPoint(x: self.center.x, y: Constants.topHandleTopInset)
    titleLabel.sizeToFit()
    titleLabel.center = CGPoint(x: self.center.x, y: Constants.titleLabelTopInset)
    subtitleLabel.sizeToFit()
    subtitleLabel.center = CGPoint(x: self.center.x,
                                   y: self.titleLabel.frame.maxY + Constants.subtitleLabelTopPadding)
    closeButton.sizeToFit()
    closeButton.center = CGPoint(x: self.frame.maxX - closeButton.frame.width - self.directionalLayoutMargins.trailing, y: self.center.y)
  }

  @objc func closeButtonTapped() {
    delegate?.closeButtonTapped(self)
  }
}
