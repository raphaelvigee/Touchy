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
    var items: [Item]
}

func decode() -> Config {
    let encodedYAML = """
                      items:
                      - type: "anchor"
                      - type: "previous"
                      - type: "play"
                      - type: "next"
                      - type: "flex"
                      - type: "volume_slider"
                      - type: "volume_up"
                      - type: "volume_down"
                      """

    let decoder = YAMLDecoder()
    var config: Config
    do {
        config = try decoder.decode(Config.self, from: encodedYAML)
    } catch {
        print(error)
        return Config(items: [])
    }

    return config
}
