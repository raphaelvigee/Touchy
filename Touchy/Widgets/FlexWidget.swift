//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

class FlexWidget: BaseWidget {
    required init(identifier: NSTouchBarItem.Identifier, tbc: TouchBarController, args: Decodable?) {
        super.init(identifier: identifier, tbc: tbc, args: args)
        self.identifier = .flexibleSpace
    }

    override func item(touchBar: NSTouchBar) -> NSTouchBarItem? {
        touchBar.item(forIdentifier: identifier)
    }
}
