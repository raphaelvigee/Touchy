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
    var alwaysHideControlStrip: Bool
    var items: [Item]
}

func decode() throws -> Config {
    let encodedYAML = """
                      alwaysHideControlStrip: true
                      items:
                      - type: "anchor"
                      - type: "previous"
                      - type: "play"
                      - type: "next"
                      - type: "flex"
                      - type: "volume_buttons"
                      """

    let decoder = YAMLDecoder()

    return try decoder.decode(Config.self, from: encodedYAML)
}
