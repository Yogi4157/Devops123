#!/usr/bin/env bash
set -xeuo pipefail

# Optional: workspace fallback
WORKDIR="${WORKSPACE:-$(pwd)}"
cd "$WORKDIR"

# Required input (set these or pass via env)
LAUNCH_TEMPLATE_ID="${LAUNCH_TEMPLATE_ID:-lt-0123456789abcdef0}"   # replace with your template id
LAUNCH_TEMPLATE_VERSION="${LAUNCH_TEMPLATE_VERSION:-1}"            # or use "$Latest"
AWS_REGION="${AWS_REGION:-ap-south-1}"                             # choose your region
INSTANCE_COUNT="${INSTANCE_COUNT:-1}"
TAG_NAME="${TAG_NAME:-jenkins-launched}"

# Run Instances from Launch Template
aws ec2 run-instances \
  --launch-template LaunchTemplateId="$LAUNCH_TEMPLATE_ID",Version="$LAUNCH_TEMPLATE_VERSION" \
  --count "$INSTANCE_COUNT" \
  --region "$AWS_REGION" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" \
  --output json
