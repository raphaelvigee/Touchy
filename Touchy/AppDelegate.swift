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

        let config = decode()

        TBController.makeTouchBar(ids: config.items.map { typeToIdentifier(id: $0.type) })

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

func typeToIdentifier(id: String) -> NSTouchBarItem.Identifier {
    switch id {
    case "anchor":
        return .Anchor
    case "previous":
        return .Previous
    case "play":
        return .Play
    case "next":
        return .Next
    case "volume_slider":
        return .VolumeSlider
    case "volume_up":
        return .VolumeUp
    case "volume_down":
        return .VolumeDown
    case "flex":
        return .flexibleSpace
    default:
        return NSTouchBarItem.Identifier("__invalid__")
    }
}
