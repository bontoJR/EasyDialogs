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
    1. [Theming](https://github.com/bontoJR/EasyDialogs#theming)
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

![Login](https://raw.githubusercontent.com/bontoJR/EasyDialogs/master/Screens/login.png) 
![Regular](https://raw.githubusercontent.com/bontoJR/EasyDialogs/master/Screens/normal.png) 
![Custom](https://raw.githubusercontent.com/bontoJR/EasyDialogs/master/Screens/custom.png)


--- 

# Project Status

This project is under active development by [@bontoJR](https://twitter.com/bontoJR) and is in a very early stage.

### Roadmap

* [x] Basic builder
* [x] Basic style
* [x] Basic theming
* [x] Document advanced usage
* [ ] Advanced custom theming
* [ ] Cool Animations
* [ ] Elegant loading with transition

---

# Installation

Installation is straightforward with Cocoapods or manually.
If you need Carthage support please take in consideration creating a PR to support it.

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

#### Advanced

Creating an advanced dialog is done in the following way:

```swift
EasyDialog.Builder(self)
    .title(title: "User and Pass") // tag -> 1
    .textField(placeholder: "Username") // tag -> 2
    .textField(placeholder: "Password", secure: true) // tag -> 3
    .view(view: UIActivityIndicatorView(activityIndicatorStyle: .gray)) // tag -> 4
    .positiveButton(title: "Login") { dialog in

    let tfUsername = dialog.view.viewWithTag(2) as! UITextField
    let tfPassword = dialog.view.viewWithTag(3) as! UITextField
    let ai = dialog.view.viewWithTag(4) as! UIActivityIndicatorView

    tfUsername.isUserInteractionEnabled = false
    tfPassword.isUserInteractionEnabled = false

    ai.startAnimating()
    print("\(tfUsername.text ?? "") \(tfPassword.text ?? "")" )

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    dialog.dismiss(animated: true)
    }
    }
    .destructiveButton(title: "Cancel")
    .build()
    .show()
```

Every single time a view is added to the dialog, a tag is assigned in an incremental way starting from 1. So the title view in this case has tag 1, the text field for the username 2, the password 3 and so on. This makes this library pretty flexible and in the previous example, an activity indicator is added to the dialog and is displayed and animated when necessary.

#### Theming

To theme the dialog there are 2 ways:

* Set the default theme `EasyDialog.Builder.defaultTheme = myCustomTheme`
* Pass the theme when building the dialog `EasyDialog.Builder(self, theme: customTheme)`

The first case has to be used to give a style which will be preserved in the application and is the recommended way.
The second case is usually a good alternative when a special dialog requires a different them. It's recommended to not abuse this method, creating different sytles, making the app visually inconsistent.

To theme the Dialog there's a dedicate `struct`:

```swift
public struct Theme {
    let textColor: UIColor
    let titleColor: UIColor
    let titleFont: UIFont
    let textFont: UIFont
    let alertBackgroudColor: UIColor
    let cornerRadius: CGFloat
    let maskViewAlpha: CGFloat
    let separatorColor: UIColor
    let positiveButton: Button
    let destructiveButton: Button
    let regularButton: Button
    
    // [...]

    public struct Button {
        let backgroundColor: UIColor
        let selectedBackgroundColor: UIColor
        let textColor: UIColor
        let font: UIFont
        // [...]
   }
}
```

Buttons have a dedicated structure to enforce modularity and avoid writing repetitive code which usually leads to bugs.

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

