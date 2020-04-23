#!/bin/bash

clear

# Get paths.
ENVIRONMENT="venv"
PROJECT_PATH=$(dirname "$(realpath "$0")")
ENVIRONMENT_PATH=${PROJECT_PATH}/${ENVIRONMENT}

# Update repository.
git -C "${PROJECT_PATH}" pull

# Create environment if not exists.
if [[ ! -d ${ENVIRONMENT_PATH} ]]; then
    echo -e "Creating environment $ENVIRONMENT_PATH...\n\n"
    python3 -m virtualenv "${ENVIRONMENT_PATH}"
fi

# Install requirements.
echo -e "Installing requirements...\n"
"${ENVIRONMENT_PATH}"/bin/pip3 install --upgrade -r "${PROJECT_PATH}"/requirements.txt | grep -v 'already satisfied'

echo -e "Done."