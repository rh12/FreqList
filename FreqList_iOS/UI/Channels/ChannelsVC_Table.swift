//
//  ChannelsVC_Table.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 02. 22..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit


fileprivate typealias ID = AC.itemID.ChannelsVC


// --------------------------------------------------------------------------------------------
// MARK:-    TABLE view HELPER METHODS
// --------------------------------------------------------------------------------------------

extension ChannelsVC {
    func setupTableView() {
        // register ChannelCell
        tableView.register(UINib(nibName: AC.nib.ChannelCell, bundle: nil),
                           forCellReuseIdentifier: ID.ChannelCell)
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    TABLE view DATASOURCE
// --------------------------------------------------------------------------------------------

extension ChannelsVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelList.count
    }
    
    // --------------------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    // --------------------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID.ChannelCell, for: indexPath) as! ChannelCell
        cell.delegate = self
        
        let ch = channelList[indexPath.row]
        cell.configure(withChannel: ch)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}


// --------------------------------------------------------------------------------------------
// MARK:-    TABLE view DELEGATE
// --------------------------------------------------------------------------------------------

extension ChannelsVC {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let selectedIP = tableView.indexPathForSelectedRow else { return indexPath }
        
        // will select already selected cell -> deselect it
        if selectedIP == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            return nil
        }
        
        return indexPath
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
}


// --------------------------------------------------------------------------------------------
// MARK:-    CHECKBUTTON DELEGATE
// --------------------------------------------------------------------------------------------

extension ChannelsVC: CheckButtonDelegate {
    
    func didPressCheckButton(ofCell cell: UITableViewCell) {
        guard let cell = cell as? ChannelCell,
            let ip = tableView.indexPath(for: cell)
            else { return }
        
        // check/uncheck + display
        let ch = channelList[ip.row]
        ch.isChecked.toggle()
        cell.configure(withChannel: ch, animated: true)
        updateCheckAllButton()
        modelsVC?.updateRow(forModel: selectedModel)
        
        // update selections if needed
        if cell.isSelected && ch.isChecked == true {
            if ip.row+1 < channelList.count {
                // select next row (+implicit: deselect current row)
                let nextIP = IndexPath(row: ip.row+1, section: ip.section)
                tableView.selectRow(at: nextIP, animated: true, scrollPosition: .middle)
            } else {
                // deselect last row
                tableView.deselectRow(at: ip, animated: true)
            }
        }
    }
}
