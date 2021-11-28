//
//  CustomViewControllerWithCollectionView.swift
//  BottomSheet
//
//  Created by Yarden Eitan on 11/27/21.
//

import Foundation
import UIKit

class CustomViewControllerWithCollectionView: UIViewController, UICollectionViewDelegate {
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

  enum Section {
    case main
  }

  struct Item: Hashable {
    let title: String

    init(title: String) {
      self.title = title
    }
  }

  lazy var collectionView: UICollectionView = {
    var config = UICollectionLayoutListConfiguration(appearance: .plain)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout.list(using: config))
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return collectionView
  }()

  lazy var dataSource = {
    return DataSource(collectionView: collectionView) {
      collectionView, indexPath, item -> UICollectionViewCell? in
      return collectionView.dequeueConfiguredReusableCell(
        using: self.cellRegistration, for: indexPath, item: item)
    }
  }()

  let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, _, item in
    var configuration = cell.defaultContentConfiguration()
    configuration.text = item.title
    cell.contentConfiguration = configuration
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.frame = view.bounds
    collectionView.delegate = self
    view.addSubview(collectionView)
    applyInitialSnapshots()
  }

  func applyInitialSnapshots() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

    var exampleItems = [Item]()
    for i in 0..<40 {
      exampleItems.append(Item(title: "Item #\(i)"))
    }
    snapshot.appendSections([.main])
    snapshot.appendItems(exampleItems, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)

    self.bottomSheetPresentationController?.titleText = "Updated Text"
    self.bottomSheetPresentationController?.subtitleText = "Updated Subtitle Text"
    self.bottomSheetPresentationController?.titleColor = .red
    self.bottomSheetPresentationController?.subtitleColor = .blue
    self.bottomSheetPresentationController?.titleFont = UIFont.systemFont(ofSize: 30)
    self.bottomSheetPresentationController?.subtitleFont = UIFont.systemFont(ofSize: 14)
    self.bottomSheetPresentationController?.isHandleHidden = true
    self.bottomSheetPresentationController?.scrimColor = .green.withAlphaComponent(0.5)
    self.bottomSheetPresentationController?.topBarViewColor = .lightGray
    self.bottomSheetPresentationController?.setTopCornerRadii(40, for: .expanded)
  }
}
