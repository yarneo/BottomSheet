# BottomSheet

This repository showcases a Bottom Sheet implementaiton using Swift.

All of the Bottom Sheet code lies under the BottomSheet/Source directory.
Outside of that directory is a simple example app that presents the bottom sheet in various different ways:
* A collection view list configuration in a bottom sheet.
* A scroll view with text in a bottom sheet.
* Random fun squares that randomly generate in a bottom sheet.

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
