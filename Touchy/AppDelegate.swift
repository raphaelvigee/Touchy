//
//  AppDelegate.swift
//  Touchy
//
//  Created by Raphaël Vigée on 22/07/2020.
//  Copyright © 2020 Raphaël Vigée. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    private var TBController = TouchBarController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem!.button?.title = "🚀"

        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Toggle Control Strip", action: #selector(toggleCS), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))

        statusItem.menu = menu

        do {
            let config = try decode()

            TBController.makeTouchBar(widgets: config.items, hideControlStrip: config.alwaysHideControlStrip)
            TBController.alwaysHideControlStrip = config.alwaysHideControlStrip
        } catch {
            fatalError("\(error)")
        }
    }

    @objc func toggleCS() {
        TBController.toggleCS()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
