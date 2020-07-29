//
// Created by Raphaël Vigée on 23/07/2020.
// Copyright (c) 2020 Raphaël Vigée. All rights reserved.
//

import Foundation
import Yams

struct Item: Codable {
    var type: String
    var args: [String]?
}

struct Config: Codable {
    var defaultHideControlStrip: Bool
    var items: [Item]
}

func decode() -> Config {
    let encodedYAML = """
                      defaultHideControlStrip: true
                      items:
                      - type: "anchor"
                      - type: "previous"
                      - type: "play"
                      - type: "next"
                      - type: "flex"
                      - type: "volume_down"
                      - type: "volume_up"
                      """

    let decoder = YAMLDecoder()
    var config: Config
    do {
        config = try decoder.decode(Config.self, from: encodedYAML)
    } catch {
        print(error)
        return Config(defaultHideControlStrip: false, items: [])
    }

    return config
}
