//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

class PreviousWidget: BaseWidget, Widget {
    static var identifier: NSTouchBarItem.Identifier = NSTouchBarItem.Identifier("com.touchy.previous")

    func item(touchBar: NSTouchBar) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: type(of: self).identifier)
        item.view = NSButton(title: "<", target: self, action: #selector(action))
        return item
    }

    @objc func action() {
        MRMediaRemoteSendCommand(kMRPreviousTrack, nil)
    }
}
