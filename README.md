# EasyDialogs

EasyDialogs is a simple library inspired by [MaterialDialogs for Android](git@github.com:bontoJR/EasyDialogs.git). The main goal is to give a powerful library to create high customizable, but simple, alert views for iOS projects.

[![Cocoapods](https://img.shields.io/cocoapods/v/EasyDialogs.svg)](https://cocoapods.org/pods/EasyDialogs)
[![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)](https://github.com/bontoJR/easydialogs)
[![Xcode](https://img.shields.io/badge/Xcode-8.0-blue.svg)](https://developer.apple.com/xcode)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

# Table of Contents (Core)

1. [Quick Sample](https://github.com/bontoJR/EasyDialogs#quick-sample)
2. [Project Status](https://github.com/bontoJR/EasyDialogs#project-status)
    1. [Roadmap](https://github.com/bontoJR/EasyDialogs#roadmap)
3. [Installation](https://github.com/bontoJR/EasyDialogs#installation)
    1. [Cocoapods](https://github.com/bontoJR/EasyDialogs#cocoapods)
    2. [Carthage](https://github.com/bontoJR/EasyDialogs#carthege)
    3. [Manually](https://github.com/bontoJR/EasyDialogs#manually)
4. [What's New](https://github.com/bontoJR/EasyDialogs#whats-new)
5. [Usage](https://github.com/bontoJR/EasyDialogs#usage)
6. [Contributing](https://github.com/bontoJR/EasyDialogs#contributing)
7. [License](https://github.com/bontoJR/EasyDialogs#license)

------

# Quick Sample

Here's a quick sample of an alert view with two texfields to authenticate a user via username and password.

```swift

EasyDialog.Builder(self)
            .title(title: "Hello World") // tag -> 1
            .textField(placeholder: "Username") // tag -> 2
            .textField(placeholder: "Password", secure: true) // tag -> 3
            .addButton(title: "Ok") { dialog in
                
                let tfUsername = dialog.view.viewWithTag(2) as! UITextField
                let tfPassword = dialog.view.viewWithTag(3) as! UITextField
                
                print("\(tfUsername.text ?? "") \(tfPassword.text ?? "")" )
                
                dialog.dismiss(animated: true)
            }
            .addButton(title: "Cancel") { dialog in
                dialog.dismiss(animated: true)
            }
            .build()
            .show()

```

--- 

# Project Status

This project is under active development by [@bontoJR](https://twitter.com/bontoJR) and is in a very early stage.

### Roadmap

* [x] Basic builder
* [x] Basic style
* [x] Basic theming
* [ ] Document advanced usage
* [ ] Advanced custom theming
* [ ] Cool Animations
* [ ] Elegant loading with transition

---

# Installation

TODO

### Cocoapods

To install using Cocoapods just add this line to you podfile and run `pod install`:

```
pod 'EasyDialogs'
```

### Carthage

Coming Soon...

#### Manually

If you don't want to import this project using Cocoapods or Cartaghe, you can simply import the `EasyDialog.swift` file in your project.

--- 

# Usage

EasyDialogs aims to create a simple and customizable alert view chaining functions and callbacks.
Here's some examples.

#### Simple dialog

This is the code to create a simple dialog with an "Ok" button:

```swift
EasyDialog.Builder(self)
.title(title: "Hello World") // tag -> 1
.text(content: "This is a basic dialog")
.space(ofSize: 4)
.addButton(title: "Ok") { dialog in
dialog.dismiss(animated: true)
}
.build()
.show()
```

#### Rating dialog

Creating a simple rating dialog is pretty simple and looks like this:

```swift
EasyDialog.Builder(self)
.title(title: "Rating") // tag -> 1
.label(text: "If you like this app, please consider rate us.", textAlignment: .center)
.positiveButton(title: "Yes") { dialog in

print("process now")

dialog.dismiss(animated: true)
}
.addButton(title: "Remind me later") { dialog in

print("remind later")

dialog.dismiss(animated: true)
}
.destructiveButton(title: "Not now")
.build()
.show()
```

---

# Contributing

Please feel free to open issues or create pull-requests (on `develop` branch!).
Any kind of constructive contribution is more than welcomed, examples (thanks to [Moya](https://github.com/Moya/Moya) for the list):

* Finding (and reporting!) bugs.
* New feature suggestions.
* Answering questions on issues.
* Documentation improvements.
* Reviewing pull requests.
* Helping to manage issue priorities.
* Fixing bugs/new features.

---

# License

EasyDialogs is released under an MIT license. See [License.md](License.md) for more information.

