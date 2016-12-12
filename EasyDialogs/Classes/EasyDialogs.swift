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

public class EasyDialog: UIViewController {
    
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
        
        /// The view controller to display the alert view
        let targetViewController: UIViewController
        
        private var views = [UIView]()
        private var buttons = [UIButton]()
        private var actions = [ActionWrapper]()
        
        init(_ viewController: UIViewController) {
            targetViewController = viewController
        }
        
        /// Set the title of the dialog
        func title(title: String) -> Self {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
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
            views.append(textField)
            return self
        }
        
        func addButton(tag: Int? = nil, title: String, callback: ((EasyDialog) -> ())?) -> Self {
            let button = UIButton(type: .custom)
            if let t = tag {
                button.tag = t
            }
            
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            
            if let cb = callback {
                actions.append(ActionWrapper(sender: button, action: cb))
            }
            buttons.append(button)
            return self
        }
        
        public func build() -> EasyDialog {
            let dialog = EasyDialog()
            dialog.builder = self
            dialog.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
            
            dialog.modalPresentationStyle = .overCurrentContext
            dialog.modalTransitionStyle = .crossDissolve
            
            let baseView = UIView()
            dialog.view.addSubview(baseView)
            
            //TODO: Style base view with a theme
            baseView.backgroundColor = UIColor.white
            baseView.translatesAutoresizingMaskIntoConstraints = false
            baseView.clipsToBounds = true
            baseView.layer.cornerRadius = 5
            
            NSLayoutConstraint.activate([
                baseView.leadingAnchor.constraint(equalTo: dialog.view.leadingAnchor, constant: 12),
                baseView.trailingAnchor.constraint(equalTo: dialog.view.trailingAnchor, constant: -12),
                baseView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
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
                    NSLayoutConstraint.activate([
                        view.topAnchor.constraint(equalTo: pv.bottomAnchor, constant: 12),
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
        builder.targetViewController.present(self, animated: true)
    }
    
}
