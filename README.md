# EasyDialogs

EasyDialogs is a simple library inspired by [MaterialDialogs for Android](git@github.com:bontoJR/EasyDialogs.git). The main goal is to give a powerful library to create high customizable, but simple, alert views for iOS projects.

# Table of Contents (Core)

1. [Quick Sample](https://github.com/bontoJR/EasyDialogs#quick-sample)
2. [Project Status](https://github.com/bontoJR/EasyDialogs#project-status)
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

This project is actively under development and in alpha status.

---

# Installation

TODO

### Cocoapods

### Carthage

#### Manually

--- 

# Usage

TODO

---

# Contributing

TODO

---

# License

EasyDialogs is released under an MIT license. See [License.md](License.md) for more information.

