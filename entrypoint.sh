#!/usr/bin/env bash
set -e

# Change to input directory if specified
if [ -d "${INPUT_APPLICATION_PATH}" ]; then
  cd ${INPUT_APPLICATION_PATH}
fi

# Raise error if no API token is provided
if [[ "${INPUT_BALENA_TOKEN}" == "" ]]; then
  echo "Error: BALENA_TOKEN is required in your GitHub secrets"
  exit 1
fi

# Write secrets file if provided
if [[ "${INPUT_BALENA_SECRETS}" != "" ]]; then
  mkdir -p ~/.balena/
  echo ${INPUT_BALENA_SECRETS} > ~/.balena/secrets.json
fi

# Log in to Balena
balena login --token ${INPUT_BALENA_TOKEN} > /dev/null

# Run commands
IFS=';' read -ra cmds <<< "$*"

for i in "${cmds[@]}"
do
    balena $i
done
