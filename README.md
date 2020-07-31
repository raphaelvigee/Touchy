# Touchy

## Installation

- Download the latest release
- Open the `dmg` and move Touchy to your `Applications` folder
- Open Touchy
- In the menu bar, click "Open config"
- Paste the following:
```yaml
alwaysHideControlStrip: true
items:
- type: "anchor"
- type: "flex"
- type: "stack"
  with:
    items:
    - type: "previous"
    - type: "play"
    - type: "next"
- type: "stack"
  with:
    items:
    - type: "volume_down"
    - type: "volume_up"
```
- In the menu bar, click "Reload config"
