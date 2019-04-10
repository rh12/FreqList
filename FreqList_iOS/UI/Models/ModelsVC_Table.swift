//
//  ModelsVC_Table.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 02. 22..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit


fileprivate typealias ID = AC.itemID.ModelsVC


// --------------------------------------------------------------------------------------------
// MARK:-    TABLE view HELPER METHODS
// --------------------------------------------------------------------------------------------

extension ModelsVC {
    func setupTableView() {
        // register ZoneSectionHeader
        tableView.register(UINib(nibName: AC.nib.ZoneSectionHeader, bundle: nil),
                           forHeaderFooterViewReuseIdentifier: ID.ZoneSectionHeader)
        
        // register ModelCell
        tableView.register(UINib(nibName: AC.nib.ModelCell, bundle: nil),
                           forCellReuseIdentifier: ID.ModelCell)
    }
    
    func model(forIndexPath ip: IndexPath) -> Model {
        return zones[ip.section][ip.row]
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    TABLE view DATASOURCE
// --------------------------------------------------------------------------------------------

extension ModelsVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return zones.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zones[section].models.count
    }
    
    // --------------------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ID.ZoneSectionHeader) as! ZoneSectionHeader
        header.zoneName = zones[section].name
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
    
    // --------------------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID.ModelCell, for: indexPath) as! ModelCell
        cell.delegate = self

        let model = self.model(forIndexPath: indexPath)
        cell.configure(withModel: model)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}


// --------------------------------------------------------------------------------------------
// MARK:-    TABLE view DELEGATE
// --------------------------------------------------------------------------------------------

extension ModelsVC {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // update ViewModel of channelsVC
        let model = self.model(forIndexPath: indexPath)
        channelsVC.update(forModel: model)
        
        // show channelsVC
        if let navC = channelsVC.navigationController {
            splitViewController?.showDetailViewController(navC, sender: self)
        }
    }
    
}


// --------------------------------------------------------------------------------------------
// MARK:-    CHECKBUTTON DELEGATE
// --------------------------------------------------------------------------------------------

extension ModelsVC: CheckButtonDelegate {
    
    func didPressCheckButton(ofCell cell: UITableViewCell) {
        guard let cell = cell as? ModelCell,
            let ip = tableView.indexPath(for: cell)
            else { return }
        
        // check/uncheck + display
        let model = self.model(forIndexPath: ip)
        model.checkAll(!model.isAllChecked)
        cell.configure(withModel: model, animated: true)
        
        // update ChannelsVC
        if cell.isSelected {
            channelsVC.updateVisibleCheckButtons()
        }
    }
}
