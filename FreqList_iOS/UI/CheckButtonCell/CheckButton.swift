//
//  CheckButton.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 02. 20..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

class CheckButton: UIButton {

    var isChecked: Bool = false {
        didSet {
            update()
        }
    }
    
    var states: [ButtonState:StateConfig] = [:]
    
    var rectSize: CGFloat = 34.0
    var fontSize: CGFloat = 30.0
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    INIT
    // --------------------------------------------------------------------------------------------

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        commonInit()
    }
    
    init(rectSize: CGFloat, fontSize: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.rectSize = rectSize
        self.fontSize = fontSize
        commonInit()
    }
    
    // --------------------------------------------------------------------------------------------

    private func commonInit(){
        
        // border
        layer.borderWidth = 1.0
        layer.borderColor = AC.color.CheckButton.border.cgColor
        layer.cornerRadius = 6.0

        for state in ButtonState.allCases {
            // set state-dependent attributes
            var textColor: UIColor
            var bgColor: UIColor
            switch state {
            case .checked:
                textColor = AC.color.CheckButton.white
                bgColor = AC.color.CheckButton.green
            case .unchecked:
                textColor = AC.color.CheckButton.darkGray
                bgColor = AC.color.CheckButton.lightGray
            }
            
            // setup Title
            let attrDict: [NSAttributedString.Key : Any] = [
                .font: UIFont.italicSystemFont(ofSize: fontSize),
                .foregroundColor: textColor,
            ]
            let title = NSAttributedString(string: AC.string.Check.checked, attributes: attrDict)
            
            // store StateConfig
            states[state] = StateConfig(title: title, bgColor: bgColor)
        }

        // size
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute,
                                                  multiplier: 1, constant: rectSize)
        let whConstraint = NSLayoutConstraint(item: self, attribute: .height,
                                              relatedBy: .equal,
                                              toItem: self, attribute: .width,
                                              multiplier: 1, constant: 0)
        addConstraints([heightConstraint, whConstraint])
        
        // misc
        showsTouchWhenHighlighted = true

    }
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    GENERAL
    // --------------------------------------------------------------------------------------------

    func update() {
        if isChecked {
            setAttributedTitle(states[.checked]?.title, for: .normal)
            setAttributedTitle(states[.unchecked]?.title, for: .highlighted)
            backgroundColor = states[.checked]?.bgColor
        } else {
            setAttributedTitle(states[.unchecked]?.title, for: .normal)
            setAttributedTitle(states[.checked]?.title, for: .highlighted)
            backgroundColor = states[.unchecked]?.bgColor
        }
    }
}

// --------------------------------------------------------------------------------------------
// MARK:-    EXTENSION: States
// --------------------------------------------------------------------------------------------

extension CheckButton {
    enum ButtonState: CaseIterable {
        case checked
        case unchecked
    }
    
    struct StateConfig {
        let title: NSAttributedString
        let bgColor: UIColor
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    PROTOCOL
// --------------------------------------------------------------------------------------------

protocol CheckButtonDelegate {
    func didPressCheckButton(ofCell cell: UITableViewCell)
}
