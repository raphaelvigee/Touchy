//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

class AnchorWidget: BaseWidget, Widget {
    static var identifier: NSTouchBarItem.Identifier = NSTouchBarItem.Identifier("com.touchy.anchor")

    func item(touchBar: NSTouchBar) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: type(of: self).identifier)
        let view = NSButton(title: "⚓️", target: self, action: #selector(action))
        view.isBordered = false

        item.view = view
        return item
    }

    @objc func action() {
        tbc.toggleCS()
    }
}
