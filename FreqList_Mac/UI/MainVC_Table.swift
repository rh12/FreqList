//
//  MainVC_Table.swift
//  FreqList for Mac
//
//  Created by ricsi on 2019. 01. 28..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Cocoa


fileprivate typealias ID = AC.itemID.ChannelsTable


// --------------------------------------------------------------------------------------------
// MARK:-    TABLE view HELPER METHODS
// --------------------------------------------------------------------------------------------

extension MainVC {
    var channelList: [Channel] {
        return selectedModel?.channels ?? selectedZone?.allChannels ?? []
    }
    
    func channelForRow(_ row: Int) -> Channel? {
        return (0 <= row && row < channelList.count) ? channelList[row] : nil
    }
    
    // --------------------------------------------------------------------------------------------

    func setupSorting() {
        typealias SortKey = Channel.SortKey
        
        let dict = [SortKey.model       : ID.modelColumn,
                    SortKey.chName      : ID.nameColumn,
                    SortKey.deviceID    : ID.deviceIDColumn,
                    SortKey.freqString  : ID.freqColumn]
        for (sortKey, columnID) in dict {
            if let column = channelsTableView.tableColumn(withIdentifier: columnID) {
                column.sortDescriptorPrototype = NSSortDescriptor(key: sortKey.rawValue, ascending: true)
            }
        }
        let defaultSD = NSSortDescriptor(key: SortKey.chName.rawValue, ascending: true)
        channelsTableView.sortDescriptors = [defaultSD]
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    TABLE view DATASOURCE
// --------------------------------------------------------------------------------------------

extension MainVC: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return channelList.count
    }
    
    // --------------------------------------------------------------------------------------------
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sd = tableView.sortDescriptors.first else { return }
        
        // sort data manually, because Channel is not NSObject
        project.sortChannels(usingSortDescriptor: sd)
        
        tableView.reloadData()
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    TABLE view DELEGATE
// --------------------------------------------------------------------------------------------

extension MainVC: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let channel = channelForRow(row) else { return nil }
        
        var cellID = NSUIItemID("")
        var text = ""
        switch tableColumn?.identifier {
        case ID.nameColumn?:
            cellID = ID.nameCell
            text = channel.chName
        case ID.deviceIDColumn?:
            cellID = ID.deviceIDCell
            text = channel.deviceID
        case ID.freqColumn?:
            cellID = ID.freqCell
            text = channel.freqString
        case nil:
            // group row
            return nil
        default:
            // unknown column
            return nil
        }
        
        guard let cell = channelsTableView.makeCellView(withIdentifier: cellID) else { return nil }
        cell.textField?.stringValue = text
        
        return cell
    }
    
    // --------------------------------------------------------------------------------------------
    
    func tableViewSelectionDidChange(_ notification: Notification) {
//        guard let tableView = notification.object as? NSTableView else { return }
        copyCurrentSelection()
    }
    
    // --------------------------------------------------------------------------------------------

    func tableViewColumnDidMove(_ notification: Notification) {
        // store current selection
        let selectedLabel = copySelectorSC.label(forSegment: copySelectorSC.selectedSegment)

        // rename segments (instead of real reordering)
        for i in 0..<copySelectorSC.segmentCount {
            copySelectorSC.setLabel(channelsTableView.tableColumns[i].title, forSegment: i)
        }

        // update selection
        if let i = channelsTableView.tableColumns.firstIndex(where: { $0.title == selectedLabel }) {
            copySelectorSC.setSelected(true, forSegment: i)
        }
    }
}
