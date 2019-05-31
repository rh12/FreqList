//
//  ChannelsVC
//  FreqList for iOS
//
//  Created by ricsi on 2019. 01. 21..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

class ChannelsVC: UITableViewController {
    
    // connections
    weak var modelsVC: ModelsVC?
    
    // UI
    private var checkAllButton: CheckButton?
    
    // data
    private(set) weak var selectedZone: Zone?
    private(set) weak var selectedModel: Model?
    
    // sorting
    private(set) var isAscending: Bool = true
    private(set) var sortedBy: Channel.SortKey = .chName
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SUBSCRIPTS + COMPUTED
    // --------------------------------------------------------------------------------------------
    
    var channelList: [Channel] {
        return selectedModel?.channels ?? selectedZone?.allChannels ?? []
    }
    
    var project: Project? {
        return selectedZone?.project
    }
    
    var hasChannels: Bool {
        return selectedZone != nil || selectedModel != nil
    }
    
    var isAllChecked: Bool {
        return selectedModel?.isAllChecked ?? selectedZone?.isAllChecked ?? false
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SETUP
    // --------------------------------------------------------------------------------------------
    
    private func setupNavigationItem() {
        // sort button
//                let sortBBI = UIBarButtonItem(title: AC.string.Sort.downUp, style: .plain,
        let sortBBI = UIBarButtonItem(barButtonSystemItem: .organize,
                                      target: self, action: #selector(sortButtonPressed(_:)))
        
        // checkAll button
        checkAllButton = CheckButton(rectSize: 24.0, fontSize: 20.0)
        checkAllButton!.addTarget(self, action: #selector(checkAllButtonPressed(_:)), for: .touchUpInside)
        let checkAllBBI = UIBarButtonItem(customView: checkAllButton!)
        
        // add buttons
        navigationItem.rightBarButtonItems = [sortBBI, checkAllBBI]
        navigationItem.enableRightBarButtonItems(hasChannels)
        
        // title
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingMiddle
        titleLabel.sizeToFit()
//        navigationItem.titleView = titleLabel
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    VIEW
    // --------------------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupTableView()
    }
    
    // --------------------------------------------------------------------------------------------

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tableView.scrollToSelectedRow(with: coordinator)
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    UPDATE
    // --------------------------------------------------------------------------------------------

    func update() {
        // update Title
        var title = "Channels"
        if let zone = selectedZone, let model = selectedModel {
            title = zone.name == "Default" ? model.name : "[\(zone.name)]  \(model.name)"
        }
        navigationItem.title = title
        
        if let label = navigationItem.titleView as? UILabel {
            label.text = title
        }
        
        // update rightBarButtons
        navigationItem.enableRightBarButtonItems(hasChannels)
        updateCheckAllButton()
        
        // reload Table
        tableView.reloadData()
        if hasChannels {
            tableView.layoutIfNeeded()
            tableView.scrollToRow(at: IndexPath(row:0, section: 0), at: .none, animated: false)
        }
    }
    
    // --------------------------------------------------------------------------------------------
    
    func update(forModel model: Model?) {
        selectedZone = model?.zone
        selectedModel = model
        update()
    }
    
    func update(forZone zone: Zone?) {
        selectedZone = zone
        selectedModel = nil
        update()
    }
    
    func clear() {
        selectedZone = nil
        selectedModel = nil
        update()
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SORT
    // --------------------------------------------------------------------------------------------

    @objc func sortButtonPressed(_ sender: UIBarButtonItem) {
        // create alert
        let alert = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
        
        // add sorting options
        let array: [(Channel.SortKey, String)] = [
            (.chName      , "Channel Name"),
            (.deviceID    , "Device ID"),
            (.freqString  , "Frequency")
        ]
        let dir: String = isAscending ? AC.string.Sort.asc : AC.string.Sort.desc  // show current direction
        for (sortKey, var text) in array {
            if sortKey == sortedBy { text += "  \(dir)" }
            alert.addAction(UIAlertAction(title: text, style: .default, handler:
                { alert in self.sortChannels(by: sortKey) } ))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // present alert
        alert.popoverPresentationController?.barButtonItem = sender
        present(alert, animated: true)
    }
    
    // --------------------------------------------------------------------------------------------

    func sortChannels(by sortBy: Channel.SortKey) {
        // sort
        if sortBy == sortedBy {
            isAscending.toggle()
        } else {
            sortedBy = sortBy
            isAscending = true
        }
        let oldList = channelList
        project?.sortChannels(by: sortedBy, ascending: isAscending)
        let newList = channelList
        
        // reorder rows
        tableView.performBatchUpdates({
            for newIndex in 0..<newList.count {
                let oldIndex = oldList.firstIndex(of: newList[newIndex])
                if let oldIndex = oldIndex, oldIndex != newIndex {
                    tableView.moveRow(at: IndexPath(row: oldIndex, section: 0),
                                      to: IndexPath(row: newIndex, section: 0))
                }
            }
        }, completion: nil)
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    CHECK ALL
    // --------------------------------------------------------------------------------------------

    @objc func checkAllButtonPressed(_ sender: UIBarButtonItem) {
        // check/uncheck all
        let check = !isAllChecked
        channelList.forEach {$0.isChecked = check}
        
        // update
        updateVisibleCheckButtons()
        modelsVC?.updateRow(forModel: selectedModel)
    }

    // --------------------------------------------------------------------------------------------
    
    func updateVisibleCheckButtons() {
        // update bar button
        updateCheckAllButton()
        
        // update cells
        for (row, ch) in channelList.enumerated() {
            let ip = IndexPath(row: row, section: 0)
            if let cell = tableView.cellForRow(at: ip) as? ChannelCell {
                cell.configure(withChannel: ch, animated: true)
            }
        }
        // Test with 'cellForRow(at:)' instead of 'indexPathsForVisibleRows',
        //  because later does not include (not-visible) pre-loaded cells,
        //  and those pre-loaded cells will not be configured later on display.
        //  (No tableView(_:cellForRowAt:) will be called for their index paths.)
        //  ('visibleCells' also includes pre-loaded cells)
    }
    
    // --------------------------------------------------------------------------------------------

    func updateCheckAllButton() {
        checkAllButton?.isChecked = isAllChecked
    }
    
}

