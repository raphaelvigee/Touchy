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
    VolumeSliderWidget.self,
    VolumeUpWidget.self,
    VolumeDownWidget.self,
    FlexWidget.self,
]

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?

    private var TBController = TouchBarController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "🚀"
        statusItem?.button?.action = #selector(menuAction)

        let config = decode()

        TBController.makeTouchBar(widgets: config.items.map { typeToWidget(id: $0.type) }, hideControlStrip: config.defaultHideControlStrip)
    }

    @objc func menuAction() {
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
    case "volume_slider":
        return VolumeSliderWidget.self
    case "volume_up":
        return VolumeUpWidget.self
    case "volume_down":
        return VolumeDownWidget.self
    case "flex":
        return FlexWidget.self
    default:
        fatalError("invalid type \(id)")
    }
}
