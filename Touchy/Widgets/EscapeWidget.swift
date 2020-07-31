//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

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
        print("BITE")
    }
}
