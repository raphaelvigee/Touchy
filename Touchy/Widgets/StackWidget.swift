//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

struct StackWidgetArgs: WidgetArgs {
    var items: [Item] = []

    init() {

    }
}

class StackWidget: BaseWidget<StackWidgetArgs> {
    private var widgets: [Widget]!

    override func boot() {
        widgets = args.items.enumerated().map { (i, item) in
            return item.instantiate(identifier: NSTouchBarItem.Identifier("\(identifier.rawValue).\(i)"), tbc: tbc)
        }
    }

    override func getItem(touchBar: NSTouchBar) -> NSTouchBarItem? {
        let stack = NSStackView(views: widgets.compactMap({ w in w.getItem(touchBar: touchBar)?.view }))
        stack.spacing = 1

        let item = NSCustomTouchBarItem(identifier: identifier)
        item.view = stack

        return item
    }
}
