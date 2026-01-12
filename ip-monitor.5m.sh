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
