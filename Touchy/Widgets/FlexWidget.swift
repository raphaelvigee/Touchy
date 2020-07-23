//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

class FlexWidget: BaseWidget, Widget {
    static var identifier: NSTouchBarItem.Identifier = .flexibleSpace

    func item(touchBar: NSTouchBar) -> NSTouchBarItem? {
        touchBar.item(forIdentifier: type(of: self).identifier)
    }
}
