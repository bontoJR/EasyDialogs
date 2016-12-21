//
//  EasyDialogs.swift
//  EasyDialogs
//
//  Created by Junior B. on 12.12.16.
//  Copyright © 2016 Bonto.ch.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import UIKit

fileprivate func colorFromDecimalRGB(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(
        red: red / 255.0,
        green: green / 255.0,
        blue: blue / 255.0,
        alpha: alpha
    )
}

fileprivate enum Side {
    case top
    case left
    case bottom
    case right
}

fileprivate func applyLine(to view: UIView, on side: Side, color: UIColor = UIColor.lightGray) {
    let line = UIView(frame: .zero)
    line.backgroundColor = color
    line.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(line)
    
    switch side {
    case .top:
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            line.heightAnchor.constraint(equalToConstant: 0.5)])
    case .right:
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            line.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            line.widthAnchor.constraint(equalToConstant: 0.5)])
    case .bottom:
        NSLayoutConstraint.activate([
            line.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            line.heightAnchor.constraint(equalToConstant: 0.5)])
    case .left:
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            line.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            line.widthAnchor.constraint(equalToConstant: 0.5)])
    }
}

public class EasyDialog: UIViewController {
    
    struct Theme {
        let titleFont: UIFont = UIFont.boldSystemFont(ofSize: 18.0)
        let alertBackgroudColor = colorFromDecimalRGB(245, green: 245, blue: 245)
        let cornerRadius: CGFloat = 15.0
        let maskViewAlpha: CGFloat = 0.6
        let separatorColor: UIColor = UIColor.lightGray
        let positiveButtonBackgroundColor: UIColor = colorFromDecimalRGB(245, green: 245, blue: 245)
        let positiveButtonSelectedBackgroundColor: UIColor = colorFromDecimalRGB(230, green: 230, blue: 230)
        let positiveButtonTextColor: UIColor = colorFromDecimalRGB(19, green: 144, blue: 255)
        let positiveButtonFont: UIFont = UIFont.boldSystemFont(ofSize: 16.0)
        let destructiveButtonBackgroundColor: UIColor = colorFromDecimalRGB(245, green: 245, blue: 245)
        let destructiveButtonSelectedBackgroundColor: UIColor = colorFromDecimalRGB(230, green: 230, blue: 230)
        let destructiveButtonTextColor: UIColor = colorFromDecimalRGB(255, green: 59, blue: 48)
        let destructiveButtonFont: UIFont = UIFont.systemFont(ofSize: 16.0)
        let regularButtonBackgroundColor: UIColor = colorFromDecimalRGB(245, green: 245, blue: 245)
        let regularButtonSelectedBackgroundColor: UIColor = colorFromDecimalRGB(230, green: 230, blue: 230)
        let regularButtonTextColor: UIColor = colorFromDecimalRGB(19, green: 144, blue: 255)
        let regularButtonFont: UIFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    private class ActionWrapper {
        weak var sender: UIControl?
        let action: (EasyDialog) -> ()
        weak var dialog: EasyDialog? = nil
        
        init(sender: UIControl, action: @escaping (EasyDialog) -> (), event: UIControlEvents = .touchUpInside) {
            self.sender = sender
            self.action = action
            sender.addTarget(self, action: #selector(actionPerformed), for: event)
        }
        
        @objc private func actionPerformed() {
            guard let dialog = dialog else {
                fatalError("Something went wrong creating this dialog and the callback can't be performed")
            }
            
            action(dialog)
        }
    }
    
    public class Builder {
        
        enum ButtonType {
            case destructive
            case positive
            case regular
        }
        
        static var defaultTheme = Theme()
        
        /// The view controller to display the alert view
        weak var targetViewController: UIViewController?
        
        let theme: Theme
        
        private var views = [UIView]()
        private var buttons = [UIButton]()
        private var actions = [ActionWrapper]()
        
        init(_ viewController: UIViewController, theme: Theme = defaultTheme) {
            targetViewController = viewController
            self.theme = theme
        }
        
        /// Set the title of the dialog
        func title(title: String) -> Self {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.font = theme.titleFont
            views.append(label)
            return self
        }
        
        /// Set the title of the dialog
        func text(content: String) -> Self {
            return label(text: content, textAlignment: .center)
        }
        
        func label(text: String, textAlignment: NSTextAlignment = .left) -> Self {
            let label = UILabel()
            label.text = text
            label.textAlignment = textAlignment
            label.numberOfLines = 0
            views.append(label)
            return self
        }
        
        func textField(tag: Int? = nil, placeholder: String? = nil, content: String? = nil, keyboardType: UIKeyboardType = .default, secure: Bool = false) -> Self {
            let textField = UITextField()
            textField.placeholder = placeholder
            textField.text = content
            textField.keyboardType = keyboardType
            textField.isSecureTextEntry = secure
            if let tag = tag {
                textField.tag = tag
            }
            applyLine(to: textField, on: .bottom)
            views.append(textField)
            return self
        }
        
        func addButton(tag: Int? = nil, title: String, type: ButtonType = .regular, callback: ((EasyDialog) -> ())?) -> Self {
            let button = UIButton(type: .custom)
            if let t = tag {
                button.tag = t
            }
            
            button.setTitle(title, for: .normal)
            
            switch type {
            case .regular:
                button.setBackgroundImage(UIImage.imageWithColor(tintColor: theme.regularButtonSelectedBackgroundColor), for: .highlighted)
                button.setTitleColor(theme.regularButtonTextColor, for: .normal)
                button.titleLabel?.font = theme.regularButtonFont
                button.backgroundColor = theme.regularButtonBackgroundColor
            case .destructive:
                button.setBackgroundImage(UIImage.imageWithColor(tintColor: theme.destructiveButtonSelectedBackgroundColor), for: .highlighted)
                button.setTitleColor(theme.destructiveButtonTextColor, for: .normal)
                button.titleLabel?.font = theme.destructiveButtonFont
                button.backgroundColor = theme.destructiveButtonBackgroundColor
            case .positive:
                button.setBackgroundImage(UIImage.imageWithColor(tintColor: theme.regularButtonSelectedBackgroundColor), for: .highlighted)
                button.setTitleColor(theme.positiveButtonTextColor, for: .normal)
                button.titleLabel?.font = theme.positiveButtonFont
                button.backgroundColor = theme.positiveButtonBackgroundColor
            }
            
            
            
            if let cb = callback {
                actions.append(ActionWrapper(sender: button, action: cb))
            }
            buttons.append(button)
            return self
        }
        
        func space(ofSize size: CGFloat = 12.0) -> Self {
            let view = UIView()
            view.heightAnchor.constraint(equalToConstant: size).isActive = true
            views.append(view)
            return self
        }
        
        // MARK: Convenience Methods
        
        func destructiveButton(title: String = "Cancel", animated: Bool = true) -> Self {
            return addButton(title: title, type: .destructive) { dialog in
                dialog.dismiss(animated: animated)
            }
        }
        
        func positiveButton(title: String = "Cancel", animated: Bool = true, callback: @escaping ((EasyDialog) -> ())) -> Self {
            return addButton(title: title, type: .positive, callback: callback)
        }
        
        // MARK: Buiding
        
        public func build() -> EasyDialog {
            let dialog = EasyDialog()
            dialog.builder = self
            dialog.view.backgroundColor = UIColor(white: 0, alpha: theme.maskViewAlpha)
            
            dialog.modalPresentationStyle = .overCurrentContext
            dialog.modalTransitionStyle = .crossDissolve
            
            let baseView = UIView()
            dialog.view.addSubview(baseView)
            
            baseView.backgroundColor = theme.alertBackgroudColor
            baseView.translatesAutoresizingMaskIntoConstraints = false
            baseView.clipsToBounds = true
            baseView.layer.cornerRadius = theme.cornerRadius
            
            NSLayoutConstraint.activate([
                baseView.leadingAnchor.constraint(equalTo: dialog.view.leadingAnchor, constant: 24),
                baseView.trailingAnchor.constraint(equalTo: dialog.view.trailingAnchor, constant: -24),
                baseView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
                baseView.centerXAnchor.constraint(equalTo: dialog.view.centerXAnchor),
                baseView.centerYAnchor.constraint(equalTo: dialog.view.centerYAnchor)])
            
            var previousView: UIView?
            func addViewToBaseView(view: UIView, index: Int, sideInset: CGFloat = 12.0) {
                view.translatesAutoresizingMaskIntoConstraints = false
                
                // set tag, if > 0 skip
                if view.tag == 0 {
                    view.tag = index + 1 // avoid 0 as tag
                }
                
                baseView.addSubview(view)
                
                if let pv = previousView {
                    let constant = CGFloat(12.0)
                    
                    NSLayoutConstraint.activate([
                        view.topAnchor.constraint(equalTo: pv.bottomAnchor, constant: constant),
                        view.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: sideInset),
                        view.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -sideInset),
                        view.centerXAnchor.constraint(equalTo: baseView.centerXAnchor)])
                } else {
                    NSLayoutConstraint.activate([
                        view.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 24),
                        view.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: sideInset),
                        view.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -sideInset),
                        view.centerXAnchor.constraint(equalTo: baseView.centerXAnchor)])
                }
                
