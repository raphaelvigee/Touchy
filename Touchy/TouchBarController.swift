//
//  TouchBarController.swift
//  Touchy
//
//  Created by Raphaël Vigée on 23/07/2020.
//  Copyright © 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

private let kBearIdentifier = NSTouchBarItem.Identifier("io.a2.Bear")
private let ktoggleCSIdentifier = NSTouchBarItem.Identifier("io.a2.ToggleCS")
private let kPandaIdentifier = NSTouchBarItem.Identifier("io.a2.Panda")
private let kGroupIdentifier = NSTouchBarItem.Identifier("io.a2.Group")

class TouchBarController: NSController, NSTouchBarDelegate {
    private var _groupTouchBar: NSTouchBar?
    private var groupTouchBar: NSTouchBar? {
        if _groupTouchBar == nil {
            let groupTouchBar = NSTouchBar()
            groupTouchBar.defaultItemIdentifiers = [ktoggleCSIdentifier, kBearIdentifier, kPandaIdentifier]
            groupTouchBar.delegate = self
            _groupTouchBar = groupTouchBar
        }

        return _groupTouchBar
    }
    private var isVisible: Bool {
        if groupTouchBar == nil {
            return false
        }

        return groupTouchBar?.isVisible ?? false
    }

    private var hideControlStrip = false

    @objc func bear() {
        print("Bear")
    }

    @objc func panda() {
        print("Panda")
    }

    func touchBar(
            _ touchBar: NSTouchBar,
            makeItemForIdentifier identifier: NSTouchBarItem.Identifier
    ) -> NSTouchBarItem? {
        if identifier.rawValue == kBearIdentifier.rawValue {
            let item = NSCustomTouchBarItem(identifier: kBearIdentifier)
            item.view = NSButton(title: "BEAR", target: self, action: #selector(bear))
            return item
        } else if identifier.rawValue == kPandaIdentifier.rawValue {
            let item = NSCustomTouchBarItem(identifier: kPandaIdentifier)
            item.view = NSButton(title: "PANDA", target: self, action: #selector(panda))
            return item
        } else if identifier.rawValue == ktoggleCSIdentifier.rawValue {
            let item = NSCustomTouchBarItem(identifier: ktoggleCSIdentifier)
            item.view = NSButton(title: "CS", target: self, action: #selector(toggleCS))
            return item
        } else {
            return nil
        }
    }

    @objc func toggleCS() {
        hideControlStrip = !hideControlStrip
        dismiss()
        present()
        showControlStripIcon()
    }

    func showControlStripIcon() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)

        let touchy = NSCustomTouchBarItem(identifier: kGroupIdentifier)
        touchy.view = NSButton(title: "🦄", target: self, action: #selector(toggle))

        NSTouchBarItem.removeSystemTrayItem(touchy)
        NSTouchBarItem.addSystemTrayItem(touchy)
    }

    @objc func toggle() {
        if self.isVisible {
            self.minimize()
        } else {
            self.present()
        }
    }

    @objc func dismiss() {
        if #available(macOS 10.14, *) {
            NSTouchBar.dismissSystemModalTouchBar(groupTouchBar)
        } else {
            NSTouchBar.dismissSystemModalFunctionBar(groupTouchBar)
        }
    }

    @objc func minimize() {
        if #available(macOS 10.14, *) {
            NSTouchBar.minimizeSystemModalTouchBar(groupTouchBar)
        } else {
            NSTouchBar.minimizeSystemModalFunctionBar(groupTouchBar)
        }
    }

    @objc func present() {
        self.presentFromSystemTrayItem()
    }

    @objc func presentFromSystemTrayItem() {
        let placement: Int64 = hideControlStrip ? 1 : 0
        self.presentWithPlacement(placement: placement)
    }

    private func presentWithPlacement(placement: Int64) {
        if #available(macOS 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(groupTouchBar, placement: placement, systemTrayItemIdentifier: kGroupIdentifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(groupTouchBar, placement: placement, systemTrayItemIdentifier: kGroupIdentifier)
        }
    }
}
