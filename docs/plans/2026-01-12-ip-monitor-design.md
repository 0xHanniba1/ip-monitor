# IP Monitor - macOS Menu Bar App Design

## Overview

A lightweight macOS menu bar application that displays the current public IP address and city location.

## Technical Approach

**Solution:** SwiftBar + Shell Script

- SwiftBar: Menu bar plugin manager (install via Homebrew)
- Shell script: Single `.sh` file in SwiftBar plugins directory

## Display

**Menu Bar:**
```
203.0.113.1 | Shanghai
```

**Dropdown Menu:**
```
203.0.113.1 | Shanghai
---
IP: 203.0.113.1          (click to copy)
City: Shanghai
---
Updated: 14:32:05
♻️ Refresh
---
Quit SwiftBar
```

## Data Source

**API:** ip-api.com

Request:
```
GET http://ip-api.com/json/
```

Response:
```json
{
  "query": "203.0.113.1",
  "city": "Shanghai",
  ...
}
```

## Refresh Strategy

- Auto-refresh: Every 5 minutes (configured via filename `ip-monitor.5m.sh`)
- Manual refresh: Click "Refresh" in dropdown menu

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Network unavailable | Display `⚠️ Offline` |
| Request timeout | 10 second timeout, show last known data or `⚠️ Offline` |

## File Structure

```
~/Library/Application Support/SwiftBar/
└── ip-monitor.5m.sh
```

## Installation Steps

1. Install SwiftBar: `brew install swiftbar`
2. Open SwiftBar, set plugins directory
3. Copy `ip-monitor.5m.sh` to plugins directory
4. Make executable: `chmod +x ip-monitor.5m.sh`

## Dependencies

- macOS
- Homebrew
- SwiftBar
- curl (pre-installed on macOS)
- jq (for JSON parsing)
