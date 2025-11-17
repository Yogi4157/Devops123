#!/bin/bash
set -euo pipefail

# --- required variables (edit values or pass via env)
REGION="${REGION:-ap-south-1}"
LAUNCH_TEMPLATE_ID="${LAUNCH_TEMPLATE_ID:-lt-079000c4825cecf8f}"

echo "Launching EC2 instance using Launch Template ${LAUNCH_TEMPLATE_ID}"
echo "AWS Region: ${REGION}"

# verify aws CLI exists
if ! command -v aws >/dev/null 2>&1; then
  echo "aws CLI not found. Install awscli or ensure PATH is correct." >&2
  exit 2
fi

# run the instance (returns instance id)
instance_id=$(aws ec2 run-instances \
  --launch-template "LaunchTemplateId=${LAUNCH_TEMPLATE_ID}" \
  --region "${REGION}" \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "Launched instance: ${instance_id}"
