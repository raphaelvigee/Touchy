//
//  TouchBarController.swift
//  Touchy
//
//  Created by Raphaël Vigée on 23/07/2020.
//  Copyright © 2020 Raphaël Vigée. All rights reserved.
//

import Foundation
import AudioToolbox

@available(OSX 10.12.2, *)
extension NSTouchBar.CustomizationIdentifier {
    static let mainTouchBar = NSTouchBar.CustomizationIdentifier("com.touchy")
}

@available(OSX 10.12.2, *)
extension NSTouchBarItem.Identifier {
    static let Touchy = NSTouchBarItem.Identifier("com.touchy.touchy")
}

protocol Widget {
    init(tbc: TouchBarController)

    static var identifier: NSTouchBarItem.Identifier { get }

    func item(touchBar: NSTouchBar) -> NSTouchBarItem?
}

class BaseWidget: NSObject {
    var tbc: TouchBarController

    required init(tbc: TouchBarController) {
        self.tbc = tbc
    }
}

class ControlStripButton: NSCustomTouchBarItem, NSGestureRecognizerDelegate {
    private var tbc: TouchBarController!

    init(identifier: NSTouchBarItem.Identifier, tbc: TouchBarController) {
        self.tbc = tbc
        super.init(identifier: identifier)

        let view = NSButton(title: "🦄", target: self, action: #selector(controlStripIconClick))

        let oneFinger = NSPanGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        oneFinger.numberOfTouchesRequired = 1
        oneFinger.allowedTouchTypes = .direct
        view.addGestureRecognizer(oneFinger)

        self.view = view
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private var start: CGFloat = -1
    private var swipeThreshold: CGFloat = 30

    @objc func onSwipe(_ sender: NSGestureRecognizer?) {
        let position = (sender?.location(in: sender?.view).x)!

        switch sender?.state {
        case .began:
            start = position
        case .changed:
            if (start - position) > swipeThreshold {
                controlStripIconClick()
            }
        default:
            break
        }
    }

    @objc func controlStripIconClick() {
        if tbc.alwaysHideControlStrip {
            tbc.setCS(hide: true)
        }

        tbc.present()
    }
}

class TouchBarController: NSObject, NSTouchBarDelegate {
    private var widgets: [NSTouchBarItem.Identifier: Widget]?

    private var groupTouchBar: NSTouchBar?
    private var isVisible: Bool {
        if groupTouchBar == nil {
            return false
        }

        return groupTouchBar?.isVisible ?? false
    }

    public var alwaysHideControlStrip = false
    public var hideControlStrip = false

    func makeTouchBar(widgets: [Widget.Type], hideControlStrip: Bool) {
        self.hideControlStrip = hideControlStrip

        self.widgets = [NSTouchBarItem.Identifier: Widget]()
        var ids = [NSTouchBarItem.Identifier]()

        widgets.forEach { wt in
            let i = wt.init(tbc: self)
            let id = type(of: i).identifier
            self.widgets?[id] = i

            ids.append(id)
        }

        groupTouchBar = NSTouchBar()
        groupTouchBar?.delegate = self
        groupTouchBar?.customizationIdentifier = .mainTouchBar
        groupTouchBar?.defaultItemIdentifiers = ids

        showControlStripIcon()
        present()
    }

    func touchBar(
            _ touchBar: NSTouchBar,
            makeItemForIdentifier identifier: NSTouchBarItem.Identifier
    ) -> NSTouchBarItem? {
        if let w = widgets?[identifier] {
            return w.item(touchBar: touchBar)
        }

        return nil
    }

    func toggleCS() {
        setCS(hide: !hideControlStrip)
    }

    func setCS(hide: Bool) {
        hideControlStrip = hide
        dismiss()
        present()
        if !hideControlStrip {
            showControlStripIcon()
        }
    }

    func showControlStripIcon() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)

        let touchy = ControlStripButton(identifier: .Touchy, tbc: self)

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
            NSTouchBar.presentSystemModalTouchBar(groupTouchBar, placement: placement, systemTrayItemIdentifier: .Touchy)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(groupTouchBar, placement: placement, systemTrayItemIdentifier: .Touchy)
        }
    }
}
