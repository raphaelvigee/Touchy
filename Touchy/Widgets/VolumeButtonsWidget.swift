//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

let NX_KEYTYPE_SOUND_UP: UInt32 = 0
let NX_KEYTYPE_SOUND_DOWN: UInt32 = 1
let NX_KEYTYPE_PLAY: UInt32 = 16
let NX_KEYTYPE_NEXT: UInt32 = 17
let NX_KEYTYPE_PREVIOUS: UInt32 = 18
let NX_KEYTYPE_FAST: UInt32 = 19
let NX_KEYTYPE_REWIND: UInt32 = 20

func HIDPostAuxKey(key: UInt32) {
    func doKey(down: Bool) {
        let flags = NSEvent.ModifierFlags(rawValue: (down ? 0xa00 : 0xb00))
        let data1 = Int((key << 16) | (down ? 0xa00 : 0xb00))

        let ev = NSEvent.otherEvent(with: NSEvent.EventType.systemDefined,
                location: NSPoint(x: 0, y: 0),
                modifierFlags: flags,
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                subtype: 8,
                data1: data1,
                data2: -1
        )
        let cev = ev?.cgEvent
        cev?.post(tap: CGEventTapLocation.cghidEventTap)
    }

    doKey(down: true)
    doKey(down: false)
}

class VolumeButtonsWidget: BaseWidget, Widget {
    static var identifier: NSTouchBarItem.Identifier = NSTouchBarItem.Identifier("com.touchy.volumebuttons")

    func item(touchBar: NSTouchBar) -> NSTouchBarItem? {
        let downItem = NSButton(title: "\\/", target: self, action: #selector(down))
        let upItem = NSButton(title: "/\\", target: self, action: #selector(up))

        let stack = NSStackView(views: [downItem, upItem])
        stack.spacing = 1

        let item = NSCustomTouchBarItem(identifier: type(of: self).identifier)
        item.view = stack

        return item
    }

    @objc func up() {
        HIDPostAuxKey(key: NX_KEYTYPE_SOUND_UP)
    }

    @objc func down() {
        HIDPostAuxKey(key: NX_KEYTYPE_SOUND_DOWN)
    }
}
