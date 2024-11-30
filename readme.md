# Secure Server Deployment System

## Overview

This repository is dedicated to creating a system for deploying secure servers. These servers are designed to improve the availability of information that may be intentionally or unintentionally blocked in an attempt to alter reality and influence users' intentions, primarily in Belarus.

## Purpose

The main goal of this project is to:

1. Enhance access to potentially censored or restricted information
2. Provide a secure and reliable platform for hosting sensitive data
3. Counter attempts to manipulate public opinion through information control
4. Ensure freedom of information, especially for users in Belarus

## Features

- Secure server deployment
- Enhanced accessibility to blocked content
- Protection against censorship and information manipulation
- Applicable for everyone

## Contributing

We welcome contributions from developers, security experts, and anyone interested in promoting freedom of information. Please read our contributing guidelines before submitting pull requests.

## Disclaimer

This project is intended for legal and ethical use only. Users should comply with all applicable laws and regulations in their jurisdiction.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

TODO:
aws ssm start-session     --region eu-central-1     --target $(aws ec2 describe-instances \
        --region eu-central-1 \
        --filters "Name=tag:aws:cloudformation:stack-name,Values=makeMeFree" "Name=instance-state-name,Values=running" \
        --query "Reservations[0].Instances[0].InstanceId" \
        --output text)     --document-name AWS-StartInteractiveCommand     --parameters command="qrencode -t ansiutf8 < /tmp/client_wg0.conf"
Install wireguard localy
random port number