#!/bin/bash
set -eo pipefail

# Description:
# This script retrieves the active and inactive colors from AWS Systems Manager (SSM) parameter store and sets them as environment variables.
# It then creates GitHub outputs for these colors, which can be used in GitHub Actions workflows.
#
# Environment Variables:
# - SSM_ACTIVE_COLOR_PARAMETER_NAME: Name of the SSM parameter that stores the active color.

# Get the active color from the SSM parameter
ACTIVE_COLOR=$(aws ssm get-parameter --name "$SSM_ACTIVE_COLOR_PARAMETER_NAME" --query Parameter.Value --output text)

# Determine the inactive color based on the active color
if [ "$ACTIVE_COLOR" == "blue" ]; then
    INACTIVE_COLOR=green
else
    INACTIVE_COLOR=blue
fi

# Create the environment variables
echo "ACTIVE_COLOR=$ACTIVE_COLOR" >> "$GITHUB_ENV"
echo "INACTIVE_COLOR=$INACTIVE_COLOR" >> "$GITHUB_ENV"

echo "Active color is $ACTIVE_COLOR"