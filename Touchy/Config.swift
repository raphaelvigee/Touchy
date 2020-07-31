//
// Created by Raphaël Vigée on 23/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation
import Yams

func typeToWidget(id: String) -> Widget.Type {
    switch id {
    case "anchor":
        return AnchorWidget.self
    case "previous":
        return PreviousWidget.self
    case "play":
        return PlayPauseWidget.self
    case "next":
        return NextWidget.self
    case "volume_up":
        return VolumeUpWidget.self
    case "volume_down":
        return VolumeDownWidget.self
    case "flex":
        return FlexWidget.self
    case "stack":
        return StackWidget.self
    default:
        fatalError("invalid type \(id)")
    }
}

struct Item: Decodable {
    var type: String
    var args: Decodable

    var widgetType: Widget.Type

    enum CodingKeys: String, CodingKey {
        case type
        case args = "with"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        type = try values.decode(String.self, forKey: .type)

        widgetType = typeToWidget(id: type)

        if values.contains(.args) {
            args = try widgetType.argsType.init(from: values.superDecoder(forKey: .args))
        } else {
            args = widgetType.argsType.init()
        }
    }

    func instantiate(identifier: NSTouchBarItem.Identifier, tbc: TouchBarController) -> Widget {
        let t = typeToWidget(id: type)

        return t.init(identifier: identifier, tbc: tbc, args: args)
    }
}

struct Config: Decodable {
    var alwaysHideControlStrip: Bool
    var items: [Item]
}

func decode(encodedYAML: String) throws -> Config {
    let decoder = YAMLDecoder()

    return try decoder.decode(Config.self, from: encodedYAML)
}
