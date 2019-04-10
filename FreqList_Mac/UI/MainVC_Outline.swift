//
//  MainVC_Outline.swift
//  FreqList
//
//  Created by ricsi on 2019. 01. 28..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Cocoa


fileprivate typealias ID = AC.itemID.ZonesOutline


// --------------------------------------------------------------------------------------------
// MARK:-    OUTLINE DATASOURCE
// --------------------------------------------------------------------------------------------

extension MainVC: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        switch item {
        case nil:
            return project.zones.count
        case let zone as Zone:
            return zone.models.count
        default:
            return 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        switch item {
        case let zone as Zone:
            return zone.models.count > 0
        default:
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        switch item {
        case nil:
            return project.zones[index]
        case let zone as Zone:
            return zone.models[index]
        default:
            return false
        }
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    OUTLINE DELEGATE
// --------------------------------------------------------------------------------------------

extension MainVC: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var cellID = NSUIItemID("")
        var text = ""
        
        switch item {
        case let zone as Zone:
            cellID = ID.zoneCell
            text = "ZONE: " + zone.name
        case let model as Model:
            cellID = ID.modelCell
            text = model.name
        default:
            break
        }
        
        let cell = outlineView.makeCellView(withIdentifier: cellID)
        cell?.textField?.stringValue = text
        return cell
    }
    
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else { return }
        let item = outlineView.item(atRow: outlineView.selectedRow)
        
        switch item {
        case let zone as Zone:
            // show channels in Zone
            selectedZone = zone
            selectedModel = nil
        case let model as Model:
            // show channels for Model
            selectedZone = model.zone
            selectedModel = model
        default:
            selectedZone = nil
            selectedModel = nil
        }
        
        channelsTableView.reloadData()
        if channelsTableView.numberOfRows > 0 {
            channelsTableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        }
    }
    
}
