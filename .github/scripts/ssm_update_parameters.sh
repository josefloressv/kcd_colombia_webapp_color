#!/bin/bash
set -eo pipefail

# Updates the active color and Docker tag in AWS Systems Manager (SSM) parameter store.

# Configure environment
# The following environment variables are expected to be passed from the GitHub Actions workflow:
# - NEW_ACTIVE_COLOR: Color of the inactive service (e.g., blue, green)
# - IMAGE_TAG: Tag of the new Docker image
# - SSM_ACTIVE_COLOR_PARAMETER_NAME: Name of the SSM parameter to store the active color
# - SSM_DOCKER_TAG_PARAMETER_NAME: Name of the SSM parameter to store the latest Docker tag

# Update active color in parameter store
aws ssm put-parameter --name "$SSM_ACTIVE_COLOR_PARAMETER_NAME" --type "String" --value "$NEW_ACTIVE_COLOR" --overwrite

# Update Docker tag in parameter store
aws ssm put-parameter --name "$SSM_DOCKER_TAG_PARAMETER_NAME" --type "String" --value "$IMAGE_TAG" --overwrite

# Prints a success message with the updated active color and Docker tag.
echo "Active color updated to $NEW_ACTIVE_COLOR and Docker tag updated to $IMAGE_TAG"
