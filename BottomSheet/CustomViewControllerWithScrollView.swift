//
//  CustomViewControllerWithScrollView.swift
//  BottomSheet
//
//  Created by Yarden Eitan on 11/27/21.
//

import Foundation
import UIKit

class CustomViewControllerWithScrollView: UIViewController {
  let scrollView = UIScrollView()
  let contentView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupScrollView()
    setupViews()
  }

  func setupScrollView() {
    scrollView.backgroundColor = .systemBackground
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
  }

  let label: UILabel = {
    let label = UILabel()
    label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque velit purus, sodales eu nisi sed, pretium consectetur mauris. Mauris tincidunt eu orci quis aliquam. Pellentesque facilisis at risus semper faucibus. Morbi id mauris tellus. Proin aliquam ex quis neque gravida fermentum. Nunc ut pretium libero. Curabitur eu nisl eget nunc semper sollicitudin. Nulla facilisi. Quisque turpis dui, vehicula vitae ex in, ultrices ultrices urna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas dictum scelerisque nulla bibendum dictum. Fusce venenatis at libero ac consequat. Sed aliquam neque libero, non consequat tortor pellentesque nec. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi et nulla ipsum. Mauris vel dictum dui. Cras condimentum diam vitae auctor viverra. Curabitur sed magna blandit, efficitur ex at, rutrum metus. Integer egestas lectus vel dolor convallis, eu ultrices erat tincidunt. Fusce vehicula pellentesque tempus. Aliquam porta ut libero id finibus. Praesent eget lacus sollicitudin, tristique eros vel, pellentesque turpis. Aliquam erat volutpat. Sed scelerisque imperdiet nulla, nec scelerisque lorem hendrerit non. Praesent porttitor ac mauris non posuere. Nullam congue fringilla lacus, non auctor sapien scelerisque sit amet. Suspendisse condimentum blandit vehicula. Praesent accumsan nibh a nibh pharetra lacinia. Etiam bibendum tortor quis placerat sodales. Etiam quis convallis mi, at suscipit justo. Vestibulum sed tristique enim, non condimentum purus. Pellentesque tempus dolor vitae elit bibendum, sit amet ornare libero lacinia. Integer mollis, ante eu pulvinar finibus, diam enim vestibulum urna, et consectetur sapien lorem quis enim. Pellentesque imperdiet lorem erat, sit amet finibus tortor bibendum vitae. Vivamus eleifend tempor sagittis. Nam libero velit, venenatis nec diam sed, imperdiet aliquam ex. Mauris suscipit lacus enim, nec egestas dui suscipit at. In semper dictum sem, a tincidunt sapien feugiat posuere. Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    label.numberOfLines = 0
    label.sizeToFit()
    label.textColor = .label
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  func setupViews() {
    contentView.addSubview(label)
    label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
    label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  }

}
