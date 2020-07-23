//
//  TouchBarController.swift
//  Touchy
//
//  Created by Raphaël Vigée on 23/07/2020.
//  Copyright © 2020 Raphaël Vigée. All rights reserved.
//

import Foundation
import AudioToolbox

@available(OSX 10.12.2, *)
extension NSTouchBar.CustomizationIdentifier {
    static let mainTouchBar = NSTouchBar.CustomizationIdentifier("com.touchy")
}

@available(OSX 10.12.2, *)
extension NSTouchBarItem.Identifier {
    static let CS = NSTouchBarItem.Identifier("com.touchy.CS")
    static let Anchor = NSTouchBarItem.Identifier("com.touchy.Anchor")
    static let Previous = NSTouchBarItem.Identifier("com.touchy.Previous")
    static let Play = NSTouchBarItem.Identifier("com.touchy.Play")
    static let Next = NSTouchBarItem.Identifier("com.touchy.Next")
    static let VolumeSlider = NSTouchBarItem.Identifier("com.touchy.VolumeSlider")
    static let VolumeUp = NSTouchBarItem.Identifier("com.touchy.VolumeUp")
    static let VolumeDown = NSTouchBarItem.Identifier("com.touchy.VolumeDown")
}

class TouchBarController: NSObject, NSTouchBarDelegate {
    private var groupTouchBar: NSTouchBar?
    private var isVisible: Bool {
        if groupTouchBar == nil {
            return false
        }

        return groupTouchBar?.isVisible ?? false
    }

    private var hideControlStrip = false

    @objc func bear() {
        print("Bear")
    }

    @objc func panda() {
        print("Panda")
    }

    func makeTouchBar(ids: [NSTouchBarItem.Identifier]) {
        groupTouchBar = NSTouchBar()
        groupTouchBar?.delegate = self
        groupTouchBar?.customizationIdentifier = .mainTouchBar
        groupTouchBar?.defaultItemIdentifiers = ids
    }

    func touchBar(
            _ touchBar: NSTouchBar,
            makeItemForIdentifier identifier: NSTouchBarItem.Identifier
    ) -> NSTouchBarItem? {
        switch identifier {
        case .Anchor:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = NSButton(title: "⚓️", target: self, action: #selector(toggleCS))
            return item
        case .Previous:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = NSButton(title: "<️", target: self, action: #selector(previous))
            return item
        case .Play:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = NSButton(title: "||", target: self, action: #selector(togglePlayPause))
            return item
        case .Next:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = NSButton(title: ">", target: self, action: #selector(next))
            return item
        case .VolumeUp:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = NSButton(title: "/\\", target: self, action: #selector(volumeUp))
            return item
        case .VolumeDown:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = NSButton(title: "\\/", target: self, action: #selector(volumeDown))
            return item
        case .VolumeSlider:
            let item = NSSliderTouchBarItem(identifier: identifier)
            item.doubleValue = Double(NSSound.systemVolume())
            item.slider.target = self
            item.slider.action = #selector(volumeSlider)

            return item
        default:
            return touchBar.item(forIdentifier: identifier)
        }
    }

    @IBAction func volumeSlider(_ sender: NSSlider) {
        let volume = sender.floatValue

        NSSound.setSystemVolume(volume)
    }

    @objc func volumeUp() {
        NSSound.increaseSystemVolume(by: 0.1)
    }

    @objc func volumeDown() {
        NSSound.decreaseSystemVolume(by: 0.1)
    }

    @objc func togglePlayPause() {
        MRMediaRemoteSendCommand(kMRTogglePlayPause, nil)
    }

    @objc func previous() {
        MRMediaRemoteSendCommand(kMRPreviousTrack, nil)
    }

    @objc func next() {
        MRMediaRemoteSendCommand(kMRNextTrack, nil)
    }

    @objc func toggleCS() {
        hideControlStrip = !hideControlStrip
        dismiss()
        present()
        showControlStripIcon()
    }

    func showControlStripIcon() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)

        let touchy = NSCustomTouchBarItem(identifier: .CS)
        touchy.view = NSButton(title: "🦄", target: self, action: #selector(toggle))

        NSTouchBarItem.removeSystemTrayItem(touchy)
        NSTouchBarItem.addSystemTrayItem(touchy)
    }

    @objc func toggle() {
        if self.isVisible {
            self.minimize()
        } else {
            self.present()
        }
    }

    @objc func dismiss() {
        if #available(macOS 10.14, *) {
            NSTouchBar.dismissSystemModalTouchBar(groupTouchBar)
        } else {
            NSTouchBar.dismissSystemModalFunctionBar(groupTouchBar)
        }
    }

    @objc func minimize() {
        if #available(macOS 10.14, *) {
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
        if #available(macOS 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(groupTouchBar, placement: placement, systemTrayItemIdentifier: .CS)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(groupTouchBar, placement: placement, systemTrayItemIdentifier: .CS)
        }
    }
}
