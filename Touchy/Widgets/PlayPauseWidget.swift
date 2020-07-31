//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

class PlayPauseWidget: BaseWidget<NoArgs> {
    private var tbItem: NSCustomTouchBarItem!

    override func boot() {
        self.registerForNotifications()

        tbItem = NSCustomTouchBarItem(identifier: identifier)
        tbItem.view = NSButton(title: "", target: self, action: #selector(action))

        self.updateUI()
    }

    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                selector: #selector(updateNowPLayingItemView),
                name: NowPlayingHelper.kNowPlayingItemDidChange,
                object: nil
        )
    }

    override func getItem(touchBar: NSTouchBar) -> NSTouchBarItem? {
        return tbItem
    }

    @objc func action() {
        NowPlayingHelper.shared.togglePlayingState()
    }

    func updateUI() {
        (tbItem.view as! NSButton).title = NowPlayingHelper.shared.isPlaying ? "||" : "|>"
    }

    @objc private func updateNowPLayingItemView() {
        DispatchQueue.main.async { [weak self] in
            self?.updateUI()
        }
    }
}
