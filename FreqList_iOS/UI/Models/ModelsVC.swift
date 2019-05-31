//
//  ModelsVC.swift
//  FreqList for iOS
//
//  Created by ricsi on 2019. 01. 21..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import UIKit

class ModelsVC: UITableViewController {
    
    // connections
    weak var channelsVC: ChannelsVC!
    
    // data
    var project: Project?

    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SUBSCRIPTS + COMPUTED
    // --------------------------------------------------------------------------------------------
    
    var zones: [Zone] {
        return project?.zones ?? []
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    SETUP
    // --------------------------------------------------------------------------------------------

    private func setupNavigationItem() {
        // setup rightBarButton
        let demoButton = UIBarButtonItem(title: "Demo", style: .plain,
                                         target: self, action: #selector(demoButtonPressed(_:)))
        navigationItem.rightBarButtonItem = demoButton
    }

    
    // --------------------------------------------------------------------------------------------
    // MARK:-    VIEW
    // --------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup splitVC
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
        
        // setup connections
        if let rightVC = splitViewController?.viewControllers.last as? UINavigationController {
            channelsVC = rightVC.topViewController as? ChannelsVC
            channelsVC.modelsVC = self
        }
        
        // setup other things
        setupNavigationItem()
        setupTableView()
    }

    // --------------------------------------------------------------------------------------------

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // open last used file if App is started without a new file
        if appDelegate.openLastUsedFile {
            appDelegate.openLastUsedFile = false
            if let url = FileManager.documentsDirectory?.appendingPathComponent(AC.string.lastUsedFile),
                FileManager.default.fileExists(atPath: url.path) {
                openFile(url)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tableView.scrollToSelectedRow(with: coordinator)
    }
    
    
    // --------------------------------------------------------------------------------------------
    // MARK:-    ACTIONS
    // --------------------------------------------------------------------------------------------
    
    @objc
    func demoButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Would you like to open a demo project?",
                                      message: "It will replace the current project, and any changes in it.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open demo", style: .destructive, handler: {_ in openDemo()} ))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
        
        func openDemo() {
            var url: URL?
//            url = FileManager.documentsDirectory?.appendingPathComponent(AC.string.lastUsedFile)
//            url = Bundle.main.url(forResource: "/Report/_test-havasi.csv", withExtension: nil)
//            url = Bundle.main.url(forResource: "/Report/find-best.csv", withExtension: nil)
//            url = Bundle.main.url(forResource: "/Show Files/_colortest.shw", withExtension: nil)
//            url = Bundle.main.url(forResource: "/Show Files/2018-12_Havasi_Arena.shw", withExtension: nil)
//            url = Bundle.main.url(forResource: "/Show Files/_test.flp", withExtension: nil)
//            url = Bundle.main.url(forResource: "/Show Files/2019-02_MOM_kinai.shw", withExtension: nil)
//            url = Bundle.main.url(forResource: "/Report/__test.flxml", withExtension: nil)
            url = Bundle.main.url(forResource: "/demo/H_Arena.shw", withExtension: nil)
            
            if let url = url {
                openFile(url)
            } else {
                presentErrorAlert(title: "INVALID DEMO URL")
            }
        }
    }

    
    // --------------------------------------------------------------------------------------------
    // MARK:-    GENERAL
    // --------------------------------------------------------------------------------------------

    @discardableResult
    func openFile(_ url: URL) -> Bool {
        do {
            // process file
            let newProject = try Project(fromURL: url)
            
            // set as current project only, if there was no error
            project = newProject

            // present data
            project?.sortModels()
            project?.sortChannels(by: .chName, ascending: true)
            tableView.reloadData()
            if let splitVC = splitViewController, splitVC.isCollapsed {
                navigationController?.popToRootViewController(animated: true)
            }
            channelsVC.clear()
        } catch {
            // display alert
            let errorMessage = (error as? FileParserError)?.message ?? "Unknown error."
            let path = url.lastPathComponent   // use url.path for full path
            presentErrorAlert(title: errorMessage, message: path)
            return false
        }
        
        return true
    }
    
    // --------------------------------------------------------------------------------------------

    func updateRow(forModel model: Model?) {
        guard let model = model else { return }

        for (section, zone) in zones.enumerated() {
            if let row = zone.models.firstIndex(of: model) {
                let ip = IndexPath(row: row, section: section)
                
                if let cell = tableView.cellForRow(at: ip) as? ModelCell {
                    cell.configure(withModel: model)
                }
            }
        }
    }

}


// --------------------------------------------------------------------------------------------
// MARK:-    SPLIT view DELEGATE
// --------------------------------------------------------------------------------------------

extension ModelsVC: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryVC:UIViewController,
                             onto primaryVC:UIViewController) -> Bool {
        if !channelsVC.hasChannels {
            // Return true to indicate that we have handled the collapse by doing nothing
            // the secondary controller will be discarded.
            return true
        }
        return false
    }
}

