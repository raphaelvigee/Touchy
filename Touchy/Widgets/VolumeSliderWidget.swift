//
// Created by Raphaël Vigée on 24/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation

class VolumeSliderWidget: BaseWidget, Widget {
    static var identifier: NSTouchBarItem.Identifier = NSTouchBarItem.Identifier("com.touchy.volumeslider")

    func item(touchBar: NSTouchBar) -> NSTouchBarItem? {
        let item = NSSliderTouchBarItem(identifier: type(of: self).identifier)
        item.doubleValue = Double(NSSound.systemVolume())
        item.slider.target = self
        item.slider.action = #selector(action)
        return item
    }

    @IBAction func action(_ sender: NSSlider) {
        let volume = sender.floatValue

        NSSound.setSystemVolume(volume)
    }
}
