#!/bin/bash
set -eo pipefail
# This script scales in the service by updating the desired count of the old ECS service to 0.

# Configure environment
# The following environment variables are expected to be passed from the GitHub Actions workflow:
# - ECS_CLUSTER_NAME: Name of the ECS cluster
# - CURRENT_ACTIVE_SERVICE_NAME: Name of the active service

# To avoid scaling up to the service autoscaling, configure minimum capacity to INACTIVE_TASK_DESIRED_COUNT
aws application-autoscaling register-scalable-target --service-namespace ecs --resource-id "service/$ECS_CLUSTER_NAME/$CURRENT_ACTIVE_SERVICE_NAME" --scalable-dimension ecs:service:DesiredCount --min-capacity "$INACTIVE_TASK_DESIRED_COUNT" >> /dev/null

# Scale down the service by updating the desired count to 0
aws ecs update-service --cluster "$ECS_CLUSTER_NAME" --service "$CURRENT_ACTIVE_SERVICE_NAME" --desired-count "$INACTIVE_TASK_DESIRED_COUNT" >> /dev/null

echo "Service scaled down"
