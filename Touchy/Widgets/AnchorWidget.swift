//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

class AnchorWidget: BaseWidget, NSGestureRecognizerDelegate {
    private var buttonView: NSButton!

    private var start: CGFloat = -1
    private var swipeThreshold: CGFloat = 30

    override func item(touchBar: NSTouchBar) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: identifier)
        buttonView = NSButton(title: "⚓", target: self, action: #selector(onClick))
        styleButton()

        let oneFinger = NSPanGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        oneFinger.numberOfTouchesRequired = 1
        oneFinger.allowedTouchTypes = .direct
        buttonView.addGestureRecognizer(oneFinger)

        item.view = buttonView
        return item
    }

    func styleButton() {
        buttonView.isBordered = false
    }

    @objc func onClick() {
        if tbc.alwaysHideControlStrip {
            return
        }

        tbc.toggleCS()
    }

    @objc func onSwipe(_ sender: NSGestureRecognizer?) {
        let position = (sender?.location(in: sender?.view).x)!

        switch sender?.state {
        case .began:
            start = position
        case .changed:
            if tbc.hideControlStrip && (position - start) > swipeThreshold {
                tbc.setCS(hide: false)
                tbc.minimize()
                styleButton()
            }
        case .ended:
            styleButton()
        default:
            break
        }
    }
}
