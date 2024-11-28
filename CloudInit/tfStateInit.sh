#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display script usage
usage() {
    cat <<EOF
Usage: $0 -f <template-file-path> [-e <environment>] [-d]
  -f  Path to the CloudFormation template file (required)
  -d  Delete the stack (optional)
  -r  AWS region (default: eu-central-1)
  -e  Environment Part to append to the stack parameters (default: free)
EOF
    exit 1
}

# Default values for variables
AWS_REGION="eu-central-1"
ENVIRONMENT="free"
DELETE_STACK=false

# Parse command-line options
while getopts "f:e:dr:" opt; do
    case $opt in
    f) TEMPLATE_FILE="$OPTARG" ;;
    d) DELETE_STACK=true ;;
    r) AWS_REGION="$OPTARG" ;;
    e) ENVIRONMENT="$OPTARG" ;;
    *) usage ;;
    esac
done

# Ensure required parameters are provided
if [[ -z "$TEMPLATE_FILE" ]]; then
    usage
fi

# Verify that the template file exists
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found."
    exit 1
fi

# Derive stack name from the filename (removing directory path and extension)
STACK_NAME=$(basename "$TEMPLATE_FILE" | sed 's/\.[^.]*$//')
PARAMETER_OVERRIDES="--parameter-overrides Environment=${ENVIRONMENT} Region=${AWS_REGION}"

# Function to create or update the CloudFormation stack
create_or_update_stack() {
    echo "Creating or updating stack '$STACK_NAME'..."
    aws cloudformation deploy \
        --template-file "$TEMPLATE_FILE" \
        --stack-name "$STACK_NAME" \
        --capabilities CAPABILITY_NAMED_IAM \
        --region "$AWS_REGION" \
        $PARAMETER_OVERRIDES
}

# Function to delete the CloudFormation stack
delete_stack() {
    echo "Deleting stack '$STACK_NAME'..."
    aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$AWS_REGION"
    echo "Waiting for stack deletion to complete..."
    aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME" --region "$AWS_REGION"
    echo "Stack '$STACK_NAME' deleted successfully."
}

# Main logic to either create/update or delete the stack
if [[ "$DELETE_STACK" == true ]]; then
    # Prompt user to confirm they've deleted all content from the S3 bucket, of course it might be done automatically, but do that by yourself
    read -p "Please ensure you have deleted all content from the S3 bucket. Press any key to continue with stack deletion..." -n 1 -r
    echo # Move to a new line after pressing a key
    delete_stack
else
    create_or_update_stack
fi
