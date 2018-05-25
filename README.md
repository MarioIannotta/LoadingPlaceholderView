# LoadingPlaceholderView
Animated gradient placeholder with zero effort

[![Platform](http://img.shields.io/badge/platform-ios-red.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Swift 4](https://img.shields.io/badge/Swift-4-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/LoadingPlaceholderView.svg)](https://img.shields.io/cocoapods/v/LoadingPlaceholderView.svg)

| Mixed UI Components | Table View | Collection View |
|--|--|--|
|<img src="https://raw.githubusercontent.com/MarioIannotta/LoadingPlaceholderView/master/ReadmeResources/mixedComponents.gif" height="300"/>|<img src="https://github.com/MarioIannotta/LoadingPlaceholderView/raw/master/ReadmeResources/tableView.gif" height="300"/>|<img src="https://raw.githubusercontent.com/MarioIannotta/LoadingPlaceholderView/master/ReadmeResources/collectionView.gif" height="300"/>|

# Features
- Plug and play
- Supports all UIKit components and it's open to user-defined ones. 
- Supports landscape mode and runtime screen resize
- Highly customizable
- Swift 4 and iOS 9.0+

# How it works
`LoadingPlaceholderView` extracts all the subviews that conforms the protocol `Coverable` from `viewToCover` and then creates an animated gradient layer combining all the `coverablePath` provided by each of those subviews.

# Setup
Add `pod 'LoadingPlaceholderView'` to your Podfile or copy the content of  the `LoadingPlaceholderView` folder into your project

# How to use
1. Create an instance of `LoadingPlaceholderView`

    `let loadingPlaceholderView = LoadingPlaceholderView()`
    
    Usually this would be a property of your view controller.
    
2. Show the view with

    `loadingPlaceholderView.cover(_ viewToCover: UIView, animated: Bool)`
    
3. Hide the view with

    `loadingPlaceholderView.uncover(animated: Bool)`
    
# UITableView/UICollectionView

By design `LoadingPlaceholderView` doesn't interfere with `DataSource` and/or`Delegate` by injecting mocked data but it leaves the resposability to decide what to show and how to the user; in that way unwanted side effects are limited.
 
1. Preload the tableView/collectionView with "mocked" cells.
    `UITableViewCell` and `UICollectionViewCell` already conforms `Coverable`

2. Show the view with
    
    `loadingPlaceholderView.cover(_ viewToCover: UIView, animated: Bool)` 
    
3. Hide the view and refresh the tableView/collectionView
    
    `loadingPlaceholderView.uncover(animated: Bool)`
    `tableView/collectionView.reloadData()`

**Note:**

It is possible to set `coverableCellsIdentifiers` (just for `UITableView`) - in this way the current tableView state will be ignored and the `coverablePath` (and therefore the gradient) is generated using the provided cells identifies. In this way it is possible to skip the first step of the previous list because populating the tableView with mocked cells is no more required.
 
# Customization
You can customize the component behavior by setting the followings properties:

`fadeAnimationDuration: TimeInterval`
>The duration of the animation performed by the methods <br/>
>`cover(_ viewToCover: UIView, animated: Bool = true)`<br/>
>`uncover(animated: Bool = true)`<br/>
> when animated is `true`

`gradientColor: UIColor`
>The main color of the gradient.
>Once it has been set `gradientConfiguration.backgroundColor`, `gradientConfiguration.primaryColor` and `gradientConfiguration.secondaryColor` will be calculated based on this color.

`gradientiConfiguration.width: Double`
> The width of the primary color in the gradient expressed as the percentage of the gradient size.

`gradientiConfiguration.animationDuration: TimeInterval`
>The duration of the animation of the gradient.

`gradientiConfiguration.backgroundColor: UIColor`
>The backgroundColor of the gradient.

`gradientiConfiguration.primaryColor: UIColor`
>The primaryColor of the gradient.

`gradientiConfiguration.secondaryColor: UIColor`
>The secondaryColor of the gradient.

# Demo
In this repository you can also find a demo.

# Info
If you like this git you can follow me here or on twitter :) [@MarioIannotta](http://www.twitter.com/marioiannotta)

Cheers from Italy!
