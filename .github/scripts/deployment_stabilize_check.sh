#!/bin/bash
set -eo pipefail
# This script Check the deployment stabilization.

# Configure environment
# The following environment variables are expected to be passed from the GitHub Actions workflow:
# - ECS_CLUSTER_NAME: Name of the ECS cluster
# - NEW_ACTIVE_SERVICE_NAME: Name of the inactive service

# Test
# ECS_CLUSTER_NAME=melee-windows-dev NEW_ACTIVE_SERVICE_NAME=web-dev-green ./.github/scripts/deployment_stabilize_check.sh

# Checking the service stabilized
echo "Checking the service stabilized for $NEW_ACTIVE_SERVICE_NAME..."
# Define maximum attempts and delay between attempts
MAX_ATTEMPTS=90
DELAY=20

for ((i=1; i<=MAX_ATTEMPTS; i++)); do
    # Fetch the PRIMARY deployment details
    DEPLOYMENT=$(aws ecs describe-services --cluster "$ECS_CLUSTER_NAME" --services "$NEW_ACTIVE_SERVICE_NAME" \
        --query 'services[0].deployments[?status==`PRIMARY`]' --output json)

    # Extract the necessary values from the deployment details
    ROLLOUT_STATE=$(echo "$DEPLOYMENT" | jq -r '.[0].rolloutState')
    DESIRED_COUNT=$(echo "$DEPLOYMENT" | jq -r '.[0].desiredCount')
    PENDING_COUNT=$(echo "$DEPLOYMENT" | jq -r '.[0].pendingCount')
    RUNNING_COUNT=$(echo "$DEPLOYMENT" | jq -r '.[0].runningCount')

    # Log current status
    echo "$(date +'%Y-%m-%d %H:%M:%S') Attempt $i status: rolloutState=$ROLLOUT_STATE, desiredCount=$DESIRED_COUNT, pendingCount=$PENDING_COUNT, runningCount=$RUNNING_COUNT"

    # Check if rolloutState is COMPLETED and the running count matches the desired count with no pending tasks
    if [[ "$ROLLOUT_STATE" == "COMPLETED" && "$RUNNING_COUNT" -eq "$DESIRED_COUNT" && "$PENDING_COUNT" -eq 0 ]]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') Service stabilized: PRIMARY deployment rolloutState is COMPLETED, runningCount matches desiredCount, and pendingCount is zero."
        break
    fi

    # If max attempts reached, exit with an error
    if [[ $i -eq $MAX_ATTEMPTS ]]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') Service failed to stabilize after $MAX_ATTEMPTS attempts."
        exit 1
    fi

    # Delay before next attempt
    sleep $DELAY
done
