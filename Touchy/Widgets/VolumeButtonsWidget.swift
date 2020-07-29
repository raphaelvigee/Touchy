//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

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
        NSSound.increaseSystemVolume(by: 0.05)
    }

    @objc func down() {
        NSSound.decreaseSystemVolume(by: 0.05)
    }
}
