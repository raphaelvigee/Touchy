//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

protocol KeyPress {
    var keyCode: CGKeyCode { get }
    func send()
}

struct GenericKeyPress: KeyPress {
    var keyCode: CGKeyCode
}

extension KeyPress {
    func send() {
        let src = CGEventSource(stateID: .hidSystemState)
        let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)

        let loc: CGEventTapLocation = .cghidEventTap
        keyDown?.post(tap: loc)
        keyUp?.post(tap: loc)
    }
}

class EscWidgetButton: NSButton {
    override open var intrinsicContentSize: NSSize {
        var size = super.intrinsicContentSize
        size.width = min(size.width, 64)
        return size
    }
}

class EscapeWidget: BaseWidget<NoArgs> {
    override func boot() {
        self.identifier = .ESC
    }

    override func getItem(touchBar: NSTouchBar) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: identifier)
        item.visibilityPriority = .high

        let button = EscWidgetButton(title: "ESC", target: self, action: #selector(esc))

        item.view = button

        return item
    }

    @objc func esc() {
        GenericKeyPress(keyCode: CGKeyCode(53)).send()
    }
}
