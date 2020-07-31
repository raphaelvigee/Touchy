//
//  AppDelegate.swift
//  Touchy
//
//  Created by Raphaël Vigée on 22/07/2020.
//  Copyright © 2020 Raphaël Vigée. All rights reserved.
//

import Cocoa
import SwiftUI
import Foundation

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

let appSupportDirectory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!.appending("/Touchy")
let standardConfigPath = appSupportDirectory.appending("/config.yaml")

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    private var TBController = TouchBarController()
    private var fileSystemSource: DispatchSourceFileSystemObject?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem!.button?.title = "🚀"

        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Toggle Control Strip", action: #selector(toggleCS), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Open config", action: #selector(openConfig), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Reload config", action: #selector(load), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))

        statusItem.menu = menu

        shell("mkdir", "-p", appSupportDirectory)
        shell("touch", standardConfigPath)

        load()
    }

    @objc func openConfig() {
        print(standardConfigPath)
        NSWorkspace.shared.openFile(standardConfigPath)
    }

    @objc func load() {
        do {
            let configStr = try String(contentsOfFile: standardConfigPath)

            let config = try decode(encodedYAML: configStr)

            TBController.makeTouchBar(widgets: config.items, hideControlStrip: config.alwaysHideControlStrip)
            TBController.alwaysHideControlStrip = config.alwaysHideControlStrip
        } catch {
            print("\(error)")
        }
    }

    @objc func toggleCS() {
        TBController.toggleCS()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
