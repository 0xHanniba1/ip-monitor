# IP Monitor Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create a macOS menu bar app showing public IP and city using SwiftBar.

**Architecture:** Shell script executed by SwiftBar every 5 minutes, fetching IP data from ip-api.com and displaying in menu bar format.

**Tech Stack:** SwiftBar, Bash, curl, jq

---

### Task 1: Install Dependencies

**Step 1: Install jq for JSON parsing**

Run:
```bash
brew install jq
```

Expected: jq installed successfully

**Step 2: Install SwiftBar**

Run:
```bash
brew install --cask swiftbar
```

Expected: SwiftBar installed successfully

**Step 3: Commit dependency documentation**

```bash
git add -A && git commit -m "docs: add implementation plan"
```

---

### Task 2: Create Plugin Script

**Files:**
- Create: `ip-monitor.5m.sh`

**Step 1: Create the script file**

```bash
#!/bin/bash

# Configuration
TIMEOUT=10
CACHE_FILE="/tmp/ip-monitor-cache.json"

# Fetch IP info from ip-api.com
fetch_ip_info() {
    curl -s --max-time $TIMEOUT "http://ip-api.com/json/" 2>/dev/null
}

# Main logic
response=$(fetch_ip_info)

if [ -z "$response" ] || [ "$(echo "$response" | jq -r '.status' 2>/dev/null)" != "success" ]; then
    # Try to use cached data
    if [ -f "$CACHE_FILE" ]; then
        response=$(cat "$CACHE_FILE")
        ip=$(echo "$response" | jq -r '.query')
        city=$(echo "$response" | jq -r '.city')
        echo "⚠️ $ip | $city"
    else
        echo "⚠️ Offline"
    fi
    echo "---"
    echo "Network unavailable"
    echo "♻️ Refresh | refresh=true"
    exit 0
fi

# Cache the successful response
echo "$response" > "$CACHE_FILE"

# Parse response
ip=$(echo "$response" | jq -r '.query')
city=$(echo "$response" | jq -r '.city')
update_time=$(date +"%H:%M:%S")

# Menu bar title
echo "$ip | $city"
echo "---"

# Dropdown menu
echo "IP: $ip | bash='echo $ip | pbcopy' terminal=false"
echo "City: $city"
echo "---"
echo "Updated: $update_time"
echo "♻️ Refresh | refresh=true"
```

**Step 2: Make script executable**

Run:
```bash
chmod +x ip-monitor.5m.sh
```

**Step 3: Test script locally**

Run:
```bash
./ip-monitor.5m.sh
```

Expected output (example):
```
203.0.113.1 | Shanghai
---
IP: 203.0.113.1 | bash='echo 203.0.113.1 | pbcopy' terminal=false
City: Shanghai
---
Updated: 14:32:05
♻️ Refresh | refresh=true
```

**Step 4: Commit**

```bash
git add ip-monitor.5m.sh
git commit -m "feat: add ip-monitor SwiftBar plugin script"
```

---

### Task 3: Install Plugin to SwiftBar

**Step 1: Open SwiftBar**

Run:
```bash
open -a SwiftBar
```

First launch will prompt for plugins directory. Set to:
```
~/Library/Application Support/SwiftBar/
```

**Step 2: Create plugins directory if needed**

Run:
```bash
mkdir -p ~/Library/Application\ Support/SwiftBar/
```

**Step 3: Copy script to plugins directory**

Run:
```bash
cp ip-monitor.5m.sh ~/Library/Application\ Support/SwiftBar/
```

**Step 4: Verify in menu bar**

- Look for IP address in menu bar
- Click to see dropdown menu
- Test "Refresh" button
- Test copying IP by clicking "IP: xxx"

---

### Task 4: Add README

**Files:**
- Create: `README.md`

**Step 1: Create README**

```markdown
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
```

**Step 2: Commit**

```bash
git add README.md
git commit -m "docs: add README"
```

---

## Completion Checklist

- [ ] jq installed
- [ ] SwiftBar installed
- [ ] Script created and tested
- [ ] Plugin installed to SwiftBar
- [ ] IP visible in menu bar
- [ ] Dropdown menu works
- [ ] Copy IP works
- [ ] Refresh works
- [ ] README added
