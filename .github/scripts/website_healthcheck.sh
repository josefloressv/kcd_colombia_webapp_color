#!/bin/bash
set -eo pipefail

# This script checks the health of a website by sending an HTTP request and checking the response code.
# It takes the URL of the website as an argument.
# Usage: URL="https://ecs.gitops.club/Home/Health" ./.github/scripts/website_healthcheck.sh

# Arguments:
#   - URL: The URL of the website to check


echo "Checking the health of the website $URL"

# Function to check the HTTP response code of the website
RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ "$RESPONSE_CODE" = "200" ]; then
    echo "Website is healthy $RESPONSE_CODE"
    exit 0
    
else
    echo "Website is not healthy, response code $RESPONSE_CODE. Exiting..."
    exit 1
fi
