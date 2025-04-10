#!/usr/bin/env bash
# Script to connect to an EC2 instance and execute a command via SSM
# Usage: ./script.sh [--region REGION] [--stack-name STACK_NAME] [--command COMMAND] [--state STATE]

# Default values
REGION="eu-central-1"
STACK_NAME="makeMeFree"
INSTANCE_STATE="running"
COMMAND="qrencode -t ansiutf8 < /tmp/client_wg0.conf"
DOCUMENT_NAME="AWS-StartInteractiveCommand"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --region)
            REGION="$2"
            shift 2
            ;;
        --stack-name)
            STACK_NAME="$2"
            shift 2
            ;;
        --command)
            COMMAND="$2"
            shift 2
            ;;
        --state)
            INSTANCE_STATE="$2"
            shift 2
            ;;
        --document-name)
            DOCUMENT_NAME="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --region REGION        AWS region (default: eu-central-1)"
            echo "  --stack-name NAME      CloudFormation stack name (default: makeMeFree)"
            echo "  --command CMD          Command to execute on the instance (default: qrencode -t ansiutf8 < /tmp/client_wg0.conf)"
            echo "  --state STATE          Instance state to filter by (default: running)"
            echo "  --document-name NAME   SSM document name (default: AWS-StartInteractiveCommand)"
            echo "  --help                 Display this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Function to check if AWS CLI is installed
check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        echo "Error: AWS CLI is not installed. Please install it first."
        exit 1
    fi
}

# Function to get instance ID
get_instance_id() {
    local instance_id
    instance_id=$(aws ec2 describe-instances \
        --region "$REGION" \
        --filters "Name=tag:aws:cloudformation:stack-name,Values=$STACK_NAME" "Name=instance-state-name,Values=$INSTANCE_STATE" \
        --query "Reservations[0].Instances[0].InstanceId" \
        --output text)
    
    if [[ "$instance_id" == "None" || -z "$instance_id" ]]; then
        echo "Error: No instance found with stack name '$STACK_NAME' in state '$INSTANCE_STATE'"
        exit 1
    fi
    
    echo "$instance_id"
}

# Main execution
main() {
    check_aws_cli
    
    echo "Connecting to instance in stack '$STACK_NAME' in region '$REGION'..."
    local instance_id
    instance_id=$(get_instance_id)
    echo "Found instance: $instance_id"
    
    echo "Starting SSM session with command: $COMMAND"
    aws ssm start-session \
        --region "$REGION" \
        --target "$instance_id" \
        --document-name "$DOCUMENT_NAME" \
        --parameters command="$COMMAND"
}

main