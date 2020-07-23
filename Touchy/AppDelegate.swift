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
    private var statusItem: NSStatusItem?
    private var TBController = TouchBarController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "🚀"
        statusItem?.button?.action = #selector(menuAction)

        TBController.showControlStripIcon()
        TBController.present()
        TBController.minimize()
    }

    @objc func menuAction() {
        TBController.toggleCS()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

