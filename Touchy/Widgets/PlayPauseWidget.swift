//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

class PlayPauseWidget: BaseWidget {
    private var item: NSCustomTouchBarItem?

    required init(identifier: NSTouchBarItem.Identifier, tbc: TouchBarController, args: Decodable?) {
        super.init(identifier: identifier, tbc: tbc, args: args)

        self.registerForNotifications()

        item = NSCustomTouchBarItem(identifier: identifier)

        self.updateUI()
    }

    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                selector: #selector(updateNowPLayingItemView),
                name: NowPlayingHelper.kNowPlayingItemDidChange,
                object: nil
        )
    }

    override func item(touchBar: NSTouchBar) -> NSTouchBarItem? {
        item
    }

    @objc func action() {
        NowPlayingHelper.shared.togglePlayingState()
    }

    func updateUI() {
        var view: NSButton
        if !NowPlayingHelper.shared.isPlaying {
            view = NSButton(title: "|>", target: self, action: #selector(action))
        } else {
            view = NSButton(title: "||", target: self, action: #selector(action))
        }

        self.item?.view = view
    }

    @objc private func updateNowPLayingItemView() {
        DispatchQueue.main.async { [weak self] in
            self?.updateUI()
        }
    }
}
