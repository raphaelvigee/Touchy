//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

class NowPlayingHelper {
    public static let shared: NowPlayingHelper = NowPlayingHelper()
    public static let kNowPlayingItemDidChange: Notification.Name = Notification.Name(rawValue: "kNowPlayingItemDidChange")

    public var isPlaying = false

    private init() {
        MRMediaRemoteRegisterForNowPlayingNotifications(DispatchQueue.global(qos: .utility))
        registerForNotifications()
        updateCurrentPlayingState()
    }

    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                selector: #selector(updateCurrentPlayingState),
                name: NSNotification.Name.mrMediaRemoteNowPlayingApplicationIsPlayingDidChange,
                object: nil
        )
    }

    @objc private func updateCurrentPlayingState() {
        MRMediaRemoteGetNowPlayingApplicationIsPlaying(DispatchQueue.global(qos: .utility), {[weak self] isPlaying in
            self?.isPlaying = isPlaying

            NotificationCenter.default.post(name: NowPlayingHelper.kNowPlayingItemDidChange, object: nil)
        })
    }
}

extension NowPlayingHelper {
    public func togglePlayingState() {
        MRMediaRemoteSendCommand(kMRTogglePlayPause, nil)
    }

    public func skipToNextTrack() {
        MRMediaRemoteSendCommand(kMRNextTrack, nil)
    }

    public func skipToPreviousTrack() {
        MRMediaRemoteSendCommand(kMRPreviousTrack, nil)
    }
}
