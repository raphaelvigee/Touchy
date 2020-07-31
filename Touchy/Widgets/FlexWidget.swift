//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

class FlexWidget: BaseWidget<NoArgs> {
    override func boot() {
        self.identifier = .flexibleSpace
    }

    override func getItem(touchBar: NSTouchBar) -> NSTouchBarItem? {
        return nil
        touchBar.item(forIdentifier: identifier)
    }
}
