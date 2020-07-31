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
    static let ESC = NSTouchBarItem.Identifier("com.touchy.escape")
}

protocol WidgetArgs: Decodable {
    init()
}

protocol Widget {
    static var argsType: WidgetArgs.Type { get }

    var identifier: NSTouchBarItem.Identifier { get }

    func getItem(touchBar: NSTouchBar) -> NSTouchBarItem?

    init(identifier: NSTouchBarItem.Identifier, tbc: TouchBarController, args: WidgetArgs)
}

class NoArgs: WidgetArgs {
    required init() {

    }
}

class BaseWidget<T: WidgetArgs>: NSObject, Widget {
    class var argsType: WidgetArgs.Type {
        T.self
    }
    var identifier: NSTouchBarItem.Identifier
    var tbc: TouchBarController
    var args: T

    required init(identifier: NSTouchBarItem.Identifier, tbc: TouchBarController, args: WidgetArgs) {
        self.identifier = identifier
        self.tbc = tbc
        self.args = args as! T
        super.init()

        self.boot()
    }

    func getItem(touchBar: NSTouchBar) -> NSTouchBarItem? {
        fatalError("item(touchBar:) has not been implemented")
    }

    func boot() {
        // To override in sub classes, called after init
    }
}

class ControlStripButton: NSCustomTouchBarItem, NSGestureRecognizerDelegate {
    private var tbc: TouchBarController!

    init(tbc: TouchBarController) {
        self.tbc = tbc
        super.init(identifier: .Touchy)

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

class TouchBarController: NSResponder, NSTouchBarDelegate {
    private var widgets: [Item]?
    private var idWidgets: [NSTouchBarItem.Identifier: Widget]?
    private var ids: [NSTouchBarItem.Identifier]?

    override var touchBar: NSTouchBar? {
        willSet {
            if touchBar != nil {
                dismiss()
            }
        }

        didSet {
            present()
        }
    }

    func reload(widgets: [Item], hideControlStrip: Bool) {
        self.hideControlStrip = hideControlStrip

        self.widgets = widgets

        self.idWidgets = [NSTouchBarItem.Identifier: Widget]()
        self.ids = [NSTouchBarItem.Identifier]()

        widgets.enumerated().forEach { (i, item) in
            let inst = item.instantiate(identifier: NSTouchBarItem.Identifier("com.touchy.item\(i)"), tbc: self) as Widget
            let id = inst.identifier
            self.idWidgets?[id] = inst

            ids?.append(id)
        }

        self.touchBar = nil
    }

    private var isVisible: Bool {
        if touchBar == nil {
            return false
        }

        return touchBar?.isVisible ?? false
    }

    public var alwaysHideControlStrip = false
    public var hideControlStrip = false

    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .mainTouchBar
        touchBar.defaultItemIdentifiers = ids!
        touchBar.escapeKeyReplacementItemIdentifier = .ESC

        return touchBar
    }

    func touchBar(
            _ touchBar: NSTouchBar,
            makeItemForIdentifier identifier: NSTouchBarItem.Identifier
    ) -> NSTouchBarItem? {
        if let w = idWidgets?[identifier] {
            return w.getItem(touchBar: touchBar)
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

        let touchy = ControlStripButton(tbc: self)

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
            NSTouchBar.dismissSystemModalTouchBar(touchBar)
        } else {
            NSTouchBar.dismissSystemModalFunctionBar(touchBar)
        }
    }

    @objc func minimize() {
        if #available(macOS 10.14, *) {
            NSTouchBar.minimizeSystemModalTouchBar(touchBar)
        } else {
            NSTouchBar.minimizeSystemModalFunctionBar(touchBar)
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
            NSTouchBar.presentSystemModalTouchBar(touchBar, placement: placement, systemTrayItemIdentifier: .Touchy)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, placement: placement, systemTrayItemIdentifier: .Touchy)
        }
    }
}
