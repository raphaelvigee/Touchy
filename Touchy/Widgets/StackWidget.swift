//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

struct StackWidgetArgs: Decodable {
    var items: [Item]
}

class StackWidget: BaseWidget {
    override class var argsType: Optional<Decodable.Type> {
        get {
            StackWidgetArgs.self
        }
    }

    private var widgets: [Widget]

    required init(identifier: NSTouchBarItem.Identifier, tbc: TouchBarController, args: Decodable?) {
        if let stackArgs = (args as? StackWidgetArgs) {
            widgets = stackArgs.items.enumerated().map { (i, item) in
                return item.instantiate(identifier: NSTouchBarItem.Identifier("\(identifier.rawValue).\(i)"), tbc: tbc)
            }
        } else {
            widgets = []
        }

        super.init(identifier: identifier, tbc: tbc, args: args)
    }


    override func item(touchBar: NSTouchBar) -> NSTouchBarItem? {
        let stack = NSStackView(views: widgets.compactMap({ w in (w.item(touchBar: touchBar)?.view)}))
        stack.spacing = 1

        let item = NSCustomTouchBarItem(identifier: identifier)
        item.view = stack

        return item
    }
}
