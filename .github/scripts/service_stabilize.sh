#!/bin/bash
set -eo pipefail
# This script stabilizes the service by updating the new ECS service to the desired count of the old service.

# Configure environment
# The following environment variables are expected to be passed from the GitHub Actions workflow:
# - ECS_CLUSTER_NAME: Name of the ECS cluster
# - CURRENT_ACTIVE_SERVICE_NAME: Name of the active service
# - NEW_ACTIVE_SERVICE_NAME: Name of the inactive service
# - SSM_LIVE_SERVICE_MINIMUM_TASKS_PARAMETER_NAME: Name of the SSM parameter for the minimum number of tasks for the live service

# Test
# ECS_CLUSTER_NAME=melee-windows-dev CURRENT_ACTIVE_SERVICE_NAME=web-dev-blue NEW_ACTIVE_SERVICE_NAME=web-dev-green SSM_LIVE_SERVICE_MINIMUM_TASKS_PARAMETER_NAME=/melee/web/dev/live_service_minimum_tasks ./.github/scripts/service_stabilize.sh


# Get the desired count of the old service
DESIRED_COUNT=$(aws ecs describe-services --cluster "$ECS_CLUSTER_NAME" --services "$CURRENT_ACTIVE_SERVICE_NAME" --query 'services[0].desiredCount' --output text)
echo "Desired count of $CURRENT_ACTIVE_SERVICE_NAME is $DESIRED_COUNT"
MINIMUM_TASKS=$(aws ssm get-parameter --name "$SSM_LIVE_SERVICE_MINIMUM_TASKS_PARAMETER_NAME" --query Parameter.Value --output text)
echo "Minimum number of tasks in $SSM_LIVE_SERVICE_MINIMUM_TASKS_PARAMETER_NAME is $MINIMUM_TASKS"

# Make sure the desired count is at least the minimum number of tasks
if [ "$DESIRED_COUNT" -lt "$MINIMUM_TASKS" ]; then
  DESIRED_COUNT=$MINIMUM_TASKS
fi
echo "Desired count of $NEW_ACTIVE_SERVICE_NAME will be updated to $DESIRED_COUNT"

# Update the desired count of the new service to match the old service
aws application-autoscaling register-scalable-target --service-namespace ecs --resource-id "service/$ECS_CLUSTER_NAME/$NEW_ACTIVE_SERVICE_NAME" --scalable-dimension ecs:service:DesiredCount --min-capacity "$MINIMUM_TASKS" >> /dev/null
aws ecs update-service --cluster "$ECS_CLUSTER_NAME" --service "$NEW_ACTIVE_SERVICE_NAME" --desired-count "$DESIRED_COUNT" > /dev/null
echo "Desired count of $NEW_ACTIVE_SERVICE_NAME updated to $DESIRED_COUNT"

# Wait for the update to take effect
sleep 15

# Check the deployment stabilization
./.github/scripts/deployment_stabilize_check.sh
