#!/bin/bash
set -eo pipefail
# This script performs the cutover to a new service by updating the listener rules on the AWS Load Balancer.
# It supports two environments: development and production.
# The script updates the listener rules to point to the target groups associated with the new and old services.


# Configure environment
# The following environment variables are expected to be passed from the GitHub Actions workflow:
# - ACTIVE_COLOR: Color of the active service (e.g., blue, green)
# - ACTIVE_HOST: Host header value for the active service
# - INACTIVE_HOST: Host header value for the inactive service
# - LOAD_BALANCER_NAME: Name of the AWS Load Balancer
# - BLUE_TARGET_GROUP_NAME: Name of the blue target group
# - GREEN_TARGET_GROUP_NAME: Name of the green target group

# Usage
# ACTIVE_COLOR=blue ACTIVE_HOST=ecs.gitops.club INACTIVE_HOST=preview.ecs.gitops.club LOAD_BALANCER_NAME=kcdcolombia-prod BLUE_TARGET_GROUP_NAME=webapp-color-prod-blue GREEN_TARGET_GROUP_NAME=webapp-color-prod-green ./.github/scripts/cutover.sh

# Get the ARN of Load Balancer resources and Target groups
LOAD_BALANCER_ARN=$(aws elbv2 describe-load-balancers --query "LoadBalancers[?LoadBalancerName=='$LOAD_BALANCER_NAME'].LoadBalancerArn" --output text)
HTTPS_LISTENER_ARN=$(aws elbv2 describe-listeners --load-balancer-arn "$LOAD_BALANCER_ARN" --query 'Listeners[?Port==`443`].ListenerArn' --output text)
RULES_JSON=$(aws elbv2 describe-rules --listener-arn "$HTTPS_LISTENER_ARN")
RULE_ACTIVE_ARN=$(echo "$RULES_JSON" | jq -r --arg host "$ACTIVE_HOST"     '.Rules[] | select(.Conditions[]? | select(.Field == "host-header") | .Values[] == $host) | .RuleArn')
RULE_INACTIVE_ARN=$(echo "$RULES_JSON" | jq -r --arg host "$INACTIVE_HOST" '.Rules[] | select(.Conditions[]? | select(.Field == "host-header") | .Values[] == $host) | .RuleArn')
BLUE_TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups --query "TargetGroups[?TargetGroupName=='$BLUE_TARGET_GROUP_NAME'].TargetGroupArn" --output text)
GREEN_TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups --query "TargetGroups[?TargetGroupName=='$GREEN_TARGET_GROUP_NAME'].TargetGroupArn" --output text)

# Update the listener rules to point to switch the target groups
if [ "$ACTIVE_COLOR" == "blue" ]; then
    # active rule in dev is expected to have more than one rule due to whitelist source IP o access the environment, so we need it to iterate over the rules
    while IFS= read -r line; do
        RULE_ARN=("$line")
        aws elbv2 modify-rule --rule-arn "$RULE_ARN" --action Type=forward,TargetGroupArn="$GREEN_TARGET_GROUP_ARN" > /dev/null
    done <<< "$RULE_ACTIVE_ARN"
    aws elbv2 modify-rule --rule-arn "$RULE_INACTIVE_ARN" --action Type=forward,TargetGroupArn="$BLUE_TARGET_GROUP_ARN" > /dev/null
    echo "Cutover complete from blue to green"
else
    # active rule in dev is expected to have more than one rule due to whitelist source IP o access the environment, so we need it to iterate over the rules
    while IFS= read -r line; do
        RULE_ARN=("$line")
        aws elbv2 modify-rule --rule-arn "$RULE_ARN" --action Type=forward,TargetGroupArn="$BLUE_TARGET_GROUP_ARN" > /dev/null
    done <<< "$RULE_ACTIVE_ARN"
    aws elbv2 modify-rule --rule-arn "$RULE_INACTIVE_ARN" --action Type=forward,TargetGroupArn="$GREEN_TARGET_GROUP_ARN" > /dev/null
    echo "Cutover complete from green to blue"
fi