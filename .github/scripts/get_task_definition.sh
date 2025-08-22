#!/bin/bash
set -eo pipefail

# This script retrieves the task definition for an ECS service and saves it to a JSON file.

# Configuration:
# - ECS_TASK_FAMILY: Name of the ECS task family

# Retrieve the task definition using the AWS CLI
aws ecs describe-task-definition --task-definition $ECS_TASK_FAMILY --query taskDefinition > $ECS_TASK_FAMILY.json

# Append the filename to the GITHUB_OUTPUT file
echo "file=$ECS_TASK_FAMILY.json" >> $GITHUB_OUTPUT