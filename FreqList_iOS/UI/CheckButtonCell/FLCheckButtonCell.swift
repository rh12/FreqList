//
//  FLCheckButtonCell.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 03. 08..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

class FLCheckButtonCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var smallerLabel: UILabel!
    @IBOutlet weak var checkButton: CheckButton!
    @IBOutlet weak var leftColorView: UIView!
    
    var delegate: CheckButtonDelegate?
    
    var bgColor: UIColor = .white
    var bgColorChecked: UIColor = .white
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    VIEW
    // --------------------------------------------------------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // needed, because of overriden setSelected/Higghlighted
        selectionStyle = .none
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        configureColors(state: currentState)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        configureColors(state: currentState, animated: animated)
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SETUP
    // --------------------------------------------------------------------------------------------
    
    enum CellState {
        case highlighted
        case selected
        case checked
        case unchecked
    }
    
    final var currentState: CellState {
        if isHighlighted { return .highlighted }
        if isSelected { return .selected }
        return checkButton.isChecked ? .checked : .unchecked
    }

    final func updateColors(sourceColor color: Channel.Color, useColors: Bool, animated: Bool) {
        bgColor = UIColor(channelColor: color)
        bgColorChecked = UIColor(channelColor: color, checked: true)
        leftColorView.backgroundColor = useColors ? bgColor : .clear
        configureColors(state: currentState, animated: animated)
    }
    
    final func configureColors(state: CellState, animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: AC.time.deselectOnCheck) { self.doColorConfig(state) }
        } else { doColorConfig(state) }
    }
    
    // --------------------------------------------------------------------------------------------

    func doColorConfig(_ state: CellState) {
        switch state {
        case .unchecked:
            nameLabel.textColor = AC.color.Cell.black
            smallerLabel.textColor = AC.color.Cell.darkGray
            backgroundColor = bgColor
        case .checked:
            nameLabel.textColor = AC.color.Cell.checkedTextGray
            smallerLabel.textColor = AC.color.Cell.checkedTextGray
            backgroundColor = bgColorChecked
        case .highlighted:
            fallthrough
        case .selected:
            nameLabel.textColor = AC.color.Cell.white
            smallerLabel.textColor = AC.color.Cell.white
            backgroundColor = tintColor
        }
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    GENERAL
    // --------------------------------------------------------------------------------------------
    
    @IBAction func checkButtonPressed() {
        delegate?.didPressCheckButton(ofCell: self)
    }
    
}