                previousView = view
            }
            
            
            for (index, view) in views.enumerated() {
                addViewToBaseView(view: view, index: index)
            }
            
            if buttons.count == 2 { // handle side by side buttons
                let left = buttons[0]
                let right = buttons[1]
                
                left.translatesAutoresizingMaskIntoConstraints = false
                right.translatesAutoresizingMaskIntoConstraints = false
                
                applyLine(to: left, on: .top, color: theme.separatorColor)
                applyLine(to: right, on: .top, color: theme.separatorColor)
                applyLine(to: left, on: .right, color: theme.separatorColor)
                
                baseView.addSubview(left)
                baseView.addSubview(right)
                
                let topView = previousView ?? baseView
                
                NSLayoutConstraint.activate([
                    left.heightAnchor.constraint(equalToConstant: 44.0),
                    left.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 24),
                    left.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 0),
                    left.trailingAnchor.constraint(equalTo: right.leadingAnchor, constant: 0),
                    left.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0)])
                NSLayoutConstraint.activate([
                    right.heightAnchor.constraint(equalToConstant: 44.0),
                    right.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 24),
                    right.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 0),
                    right.widthAnchor.constraint(equalTo: left.widthAnchor)])
                
            } else if buttons.count > 0 { // single or more than 2 buttons
                for (index, button) in buttons.enumerated() {
                    applyLine(to: button, on: .top)
                    button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
                    addViewToBaseView(view: button, index: views.count + index + 1, sideInset: 0)
                }
                previousView?.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0).isActive = true
            } else {
                previousView?.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -24).isActive = true
            }
            
            for action in actions {
                action.dialog = dialog
            }
            
            return dialog
        }
        
    }
    
    /// reference to the builder
    private var builder: Builder!
    
    func show() {
        builder.targetViewController?.present(self, animated: true)
    }
    
}

extension UIImage {
    
    static func imageWithColor(tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
