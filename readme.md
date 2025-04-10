# BelKeeper WireGuard VPN Server

This repository contains scripts and configurations to deploy and manage a WireGuard VPN server on AWS using CloudFormation and Auto Scaling.

## Features

- **Automated Deployment**: Deploy a WireGuard VPN server using AWS CloudFormation.
- **Auto Scaling**: Scale the server up or down based on demand.
- **Secure Configuration**: Automatically configure WireGuard with secure keys and firewall rules.
- **Client Configuration**: Generate client configuration files and QR codes for easy setup.

## Prerequisites

- AWS CLI installed and configured with appropriate permissions.
- Bash shell environment.
- jq (JSON processor) installed for parsing AWS CLI outputs.

## Files Overview

### `/wireGuard/makeMeFree.yaml`
CloudFormation template to deploy the WireGuard VPN server. It includes:
- Security Group for WireGuard.
- IAM Role and Instance Profile for EC2.
- Launch Template for the WireGuard server.
- Auto Scaling Group to manage server instances.

### `/wireGuard/scaleServer.sh`
Bash script to scale the Auto Scaling Group up or down:
- `up`: Scales the group to 1 instance.
- `down`: Scales the group to 0 instances.

### `/wireGuard/init.sh`
Bash script to deploy or delete the CloudFormation stack:
- Create or update the stack with the required parameters.
- Delete the stack when no longer needed.

### `/wireGuard/generateQR.sh`
Bash script to connect to the EC2 instance via AWS SSM and generate a QR code for the WireGuard client configuration.

## Usage

### 1. Deploy the CloudFormation Stack
Run the `init.sh` script to deploy the stack:
```bash
./init.sh -f /path/to/makeMeFree.yaml
```
Optional flags:
- `-e`: Specify the environment (default: `free`).
- `-r`: Specify the AWS region (default: `eu-central-1`).
- `-d`: Delete the stack.

### 2. Scale the Server
Use the `scaleServer.sh` script to scale the server:
```bash
./scaleServer.sh up   # Scale up to 1 instance
./scaleServer.sh down # Scale down to 0 instances
```

### 3. Generate Client QR Code
Run the `generateQR.sh` script to generate a QR code for the client configuration:
```bash
./generateQR.sh --stack-name makeMeFree
```
Optional flags:
- `--region`: Specify the AWS region (default: `eu-central-1`).
- `--command`: Customize the command executed on the instance.

## Outputs
- **Client Configuration File**: `/tmp/client_wg0.conf` on the EC2 instance.
- **QR Code**: `/tmp/wireguard_config_qr.png` on the EC2 instance.

## Cleanup
To delete the stack and all associated resources, run:
```bash
./init.sh -f /path/to/makeMeFree.yaml -d
```

## Notes
- Ensure the AWS CLI is authenticated and has the necessary permissions.
- The scripts assume a default VPC and public subnets are available in the specified region.

## License
This project is licensed under the MIT License.
