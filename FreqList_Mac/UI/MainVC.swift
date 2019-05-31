//
//  MainVC.swift
//  FreqList for Mac
//
//  Created by ricsi on 2019. 01. 14..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Cocoa

class MainVC: NSViewController {
    
    // outlets
    @IBOutlet weak var fileTFCell: NSTextFieldCell!
    @IBOutlet weak var clipboardTF: NSTextField!
    @IBOutlet weak var copySelectorSC: NSSegmentedControl!
    @IBOutlet weak var modelsOutlineView: NSOutlineView!
    @IBOutlet weak var channelsTableView: NSTableView!
    
    // data
    var project: Project = Project()
    weak var selectedZone: Zone?
    weak var selectedModel: Model?
    var sourceFile: URL?
    
    // misc
    var isInitialAppearance: Bool = true
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    VIEW
    // --------------------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelsOutlineView.dataSource = self
        modelsOutlineView.delegate = self
        channelsTableView.dataSource = self
        channelsTableView.delegate = self

        // set segments for copySelectorSC
        let segmentWidth = copySelectorSC.frame.size.width / CGFloat(copySelectorSC.segmentCount)
        for i in 0..<copySelectorSC.segmentCount {
            copySelectorSC.setWidth(segmentWidth, forSegment: i)
            copySelectorSC.setLabel(channelsTableView.tableColumns[i].title, forSegment: i)
        }
        
        // setup sorting
        setupSorting()
    }
    
    // --------------------------------------------------------------------------------------------

    override func viewDidAppear() {
        super.viewDidAppear()

        // display FileOpen window at program start
        if isInitialAppearance {
            openFileClicked(self)
            isInitialAppearance = false
        }
    }


    // --------------------------------------------------------------------------------------------
    // MARK:-    ACTIONS
    // --------------------------------------------------------------------------------------------

    @IBAction func openFileClicked(_ sender: Any) {
        guard let window = view.window else { return }
        
        // create "Open..." dialog
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = FileTypes.extensions
        
        // show "Open..." dialog
        panel.beginSheetModal(for: window) { (response) in
            // if a file was selected
            if response == NSApplication.ModalResponse.OK {
                let url = panel.urls[0]
                self.openFile(url)
            }
        }
    }
    
    @IBAction func reloadClicked(_ sender: Any) {
        guard let url = sourceFile else { return }
        openFile(url)
    }

    // --------------------------------------------------------------------------------------------
    
    @IBAction func doubleClickedOutlineItem(_ sender: NSOutlineView) {
        if sender == modelsOutlineView {
            if let item = sender.item(atRow: sender.clickedRow) as? Zone {
                sender.isItemExpanded(item) ? sender.collapseItem(item) : sender.expandItem(item)
            }
        }
    }
    
    // --------------------------------------------------------------------------------------------

    @IBAction func didSelectSegment(_ sender: NSSegmentedControl) {
        if sender == copySelectorSC {
            copyCurrentSelection()
        }
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    METHODS
    // --------------------------------------------------------------------------------------------

    /// Opens the file from the given URL, and loads its content into 'project'.
    /// If there was en error, the current project stays.
    @discardableResult
    func openFile(_ url: URL) -> Bool {
        do {
            // process file
            let newProject = try Project(fromURL: url)
            
            // set as current project only, if there was no error
            project = newProject
            sourceFile = url

            // present data
            fileTFCell.stringValue = url.path
            presentData()
        } catch {
            // display alert
            let alert = NSAlert()
            let errorMessage = (error as? FileParserError)?.message ?? "Unknown error."
            alert.messageText = errorMessage
            alert.informativeText = url.path
            alert.runModal()
            
            return false
        }
        
        return true
    }
    
    
    /// Presents data, by sorting channels, rebulding ZonesOutline, selecting first Model.
    func presentData() {
        // sort data
        if let sd = channelsTableView.sortDescriptors.first {
            project.sortChannels(usingSortDescriptor: sd)
        }
        
        // reload zones
        modelsOutlineView.reloadData()
        modelsOutlineView.expandItem(nil, expandChildren: true)
        
        // select first model row
        var rowIndex = 0
        for zone in project.zones {
            rowIndex += 1
            if zone.models.count > 0 {
                break
            }
        }
        modelsOutlineView.selectRowIndexes(IndexSet(integer: rowIndex), byExtendingSelection: false)
        
        // activate
        view.window?.makeFirstResponder(modelsOutlineView)
    }
    
    // --------------------------------------------------------------------------------------------

    func copyCurrentSelection() {
        var copiedString = ""
        
        if let channel = channelForRow(channelsTableView.selectedRow) {
            let columnID = channelsTableView.tableColumns[copySelectorSC.selectedSegment].identifier
            
            switch columnID {
            case AC.itemID.ChannelsTable.nameColumn:
                copiedString = channel.chName
            case AC.itemID.ChannelsTable.deviceIDColumn:
                copiedString = channel.deviceID
            case AC.itemID.ChannelsTable.freqColumn:
                copiedString = channel.freqString
            default:
                break
            }
        }
        
        // copy to Clipboard
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(copiedString, forType: .string)
        
        // update TextField
        clipboardTF.stringValue = copiedString
        /// TODO: use attributedString to make textBG a bit darker (to show possible whitespaces)
    }
    
    // --------------------------------------------------------------------------------------------

    override func keyDown(with event: NSEvent) {
        // change copySelector segment with left/right arrows from ChannelsTable
        if view.window?.firstResponder == channelsTableView {
            let segment = copySelectorSC.selectedSegment
            switch event.keyCode {
            case 123: // <-
                if segment > 0 {
                    copySelectorSC.selectSegment(withTag: segment-1)
                    copyCurrentSelection()
                }
            case 124: // ->
                if segment < copySelectorSC.segmentCount-1 {
                    copySelectorSC.selectSegment(withTag: segment+1)
                    copyCurrentSelection()
                }
            default:
                super.keyDown(with: event)
            }
        } else {
            super.keyDown(with: event)
        }
    }
}
