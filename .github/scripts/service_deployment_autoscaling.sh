#!/bin/bash
set -eo pipefail
# This script scales out the service by updating the desired count of the old ECS service to 1.
# Also scales out the Amazon Auto Scaling Group to the desired count + 1.

# Configure environment
# The following environment variables are expected to be passed from the GitHub Actions workflow:
# - ECS_CLUSTER_NAME: Name of the ECS cluster
# - ASG_NAME: Name of the Amazon Auto Scaling Group
# - CURRENT_INACTIVE_SERVICE_NAME: Name of the inactive service
# - TASK_DESIRED_COUNT: Desired count of the autoscaling service

# To deploy and test the new version of the appllication configure minimum capacity to TASK_DESIRED_COUNT
aws application-autoscaling register-scalable-target --service-namespace ecs --resource-id "service/$ECS_CLUSTER_NAME/$CURRENT_INACTIVE_SERVICE_NAME" --scalable-dimension ecs:service:DesiredCount --min-capacity "$TASK_DESIRED_COUNT" > /dev/null
echo "Done! Service scaled out to the minimum"
