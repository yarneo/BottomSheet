# BottomSheet

This repository showcases a Bottom Sheet implementaiton using Swift.

All of the Bottom Sheet code lies under the BottomSheet/Source directory.
Outside of that directory is a simple example app that presents the bottom sheet in various different ways:
* A collection view list configuration in a bottom sheet.
* A scroll view with text in a bottom sheet.
* Random fun squares that randomly generate in a bottom sheet.

## Setup
Most of the public API lives under `BottomSheetPresentationController.swift`.
To set up your view controller to present as a bottom sheet you need to instantiate a `BottomSheetTransitionManager` as your view controller's `transitioningDelegate`.
You will need to provide at least title text so your bottom sheet will look reasonable as it consists of a top bar with a title.

After that set your view controller's `modalPresentationStyle` to `.custom`.

Then you can access your bottom sheet's styling/customization APIs through its presentation controller. The presentation controller can be accessed through your view controller by calling its `bottomSheetPresentationController` property.

## Simple Integration

```swift
let transitioningDelegate = BottomSheetTransitionManager(titleText: "Title text", subtitleText: "Subtitle text")
let vc = MyCoolViewControllerIWantToPresent()
vc.modalPresentationStyle = .custom
vc.transitioningDelegate = transitioningDelegate
if let bottomSheet = vc.bottomSheetPresentationController {
  bottomSheet.bottomSheetPresentationControllerDelegate = self
  bottomSheet.titleColor = .blue
  ...
}
present(vc, animated: true, completion: nil)
```
