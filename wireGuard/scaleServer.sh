#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status, add -x for debugging
set -e
# Function to display script usage

# Check if AWS CLI is installed
if ! command -v aws &>/dev/null; then
    echo "AWS CLI could not be found. Please install it to use this script."
    exit 1
fi

# Set region
REGION="eu-central-1"

# Find the Auto Scaling Group that starts with "makeMeFree" function

find_asg() {
    ASG_NAME=$(aws autoscaling describe-auto-scaling-groups \
        --region $REGION \
        --query "AutoScalingGroups[?starts_with(AutoScalingGroupName, 'makeMeFree')].AutoScalingGroupName" \
        --output text)

    if [ -z "$ASG_NAME" ]; then
        echo "No Auto Scaling Group found with name starting with 'makeMeFree'"
        exit 1
    fi

    echo "Found Auto Scaling Group: $ASG_NAME"
}

# Function to scale up to 1 instance
scale_up() {
    find_asg
    echo "Scaling up $ASG_NAME to 1 instance..."
    aws autoscaling update-auto-scaling-group \
        --region $REGION \
        --auto-scaling-group-name "$ASG_NAME" \
        --min-size 1 \
        --max-size 1 \
        --desired-capacity 1

    echo "Scale up completed."
}

# Function to scale down to 0 instances
scale_down() {
    find_asg
    echo "Scaling down $ASG_NAME to 0 instances..."
    aws autoscaling update-auto-scaling-group \
        --region $REGION \
        --auto-scaling-group-name "$ASG_NAME" \
        --min-size 0 \
        --max-size 0 \
        --desired-capacity 0

    echo "Scale down completed."
}

# Check command line arguments
case "$1" in
up)
    scale_up
    ;;
down)
    scale_down
    ;;
*)
    echo "Usage: $0 {up|down}"
    echo "  up   - Scale up to 1 instance"
    echo "  down - Scale down to 0 instances"
    exit 1
    ;;
esac

exit 0
