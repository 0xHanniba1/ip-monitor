# IP Monitor

A lightweight macOS menu bar app that displays your public IP address and city.

## Features

- Shows IP and city in menu bar
- Auto-refresh every 5 minutes
- Manual refresh option
- Click to copy IP
- Offline detection with cached data

## Installation

1. Install dependencies:
   ```bash
   brew install jq
   brew install --cask swiftbar
   ```

2. Open SwiftBar and set plugins directory to `~/Library/Application Support/SwiftBar/`

3. Copy the plugin:
   ```bash
   cp ip-monitor.5m.sh ~/Library/Application\ Support/SwiftBar/
   ```

## Data Source

IP information from [ip-api.com](http://ip-api.com).
