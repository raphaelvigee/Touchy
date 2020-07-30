//
//  AppDelegate.swift
//  Touchy
//
//  Created by Raphaël Vigée on 22/07/2020.
//  Copyright © 2020 Raphaël Vigée. All rights reserved.
//

import Cocoa
import SwiftUI

let widgets: [Widget.Type] = [
    AnchorWidget.self,
    PreviousWidget.self,
    PlayPauseWidget.self,
    NextWidget.self,
    VolumeButtonsWidget.self,
    FlexWidget.self,
]

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

            TBController.makeTouchBar(widgets: config.items.map { typeToWidget(id: $0.type) }, hideControlStrip: config.alwaysHideControlStrip)
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

func typeToWidget(id: String) -> Widget.Type {
    switch id {
    case "anchor":
        return AnchorWidget.self
    case "previous":
        return PreviousWidget.self
    case "play":
        return PlayPauseWidget.self
    case "next":
        return NextWidget.self
    case "volume_buttons":
        return VolumeButtonsWidget.self
    case "flex":
        return FlexWidget.self
    default:
        fatalError("invalid type \(id)")
    }
}
