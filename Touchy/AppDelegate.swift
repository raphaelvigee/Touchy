//
//  AppDelegate.swift
//  Touchy
//
//  Created by Raphaël Vigée on 22/07/2020.
//  Copyright © 2020 Raphaël Vigée. All rights reserved.
//

import Cocoa
import SwiftUI

private let kBearIdentifier = NSTouchBarItem.Identifier("io.a2.Bear")
private let ktoggleCSIdentifier = NSTouchBarItem.Identifier("io.a2.ToggleCS")
private let kPandaIdentifier = NSTouchBarItem.Identifier("io.a2.Panda")
private let kGroupIdentifier = NSTouchBarItem.Identifier("io.a2.Group")


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTouchBarDelegate {
    
    
    private var hideControlStrip = false
    private var statusItem: NSStatusItem?

    private var _groupTouchBar: NSTouchBar?
    private var groupTouchBar: NSTouchBar? {
        if _groupTouchBar == nil {
            let groupTouchBar = NSTouchBar()
            groupTouchBar.defaultItemIdentifiers = [ktoggleCSIdentifier, kBearIdentifier, kPandaIdentifier]
            groupTouchBar.delegate = self
            _groupTouchBar = groupTouchBar
        }

        return _groupTouchBar
    }
    private var isVisible: Bool {
        if groupTouchBar == nil {
            return false
        }
        
        return groupTouchBar?.isVisible ?? false
    }

    @objc func bear(_ sender: Any?) {
        print("Bear")
    }

    func touchBar(
        _ touchBar: NSTouchBar,
        makeItemForIdentifier identifier: NSTouchBarItem.Identifier
    ) -> NSTouchBarItem? {
        if identifier.rawValue == kBearIdentifier.rawValue {
            let bear = NSCustomTouchBarItem(identifier: kBearIdentifier)
            bear.view = NSButton(title: "BEAR", target: self, action: #selector(bear(_:)))
            return bear
        } else if identifier.rawValue == kPandaIdentifier.rawValue {
            let panda = NSCustomTouchBarItem(identifier: kPandaIdentifier)
            panda.view = NSButton(title: "PANDA", target: self, action: #selector(present))
            return panda
        }else if identifier.rawValue == kGroupIdentifier.rawValue {
            print("group")
            return nil
        }else if identifier.rawValue == ktoggleCSIdentifier.rawValue {
            let panda = NSCustomTouchBarItem(identifier: ktoggleCSIdentifier)
            panda.view = NSButton(title: "CS", target: self, action: #selector(toggleCS))
            return panda
        } else {
            return nil
        }
    }
    
    @objc func toggleCS() {
        hideControlStrip = !hideControlStrip
        dismiss()
        present()
        showControlStripIcon()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "🚀"
        statusItem?.button?.action = #selector(toggle)
    
        present()
        showControlStripIcon()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    
    
    
    func showControlStripIcon() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
    
        let panda = NSCustomTouchBarItem(identifier: kGroupIdentifier)
        panda.view = NSButton(title: "MY", target: self, action: #selector(toggle))
        
        NSTouchBarItem.removeSystemTrayItem(panda)
        NSTouchBarItem.addSystemTrayItem(panda)
    }
    
    @objc func toggle() {
        if self.isVisible {
            self.minimize()
        }else {
            self.present()
        }
    }
    
    @objc func dismiss() {
        if #available (macOS 10.14, *) {
            NSTouchBar.dismissSystemModalTouchBar(groupTouchBar)
        } else {
            NSTouchBar.dismissSystemModalFunctionBar(groupTouchBar)
        }
    }
    
    @objc func minimize() {
        if #available (macOS 10.14, *) {
            NSTouchBar.minimizeSystemModalTouchBar(groupTouchBar)
        } else {
            NSTouchBar.minimizeSystemModalFunctionBar(groupTouchBar)
        }
    }
    
    @objc func present() {
        self.presentFromSystemTrayItem()
    }
    
    @objc func presentFromSystemTrayItem() {
        let placement: Int64 = hideControlStrip ? 1 : 0
        self.presentWithPlacement(placement: placement)
    }
    
    private func presentWithPlacement(placement: Int64) {
        if #available (macOS 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(groupTouchBar, placement: placement, systemTrayItemIdentifier: kGroupIdentifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(groupTouchBar, placement: placement, systemTrayItemIdentifier: kGroupIdentifier)
        }
    }

}

