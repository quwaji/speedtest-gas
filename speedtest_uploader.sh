#!/bin/bash

# --- Configuration ---
# Set the correct PATH for Homebrew commands (crucial for cron/launchd)
# This assumes speedtest is installed via Homebrew on Apple Silicon Mac
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# !!! REPLACE WITH YOUR DEPLOYED GAS URL !!!
# Append the '?site=SITE_ID' parameter for multi-site logging
GAS_ENDPOINT="https://script.google.com/macros/s/AKfycbzHEe5Eu9XpiLqPKVsaKhhjEci9oLaxD8c-q-JQhJKZogiW-VeVXf0QhfkpkHUJsP_qqw/exec?site=FCTVE"

# Specify the Speedtest CLI command path
SPEEDTEST_CMD="/opt/homebrew/bin/speedtest"

# --- Execution ---

# 1. Run Speedtest and capture the JSON output into a variable.
#    -f json ensures JSON output.
#    --accept-license and --accept-gdpr are often necessary for automated runs.
SPEEDTEST_JSON=$($SPEEDTEST_CMD -s 944 -f json --accept-license --accept-gdpr)

# Check if the command was successful and generated JSON output
if [ $? -ne 0 ] || [ -z "$SPEEDTEST_JSON" ]; then
    echo "$(date): Speedtest failed or returned empty data." >> ~/speedtest_uploader.log
    exit 1
fi

# 2. POST the JSON data to the GAS Web App endpoint using curl.
#    -X POST: Specifies the HTTP method.
#    -H "Content-Type...": Informs the server the body is JSON.
#    --data-binary: Sends the exact contents of the variable as the request body.
#    The curl output is logged to help diagnose any network or GAS errors.
echo "$(date): Attempting to post data..." >> /tmp/speedtest_uploader.log

CURL_RESPONSE=$(curl -X POST \
  -H "Content-Type: application/json" \
  --data-binary "$SPEEDTEST_JSON" \
  "$GAS_ENDPOINT" 2>&1)

CURL_EXIT_CODE=$?

if [ $CURL_EXIT_CODE -eq 0 ]; then
    echo "$(date): Data successfully posted. Response: $CURL_RESPONSE" >> /tmp/speedtest_uploader.log
else
    echo "$(date): ERROR posting data! Curl Exit Code: $CURL_EXIT_CODE. Response: $CURL_RESPONSE" >> ~/speedtest_uploader.log
fi

exit 0
